
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
--Checking whether a user is connected
SELECT datname FROM pg_stat_activity WHERE usename = 'bob';
--Checking whether a computer is connected
SELECT datname, usename, client_addr, client_port,application_name FROM pg_stat_activity;
--Repeatedly executing a query in psql
\watch 5--psql 5秒钟更新一次

--Checking which queries are running
--active session
SELECT datname, usename, state, query FROM pg_stat_activity WHERE state = 'active';
--check longest query
SELECT
current_timestamp - query_start AS runtime,
datname, usename, query
FROM pg_stat_activity
WHERE state = 'active'
ORDER BY 1 DESC;

--more than 1 min
SELECT
current_timestamp - query_start AS runtime,
datname, usename, query
FROM pg_stat_activity
WHERE state = 'active'
AND current_timestamp - query_start > '1 min'
ORDER BY 1 DESC;

--Checking which queries are active or blocked.
SELECT datname
, usename
, wait_event_type
, wait_event
, query
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL
AND wait_event_type NOT IN ('Activity', 'Client');

--Knowing who is blocking a query
SELECT datname
, usename
, wait_event_type
, wait_event
, pg_blocking_pids(pid) AS blocked_by
, query
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL
AND wait_event_type NOT IN ('Activity', 'Client');

--Killing a specific session
pg_terminate_backend(PID)



(5)check system_resources info



(5)moniting and diagnosis




(6)performance 
















