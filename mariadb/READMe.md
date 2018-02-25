```
root@ec2-54-210-194-59:~# mysql -hec2-34-244-108-66.eu-west-1.compute.amazonaws.com -u root -p 
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 4
Server version: 10.0.33-MariaDB-0ubuntu0.16.04.1 Ubuntu 16.04

Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| TestDB1            |
| TestDB2            |
| TestDB3            |
| information_schema |
| mysql              |
| performance_schema |
+--------------------+
6 rows in set (0.07 sec)

MariaDB [(none)]> quit
Bye
```
