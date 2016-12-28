---
title: Ubuntu14.04 mysql 增加允许远程访问
tags:
  - ECS
  - mysql
  - ubuntu
  - 阿里云
id: 60
categories:
  - Linux
date: 2016-04-19 22:39:50
---

+ 设置权限
+ 刷新权限
+ 进行链接

<!--more-->

---

### 查看权限
```sql
SELECT user,host FROM mysql.user;
```
![privileges](/images/2016/08/mysqlShowPrivilegesOfUser.png)

此时**root**没有远程链接权限，仅限本机登陆

### 给**root**远程登陆的权限

```sql
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'rootPassword';
```

### 刷新权限

```sql
FLUSH PRIVILEGES;
```

![privileges](/images/2016/08/mySql@Privileges.png)
