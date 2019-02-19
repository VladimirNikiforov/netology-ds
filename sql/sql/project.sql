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

-- Построим дерево товаров с помощью рекурсивного CTE
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
-- можно было бы конечно отсортировать по preset_id, но это не наш подход => ставим tablefunc
CREATE EXTENSION IF NOT EXISTS tablefunc;
with tree as (select preset_id, pid, level lvl
			    from connectby('ProductsHierarchyTree', 'preset_id', 'pid', '101', 0)
 					 as t(preset_id integer, pid integer, level int)
			 )
select t.*, tnames.name_ preset, p.name_ product, tnames.name_ || case when p.name_ is null then '' else '\' || p.name_ end product_full_name
  from tree t
  	   join ProductsHierarchyTree tnames on t.preset_id = tnames.preset_id
	   left join ProductsHierarchyLink l on t.preset_id = l.preset_id
	   left join Products p on l.product_id = p.product_id