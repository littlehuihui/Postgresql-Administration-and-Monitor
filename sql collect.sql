
（1）check current session info
--current database
select current_database();
--current user_ID
select CURRENT_USER;
--current host and port (unix套接字除外，Unix环境下这里两个值都为NULL)
SELECT inet_server_addr(), inet_server_port();
--VERSION
select VERSION();

(2)check current server info
--What is the server uptime?
SELECT date_trunc('second',
current_timestamp - pg_postmaster_start_time()) as uptime;
--Listing databases on this database server
select datname from pg_database;




(3)check current database info 
--How many tables are there in a database?
SELECT count(*) FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema',
'pg_catalog');
--Which are my biggest tables?
SELECT table_name
,pg_relation_size(table_schema || '.' || table_name) as size
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
--How much disk space does a database use?
SELECT pg_database_size(current_database());
SELECT sum(pg_database_size(datname)) from pg_database;
--Which are my biggest tables?
SELECT table_name
,pg_relation_size(table_schema || '.' || table_name) as size
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY size DESC
LIMIT 10;







(4)check server session info



(5)check system_resources info



(5)moniting and diagnosis




(6)performance 
















