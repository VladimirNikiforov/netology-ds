-- Проектная работа по модулю "SQL и получение данных"
-- ФИО: Никифоров Владимир
-- SQL
-- Написать не менее 10 SQL запросов к базе данных. 
-- В запросах должны быть отражены как базовые команды, так и аналитические функции (не менее 3 запросов). 
-- Должно присутствовать описание того, что вы получаете путем каждого запроса.

select * from stores;
select * from products;
select * from calendar;
select * from sales;
select * from ProductsHierarchies;
select * from ProductsHierarchyTree;
select * from ProductsHierarchyLink;
select * from StoresHierarchies;
select * from StoresHierarchyTree;
select * from StoresHierarchyLink;
select * from ProductsAttributes;
select * from ProductsAttrLink;
select * from StoresAttributes;
select * from StoresAttrLink;
commit;

--================ 1. Получим товарную иерархию с товарами ================
-- Построим дерево товаров с помощью рекурсивного CTE:
with recursive cte as (
   select pid, preset_id, name_, 1 lvl
     from ProductsHierarchyTree
    where tree_id = 1
	  and pid is null
    union all
   Select t.pid, t.preset_id, t.name_, c.lvl + 1
     from cte c
     join ProductsHierarchyTree t ON t.pid = c.preset_id
   )
select preset_id, name_, lvl
  from cte
 order by lvl;
commit;
-- Выглядит ужасно (сначала идут элементы уровня 1, потом уровня 2, потом уровня 3)
-- Попробуем так:
WITH RECURSIVE cte AS (
SELECT pl.preset_id::varchar, pl.pid::varchar, ARRAY[name_]::varchar as path
 FROM ProductsHierarchyTree pl
 WHERE tree_id = 1 and pl.pid is null
 UNION ALL
 SELECT t2.preset_id::varchar, t2.pid::varchar, (cte.path || '/'|| t2.name_)::varchar
 FROM ProductsHierarchyTree as t2 inner join cte on (cte.preset_id=t2.pid::varchar)
)
SELECT preset_id, path as path
  FROM cte;
-- Уже лучше - подобие sys_connect_by_path, но всё-равно сортировка по уровням.
-- Можно было бы конечно отсортировать по preset_id, но это не наш подход => ставим tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;
-- Только сначала сделаем спеуциальную view с объедененным товарным деревом и товаром
drop view if exists v_products_hierarchy;
create or replace view v_products_hierarchy as
select preset_id, pid, name_, tree_id, null product_id, name_ preset_name, null product_name
  from ProductsHierarchyTree
 union all
select (-1000)*l.preset_id + p.product_id preset_id, l.preset_id pid, p.name_, t.tree_id, p.product_id, null preset_name, p.name_ product_name
  from ProductsHierarchyLink l
  join ProductsHierarchyTree t on l.preset_id = t.preset_id
  join products p on l.product_id = p.product_id;
commit;
-- А теперь повеселимся:
with recursive tree_full_names as (
select pl.preset_id::varchar, pl.pid::varchar, ARRAY[name_]::varchar as path
  from v_products_hierarchy pl
 where tree_id = 1
   and pl.pid is null
 union all
select t2.preset_id::varchar, t2.pid::varchar, (cte.path ||'/'|| t2.name_)::varchar
  from v_products_hierarchy as t2
  join tree_full_names cte on cte.preset_id = t2.pid::varchar
),
nice_tree as (select preset_id, pid, level lvl, row_number() over() order_
			    from connectby('v_products_hierarchy', 'preset_id', 'pid', '101', 0)
 					 as t(preset_id integer, pid integer, level int)
			 )
select t.*, v.product_id, preset_name, product_name, tfn.path product_full_name
  from nice_tree t
  	   join tree_full_names tfn on t.preset_id::varchar = tfn.preset_id
  	   join v_products_hierarchy v on t.preset_id = v.preset_id
 order by order_;
--================ 2. Получим продажи товара через товарную иерархию ================
-- Круто! Посмотрим продажи товара через товарную иерархию
-- Чтобы не гонять весь код построения дерева - обернем во view:
drop view if exists v_product_tree;
create or replace view v_product_tree as
with recursive tree_full_names as (
select pl.preset_id::varchar, pl.pid::varchar, ARRAY[name_]::varchar as path
  from v_products_hierarchy pl
 where tree_id = 1
   and pl.pid is null
 union all
select t2.preset_id::varchar, t2.pid::varchar, (cte.path ||'/'|| t2.name_)::varchar
  from v_products_hierarchy as t2
  join tree_full_names cte on cte.preset_id = t2.pid::varchar
),
nice_tree as (select preset_id, pid, level lvl, row_number() over() order_
			    from connectby('v_products_hierarchy', 'preset_id', 'pid', '101', 0)
 					 as t(preset_id integer, pid integer, level int)
			 )
