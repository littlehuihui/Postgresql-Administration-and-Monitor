# Postgresql-Administration-and-Monitor
Postgresql-Administration-and-Monitor-Notes

PostgreSQL is an advanced SQL database server, available on a wide range of platforms. One of the clearest benefits of PostgreSQL is that it is open source.PostgreSQL has the following main features:  
Excellent SQL standards compliance, up to SQL: 2016  
Client-server architecture  
Highly concurrent design, where readers and writers don't block each other  
*Highly configurable and extensible for many types of applications*  
Excellent scalability and performance, with extensive tuning features  
Support for many kinds of data models, such as relational, post-relational (arrays, nested relations via record types), document (JSON and XML), and key/value  

Performance and concurrency
*PostgreSQL 10 can achieve **more than one million reads per second on a four socket server**, and it benchmarks at **more than 30,000 write transactions per second with full durability**. With advanced hardware even higher levels of performance are possible.*
*PostgreSQL provides MVCC, which enables readers and writers to avoid blocking each other.*

# 1 安装部署
安装包下载地址
PostgreSQL Database Download | EnterpriseDB
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads 

Platform support
Windows 
pg10 X64-->2016, 2012 R2 & R1, 2008 R2, 7, 8, 10
pg11 X64-->2016, 2012 R2   
 
Linux 
Red Hat family：Fedora 28-->pgsql10；  
                Fedora 27-->pgsql9.6  
Ubuntu:  Ubuntu 14.04 LTS-->（pgsql9.6——pgsql10）


 
# 2 First steps
2.1 Geting Postgresql
2.2 Connecting to the PostgreSQL Server  
（1）connect parameters:  
host or host address  
port  
database name  
user  
password  
也可以采用URI（统一资源标识符）的方式连接数据库，例如：psql postgresql://myuser:mypasswd@myhost:5432/mydb
表示pgsql客户端通过地址为myhost，端口为5432，数据库名称为mydb，用户名为myuser，密码为mypasswd的登录信息连接pgsql服务。

（2）check current session info  
--current database  
select current_database();   
--current user_ID  
select CURRENT_USER;  
--current host and port (unix套接字除外，Unix环境下这里两个值都为NULL)  
SELECT inet_server_addr(), inet_server_port();  
--VERSION  
select VERSION();    
--也可以通过psql的基础命令\conninfo查询
postgres=# \conninfo  


2.3 Enabling access for network/remote user  
The steps are as follows:  
（1） Add or edit this line in your  postgresql.conf file:  
**listen_addresses = '*'**  
（2） Add the following line as the first line of  pg_hba.conf to allow access to all  
databases for all users with an encrypted password:  
--TYPE DATABASE USER CIDR-ADDRESS METHOD  
**host all all 0.0.0.0/0 md5**  
（3） After changing  listen_addresses ,restart the PostgreSQL server  

2.4 Using graphical administration tools  
pgAdmin4  
Grant Wizard ---EXPLAIN  

OmniDB  
download：Downloads & Changelog https://omnidb.org/index.php/en/downloads-en



2.5 Using the psql query and scripting tool  
两个帮助命令  
psql --help  
postgres=# help  
       \h 显示 SQL 命令的说明 e.g: \h select 
       \? 显示 pgsql 命令的说明  

2.6 Changing your password securely  
（1）psql：connect psql--- \password--enter new passwd--confirm new passwd  
（Tips：Whatever you do, don't use  postgres as your password. ）  
（2）pgAdmin4：ALTER USER myuser PASSWORD 'secret';  

2.7 Avoiding hardcoding your password    

2.8 Using a connection service file  
类似Oracle tnsnames文件  
2.9 Troubleshooting a failed connection  
（1）Check whether the database name and the username are accurate；  
（2）Check for explicit rejections；  
（3）Check for implicit rejections；  
（4）Check whether the connection works with psql；  
（5）  




 
# 3 Exploring the Database
3.1 What version is the server?  
select  version()
psql --version  

3.2 What is the server uptime?  
SELECT date_trunc('second',
current_timestamp - pg_postmaster_start_time()) as uptime;

PostgreSQL: Documentation: 11: 9.25. System Information Functions
https://www.postgresql.org/docs/11/functions-info.html

3.3 Locating the database server files
Windows, the default data directory location is default installation path:  X:\Program Files\PostgreSQL\R.r\data
Red Hat RHEL, CentOS, and Fedora, the default data directory location is /var/lib/pgsql/data/

3.4 Locating the database server's message log
Red Hat, RHEL, CentOS, and Fedora, the default server log location is a subdirectory of the  data directory, that is,  /var/lib/pgsql/data/pg_log
Windows systems, the messages are sent to the Windows Event Log by default


