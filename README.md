# Postgresql-Manage-and-Monitor
Postgresql-Manage-and-Monitor-Notes


1 安装部署
安装包下载地址
PostgreSQL Database Download | EnterpriseDB
https://www.enterprisedb.com/downloads/postgres-postgresql-downloads 

Platform support
Windows 
 

Linux 
Red Hat family：Fedora 28pgsql10/ Fedora 27pgsql9.6
Ubuntu:  Ubuntu 14.04 LTSpgsql9.6--pgsql10

2 SQL language
2.1 SQL Syntax

2.2 Data Definition
2.3 Data Manipulation
2.4 Queries
2.5 Data Types
2.7 Functions and Operators
2.8 Type Conversion
2.9 Indexes
2.10 Full Text Search
2.11 Concurrency Control
☆2.12 Performance Tips
2.13 Parallel Query


 
3 First steps
3.1 Geting Postgresql
3.2 Connecting to the PostgreSQL Server
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

3.3 Enabling access for network/remote user
The steps are as follows:
（1） Add or edit this line in your  postgresql.conf file:
listen_addresses = '*'
（2） Add the following line as the first line of  pg_hba.conf to allow access to all
databases for all users with an encrypted password:
# TYPE DATABASE USER CIDR-ADDRESS METHOD
host all all 0.0.0.0/0 md5
（3） After changing  listen_addresses , we restart the PostgreSQL server

3.4 Using graphical administration tools
pgAdmin4
Grant Wizard ---EXPLAIN

OmniDB
download：Downloads & Changelog https://omnidb.org/index.php/en/downloads-en



3.5 Using the psql query and scripting tool


3.6 Changing your password securely
（1）psql：connect psql--- \password--enter new passwd--confirm new passwd
（Tips：Whatever you do, don't use  postgres as your password. ）
（2）pgAdmin4：ALTER USER myuser PASSWORD 'secret';


3.7 Avoiding hardcoding your password


3.8 Using a connection service file

3.9 Troubleshooting a failed connection
（1）Check whether the database name and the username are accurate；
（2）Check for explicit rejections；
（3）Check for implicit rejections；
（4）Check whether the connection works with psql；
（5）




 
4 Exploring the Database
4.1 What version is the server?
select  version()
psql --version

4.2 What is the server uptime?
SELECT date_trunc('second',
current_timestamp - pg_postmaster_start_time()) as uptime;

4.3 Locating the database server files
Windows, the default data directory location is default installation path:  X:\Program Files\PostgreSQL\R.r\data
Red Hat RHEL, CentOS, and Fedora, the default data directory location is /var/lib/pgsql/data/

4.4 Locating the database server's message log
Red Hat, RHEL, CentOS, and Fedora, the default server log location is a subdirectory of the  data directory, that is,  /var/lib/pgsql/data/pg_log
Windows systems, the messages are sent to the Windows Event Log by default


4.5 Locating the database's system identifier
4.6 Listing databases on this database server
select datname from pg_database;

4.7 How many tables are there in a database?
SELECT count(*) FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema',
'pg_catalog');

4.8 How much disk space does a database use?
SELECT pg_database_size(current_database());
SELECT sum(pg_database_size(datname)) from pg_database;

4.9 How much disk space does a table use?
4.10 Which are my biggest tables?
SELECT table_name
,pg_relation_size(table_schema || '.' || table_name) as size
FROM information_schema.tables
WHERE table_schema NOT IN ('information_schema', 'pg_catalog')
ORDER BY size DESC
LIMIT 10;

4.11 How many rows in a table?
4.12 Quickly estimating the number of rows in a table
4.13 Listing extensions in this database
☆4.14 Understanding object dependencies



 
5 Configuration
5.1 Reading the fine manual
5.2 Planning a new database
5.3 Changing parameters in your programs
5.4 Finding the current configuration settings
5.5 Which parameters are at non-default settings?
5.6 Updating the parameter file
5.7 Setting parameters for particular groups of users
☆5.8 The basic server configuration checklist

5.9 Adding an external module to PostgreSQL
5.10 Using an installed module
5.11 Managing installed extensions




 
6 Server Control
6.1 Starting the database server manually
6.2 Stopping the server safely and quickly
6.3 Stopping the server in an emergency
6.4 Reloading the server configuration files
6.5 Restarting the server quickly
6.6 Preventing new connections
6.7 Restricting users to only one session each
6.8 Pushing users off the system
6.9 Deciding on a design for multitenancy
6.10 Using multiple schemas
6.11 Giving users their own private database
6.12 Running multiple servers on one system
6.13 Setting up a connection pool
6.14 Accessing multiple servers using the same host and port


 
7 Monitoring and Diagnosis（gp_stat_activity）
7.1 Providing PostgreSQL information to monitoring tools
7.2 Real-time viewing using pgAdmin or OmniDB
7.3 Checking whether a user is connected
SELECT datname FROM pg_stat_activity WHERE usename = 'bob';
7.4 Checking whether a computer is connected
SELECT datname, usename, client_addr, client_port,application_name FROM pg_stat_activity;
7.5 Repeatedly executing a query in psql（\watch 5）

7.6 Checking which queries are running
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

7.7 Checking which queries are active or blocked.


SELECT datname
, usename
, wait_event_type
, wait_event
, query
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL
AND wait_event_type NOT IN ('Activity', 'Client');

7.8 Knowing who is blocking a query

SELECT datname
, usename
, wait_event_type
, wait_event
, pg_blocking_pids(pid) AS blocked_by
, query
FROM pg_stat_activity
WHERE wait_event_type IS NOT NULL
AND wait_event_type NOT IN ('Activity', 'Client');

7.9 Killing a specific session

pg_terminate_backend(PID)

7.10 Detecting an in-doubt prepared transaction
7.11 Knowing whether anybody is using a specific table
7.12 Knowing when a table was last used
7.13 Usage of disk space by temporary data
7.14 Understanding why queries slow down

ANALYZE  --update statistics
①Do the queries return significantly more data than they did earlier?
②Do the queries also run slowly when they are run alone?
③Is the second run of the same query also slow?
※④Table and index bloat


7.15 Investigating and reporting a bug
7.16 Producing a daily summary of log file errors
7.17 Analyzing the real-time performance of your queries
 
8 Regular Maintenance
8.1 Controlling automatic database maintenance
8.2 Avoiding auto-freezing and page corruptions
8.3 Removing issues that cause bloat
8.4 Removing old prepared transactions
8.5 Actions for heavy users of temporary tables
8.6 Identifying and fixing bloated tables and indexes
8.7 Monitoring and tuning vacuum
8.8 Maintaining indexes
8.9 Adding a constraint without checking existing rows
8.10 Finding unused indexes
8.11 Carefully removing unwanted indexes
8.12 Planning maintenance




 
9 Performance and Concurrency

9.1 Finding slow SQL statements
SELECT calls, total_time, query FROM pg_stat_statements
ORDER BY total_time DESC LIMIT 10;
9.2 Collecting regular statistics from pg_stat* views
9.3 Finding out what makes SQL slow
9.4 Reducing the number of rows returned
9.5 Simplifying complex SQL queries
9.6 Speeding up queries without rewriting them
9.7 Discovering why a query is not using an index
9.8 Forcing a query to use an index
9.9 Using parallel query
9.10 Using Optimistic locking
9.11 Reporting performance problems







参考文档
postgresql-11-US.pdf
PostgreSQL 10 Administration Cookbook.pdf