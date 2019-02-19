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
-- select * from calendar;
create table sales(
	store_id integer references stores(store_id), 
	product_id integer references products(product_id),
	date_id date references calendar(date_id),
	qty integer,
	sum_nv integer);

create table ProductsHierarchyLink(product_id integer references products(product_id),
								   preset_id integer references ProductsHierarchyTree(preset_id));
7,Entity,Entity Relationship,1,,,,,,,ProductsHierarchyTree,preset_id,integer,PK,pid,integer,FK,tree_id,integer,FK,,,,,,
8,Entity,Entity Relationship,1,,,,,,,ProductsHierarchies,tree_id,integer,PK,name,varchar(255),,,,,,,,,,
9,Entity,Entity Relationship,1,,,,,,,StoresHierarchyLink,store_id,integer,FK,preset_id,integer,FK,,,,,,,,,
10,Entity,Entity Relationship,1,,,,,,,StoresHierarchyTree,preset_id,integer,PK,pid,integer,FK,tree_id,integer,FK,,,,,,
11,Entity,Entity Relationship,1,,,,,,,StoresHierarchies,tree_id,integer,PK,name,varchar(255),,,,,,,,,,
12,Entity,Entity Relationship,1,,,,,,,ProductsAttrLink,product_id,integer,FK,attr_id,integer,FK,value,varchar(255),,,,,,,
13,Entity,Entity Relationship,1,,,,,,,ProductsAttributes,attr_id,integer,PK,name,varchar(255),,,,,,,,,,
14,Entity,Entity Relationship,1,,,,,,,StoresAttrLink,store_id,integer,FK,attr_id,integer,FK,value,varchar(255),,,,,,,
15,Entity,Entity Relationship,1,,,,,,,StoresAttributes,attr_id,integer,PK,name,varchar(255),,,,,,,,,,
16,Line,,1,,,2,4,CFN ERD One Or More Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
17,Line,,1,,,5,2,CFN ERD Exactly One Arrow,CFN ERD One Or More Arrow,,,,,,,,,,,,,,,,
18,Line,,1,,,2,3,CFN ERD One Or More Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
19,Line,,1,,,4,6,CFN ERD Exactly One Arrow,CFN ERD One Or More Arrow,,,,,,,,,,,,,,,,
20,Line,,1,,,6,7,CFN ERD Many Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
21,Line,,1,,,7,7,CFN ERD One Or More Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
22,Line,,1,,,7,8,CFN ERD Many Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
23,Line,,1,,,3,9,CFN ERD Exactly One Arrow,CFN ERD One Or More Arrow,,,,,,,,,,,,,,,,
24,Line,,1,,,9,10,CFN ERD Many Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
25,Line,,1,,,10,10,CFN ERD One Or More Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
26,Line,,1,,,10,11,CFN ERD Many Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
27,Line,,1,,,4,12,CFN ERD Exactly One Arrow,CFN ERD One Or More Arrow,,,,,,,,,,,,,,,,
28,Line,,1,,,12,13,CFN ERD Many Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,
29,Line,,1,,,3,14,CFN ERD Exactly One Arrow,CFN ERD One Or More Arrow,,,,,,,,,,,,,,,,
30,Line,,1,,,14,15,CFN ERD Many Arrow,CFN ERD Exactly One Arrow,,,,,,,,,,,,,,,,