select t.*, v.product_id, preset_name, product_name, tfn.path product_full_name
  from nice_tree t
  	   join tree_full_names tfn on t.preset_id::varchar = tfn.preset_id
  	   join v_products_hierarchy v on t.preset_id = v.preset_id
 order by order_;
commit;
-- Итак, продажи товара через товарную иерархию:
select product_full_name, product_name, order_, sum(s.qty) qty
  from v_product_tree v
  left join sales s on v.product_id = s.product_id
 group by product_full_name, product_name, order_
 order by order_;
commit;
--================ 3. Получим продажи товара по всей товарной иерархии ================
-- Да, продажи есть на товаре, но теперь уже хочется получить суммы и вверх по дереву
with tt as (select preset_id, pid, sum(s.qty) qty
			  from v_product_tree v
			  left join sales s on v.product_id = s.product_id
			 group by preset_id, pid
			),
sls as (
with recursive tree_sales as (
select pl.preset_id, pl.pid, qty
  from tt pl
 where qty is not null
 union all
select t2.preset_id, t2.pid, cte.qty qty
  from tt t2
  join tree_sales cte on cte.pid = t2.preset_id
)
select * from tree_sales),
presets_sum as (select preset_id, sum(qty) qty_sum from sls group by preset_id order by preset_id)
select product_full_name product, qty_sum total_sum
  from v_product_tree v
  join presets_sum p on v.preset_id = p.preset_id
 order by order_;

--================ 4. Получим продажи в разрезе магазинной иерархии ================
-- сначала подготовим вью - альтернативный вариант - параметризированная функция (чтобы номер дерева подавать в функцию)
drop view if exists v_obj_hierarchy;
create or replace view v_obj_hierarchy as
select preset_id, pid, name_, tree_id, null store_id, name_ preset_name, null store_name
  from StoresHierarchyTree
 union all
select (-1000)*l.preset_id + p.store_id preset_id, l.preset_id pid, p.name_, t.tree_id, p.store_id, null preset_name, p.name_ store_name
  from StoresHierarchyLink l
  join StoresHierarchyTree t on l.preset_id = t.preset_id
  join Stores p on l.store_id = p.store_id;
commit;
-- а теперь сами продажи по магазинам
with v_obj_tree as (
with recursive tree_full_names as (
select pl.preset_id::varchar, pl.pid::varchar, ARRAY[name_]::varchar as path
  from v_obj_hierarchy pl
 where tree_id = 1
   and pl.pid is null
 union all
select t2.preset_id::varchar, t2.pid::varchar, (cte.path ||'/'|| t2.name_)::varchar
  from v_obj_hierarchy as t2
  join tree_full_names cte on cte.preset_id = t2.pid::varchar
),
nice_tree as (select preset_id, pid, level lvl, row_number() over() order_
			    from connectby('v_obj_hierarchy', 'preset_id', 'pid', '1', 0)
 					 as t(preset_id integer, pid integer, level int)
			 )
select t.*, v.store_id, preset_name, store_name, tfn.path store_full_name
  from nice_tree t
  	   join tree_full_names tfn on t.preset_id::varchar = tfn.preset_id
  	   join v_obj_hierarchy v on t.preset_id = v.preset_id
 order by order_
),
tt as (select preset_id, pid, sum(s.qty) qty
			  from v_obj_tree v
			  left join sales s on v.store_id = s.store_id
			 group by preset_id, pid
			),
sls as (
with recursive tree_sales as (
select pl.preset_id, pl.pid, qty
  from tt pl
 where qty is not null
 union all
select t2.preset_id, t2.pid, cte.qty qty
  from tt t2
  join tree_sales cte on cte.pid = t2.preset_id
)
select * from tree_sales),
presets_sum as (select preset_id, sum(qty) qty_sum from sls group by preset_id order by preset_id)
select store_full_name product, qty_sum total_sum
  from v_obj_tree v
  join presets_sum p on v.preset_id = p.preset_id
 order by order_;

