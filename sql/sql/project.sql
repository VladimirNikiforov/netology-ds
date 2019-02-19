-- Проектная работа по модулю "SQL и получение данных"
-- ФИО: Никифоров Владимир
DROP TABLE IF EXISTS stores;
create table stores(
	store_id integer primary key,
	name varchar(255),
	date_open date,
	date_close date);
delete from stores;
insert into stores values(1, 'Central Universal Store', '2010-01-01', NULL);
insert into stores values(2, 'Universal State Store', '2000-01-01', NULL);
insert into stores values(3, 'Small Regional Store', '2001-01-01', '2010-12-31');
insert into stores values(4, 'Brand New Store by Elon Mask', '2016-01-01', '2019-01-01');
insert into stores values(5, 'Grandmother Zina`s Small Store', '1975-01-01', NULL);
commit;
-- select * from stores;
DROP TABLE IF EXISTS products;
create table products(product_id integer primary key,
					  name varchar(255),
					  collection varchar(10));
insert into products values(1, 'BigFoot Boots Black', 'Winter');
insert into products values(2, 'Tuxedo', 'Summer');
insert into products values(3, 'Queen` Dress', 'Summer');
insert into products values(4, 'Heavy sneakers', 'Summer');
insert into products values(5, 'Nice slippers', 'Summer');
commit;
-- select * from products;
DROP TABLE IF EXISTS calendar;
create table calendar(date_id date primary key,
					  weekid integer,
					  holiday integer);
insert into calendar
SELECT
	datum AS date_id,
	to_char(datum, 'IW')::integer AS weekid,
	CASE WHEN EXTRACT(isodow FROM datum) IN (6, 7) THEN 1 ELSE 0 END AS holiday
FROM (
	-- There are 3 leap years in this range, so calculate 365 * 10 + 3 records
	SELECT '2010-01-01'::DATE + SEQUENCE.DAY AS datum
	FROM generate_series(0,3652) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ
ORDER BY 1;
commit;
-- select * from calendar;
DROP TABLE IF EXISTS sales;
create table sales(
	store_id integer references stores(store_id), 
	product_id integer references products(product_id),
	date_id date references calendar(date_id),
	qty integer,
	sum_nv integer);
insert into sales(store_id, product_id, date_id, qty, sum_nv)
select floor(random() * 5 + 1)::int store_id,  floor(random() * 5 + 1)::int product_id, date_id, floor(random() * 2 + 1)::int qty, floor(random() * 10 + 1)::int*1000-1 sum_nv
FROM (
	SELECT '2010-01-01'::DATE + 10*SEQUENCE.DAY AS date_id
	FROM generate_series(0,300) AS SEQUENCE(DAY)
	GROUP BY SEQUENCE.DAY
     ) DQ;
commit;
-- select * from sales;
DROP TABLE IF EXISTS ProductsHierarchies;
create table ProductsHierarchies(tree_id integer primary key,
								 name varchar(255));
insert into ProductsHierarchies values(1, 'Main product hierarchy');
insert into ProductsHierarchies values(2, 'Alternative product hierarchy');
commit;
-- select * from ProductsHierarchies;
create table ProductsHierarchyTree(preset_id integer primary key,
								   pid integer references ProductsHierarchyTree(preset_id),
								   tree_id integer references ProductsHierarchies(tree_id));
create table ProductsHierarchyLink(product_id integer references products(product_id),
								   preset_id integer references ProductsHierarchyTree(preset_id));

create table StoresHierarchyLink,store_id,integer,FK,preset_id,integer,FK,,,,,,,,,
create table StoresHierarchyTree,preset_id,integer,PK,pid,integer,FK,tree_id,integer,FK,,,,,,
create table StoresHierarchies,tree_id,integer,PK,name,varchar(255),,,,,,,,,,
create table ProductsAttrLink,product_id,integer,FK,attr_id,integer,FK,value,varchar(255),,,,,,,
create table ProductsAttributes,attr_id,integer,PK,name,varchar(255),,,,,,,,,,
create table StoresAttrLink,store_id,integer,FK,attr_id,integer,FK,value,varchar(255),,,,,,,
create table StoresAttributes,attr_id,integer,PK,name,varchar(255),,,,,,,,,,