3.5 Locating the database's system identifier  
3.6 Listing databases on this database server  
select datname from pg_database;  
\x:makes the output in  psql appear as one column per line, rather than one row per line  


3.7 How many tables are there in a database?  
SELECT count(*) FROM information_schema.tables  
WHERE table_schema NOT IN ('information_schema',  
'pg_catalog');  

3.8 How much disk space does a database use?  
SELECT pg_database_size(current_database());  
SELECT sum(pg_database_size(datname)) from pg_database;  

3.9 How much disk space does a table use?  
select pg_relation_size('TABLE_NAME');  
--see the total size of a table, including indexes and other related spaces  
select pg_total_relation_size('TABLE_NAME');  



3.10 Which are my biggest tables?  
SELECT table_name  
,pg_relation_size(table_schema || '.' || table_name) as size  
FROM information_schema.tables  
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')  
ORDER BY size DESC  
LIMIT 10;  

3.11 How many rows in a table?  
3.12 Quickly estimating the number of rows in a table  
3.13 Listing extensions in this database  
☆3.14 Understanding object dependencies  



 
# 4 Configuration  
![Postgresql Architecture](https://commons.wikimedia.org/wiki/File:PostgreSQL_processes_1.png)
4.1 Reading the fine manual  
4.2 Planning a new database  
4.3 Changing parameters in your programs  
--session  
SET work_mem = '16MB';--session 级别生效  

--transactions  
SET LOCAL work_mem = '16MB';--transactions级别生效，可以通过reset 或rollback disable  

--reset   
RESET work_mem;  
--or  
RESET ALL;  

--check parameter setting (pg_settings)  
SELECT name, setting, reset_val, source
FROM pg_settings WHERE source = 'session';  
  

4.4 Finding the current configuration settings
--check parameter setting
SHOW work_mem;
--or
SELECT * FROM pg_settings WHERE name = 'work_mem';

--check the location of configuration file  
SHOW config_file;  

4.5 Which parameters are at non-default settings?

SELECT name, source, setting
FROM pg_settings
WHERE source != 'default'
AND source != 'override'
ORDER by 2, 1;

The  boot_val parameter shows the value assigned when the PostgreSQL database cluster was initialized ( initdb ), while reset_val shows the value that the parameter will return to if you issue the  RESET command

4.6 Updating the parameter file
 PostgreSQL version 9.4 or later, you can change the values stored in the parameter files directly from your session, with syntax such
as the following:
ALTER SYSTEM SET shared_buffers = '1GB';  
4.7 Setting parameters for particular groups of users  
（1）For all users in the  saas database, use the following commands:
ALTER DATABASE saas
SET configuration_parameter = value1;
（2）For a user named  simon connected to any database, use this:  
ALTER ROLE simon
SET configuration_parameter = value2;  
（3）Alternatively, you can set a parameter for a user only when connected to a specific database, as follows:  
ALTER ROLE simon
IN DATABASE saas
SET configuration_parameter = value3;  

☆4.8 The basic server configuration checklist  
???
4.9 Adding an external module to PostgreSQL  
4.10 Using an installed module  
4.11 Managing installed extensions  

4.12 参数配置最佳实践？？？
4.13 postgresql architecture？ 


 
# 5 Server Control  
5.1 Starting the database server manually    

5.2 Stopping the server safely and quickly   
5.3 Stopping the server in an emergency   
5.4 Reloading the server configuration files   
5.5 Restarting the server quickly   
5.6 Preventing new connections   
5.7 Restricting users to only one session each   
5.8 Pushing users off the system   
5.9 Deciding on a design for multitenancy   
5.10 Using multiple schemas   
5.11 Giving users their own private database   
5.12 Running multiple servers on one system   
5.13 Setting up a connection pool   
5.14 Accessing multiple servers using the same host and port   


 
# 6 Monitoring and Diagnosis（gp_stat_activity）   
https://www.postgresql.org/docs/current/monitoring-stats.html#PG-STAT-ACTIVITY-VIEW  
6.1 Providing PostgreSQL information to monitoring tools   
6.2 Real-time viewing using pgAdmin or OmniDB   
6.3 Checking whether a user is connected   
SELECT datname FROM pg_stat_activity WHERE usename = 'bob';   
6.4 Checking whether a computer is connected   
SELECT datname, usename, client_addr, client_port,application_name FROM pg_stat_activity;   
6.5 Repeatedly executing a query in psql（\watch 5）   

6.6 Checking which queries are running   
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

6.7 Checking which queries are active or blocked.   


SELECT datname
, usename
, wait_event_type
, wait_event
, query
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL
AND wait_event_type NOT IN ('Activity', 'Client');

6.8 Knowing who is blocking a query   

SELECT datname
, usename
, wait_event_type
, wait_event
, pg_blocking_pids(pid) AS blocked_by
, query
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL
AND wait_event_type NOT IN ('Activity', 'Client');

6.9 Killing a specific session  
--kill a session 
select pg_terminate_backend(PID)  
--cancel a query  
select pg_cancel_backend(pid)  
--Using statement_timeout to clean up queries that take too long to run  
 SET statement_timeout TO '3 s';--设置3s超时  
--Killing idle in transaction queries  
--kill all backends that have an open transaction but have been doing nothing for the last 10 minutes
SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE state = 'idle in transaction'
AND current_timestamp - query_start > '10 min';
  
PostgreSQL: Documentation: 11: 9.26. System Administration Functions
https://www.postgresql.org/docs/current/functions-admin.html#FUNCTIONS-ADMIN-SIGNAL
   

6.10 Detecting an in-doubt prepared transaction   
SELECT t.schemaname || '.' || t.relname AS tablename,
l.pid, l.granted
FROM pg_locks l JOIN pg_stat_user_tables t
ON l.relation = t.relid;

  
6.11 Knowing whether anybody is using a specific table   
6.12 Knowing when a table was last used   
6.13 Usage of disk space by temporary data   
6.14 Understanding why queries slow down   
monitor tools for linux system--Cacti or Munin   

ANALYZE  --update statistics
①Do the queries return significantly more data than they did earlier?   
②Do the queries also run slowly when they are run alone?   
③Is the second run of the same query also slow?   
※④Table and index bloat   


6.15 Investigating and reporting a bug   
6.16 Producing a daily summary of log file errors   
6.17 Analyzing the real-time performance of your queries   
pg_stat_statements扩展添加了跟踪数据库中运行的查询的执行统计信息的功能，包括调用次数，总执行时间，返回行总数以及有关内存和I / O访问的内部信息。pg_stat_statements是pg的扩展模块，可以通过修改postgresql.conf配置文件的方式启用。具体为
shared_preload_libraries = 'pg_stat_statements'（需要重启pg）  
然后需要创建扩展命令：gabriele=# CREATE EXTENSION pg_stat_statements;（需要已管理员权限运行）  
PostgreSQL: Documentation: 11: F.29. pg_stat_statements 
https://www.postgresql.org/docs/current/pgstatstatements.html        
                
# 7 Regular Maintenance   
7.1 Controlling automatic database maintenance   
7.2 Avoiding auto-freezing and page corruptions   
7.3 Removing issues that cause bloat   
7.4 Removing old prepared transactions   
7.5 Actions for heavy users of temporary tables   
7.6 Identifying and fixing bloated tables and indexes   
7.7 Monitoring and tuning vacuum   
7.8 Maintaining indexes   
7.9 Adding a constraint without checking existing rows   
7.10 Finding unused indexes   
7.11 Carefully removing unwanted indexes   
7.12 Planning maintenance   



# Chapter 13. Concurrency Control


 
# 8 Performance and Concurrency   

8.1 Finding slow SQL statements   
--pg_stat_statements  
--检查pg_stat_statements扩展是否开启   \dx ps_stat_staements
--开启方式  
（postgres=# CREATE EXTENSION pg_stat_statements;  
postgres=# ALTER SYSTEM SET shared_preload_libraries = 'pg_stat_statements';）
SELECT calls, total_time, query FROM pg_stat_statements
ORDER BY total_time DESC LIMIT 10;  
-- monitor a query taking over 10 seconds  
ALTER SYSTEM SET log_min_duration_statement = 10000;--注意单位是毫秒  




8.2 Collecting regular statistics from pg_stat* views   
8.3 Finding out what makes SQL slow   
The main reasons are:  
（1）Returning too much data  
（2）Processing too much data index needed  
（3）Wrong plan for other reasons  
（4）Cache or I/O problems  
（5）Locking problems  

postgres=# EXPLAIN (ANALYZE, BUFFERS) ...SQL...  


8.4 Reducing the number of rows returned   
8.5 Simplifying complex SQL queries   
8.6 Speeding up queries without rewriting them   
Increasing work_mem  
Index  

8.7 Discovering why a query is not using an index   
8.8 Forcing a query to use an index   
8.9 Using parallel query   
8.10 Using Optimistic locking   
8.11 Reporting performance problems   







参考文档
>postgresql-11-US.pdf  
>PostgreSQL 10 Administration Cookbook.pdf  
