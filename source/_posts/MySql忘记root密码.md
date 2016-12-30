---
title: MySQL忘记root密码
date: 2016-12-27 11:09:44
categories:
  - Linux
tags:
  - mysql
---

+ 编辑MySQL的配置文件
+ 修改root密码
+ 重启MySQL服务

<!--more-->

---

#### 编辑MySQL的配置文件mysqld.cnf
ubuntu16.04下文件路径`/etc/mysql/mysql.conf.d`
在`[mysqld]`字段中添加
`skip-grant-tables`
![](https://oizhq5zzs.qnssl.com/images/2016/12/H%25TOR%5bPO14QQO4%7d%5d81S%7bYE.png)
保存修改
重启mysql服务
`service mysql restart`
#### 修改MySQL的root密码
```bash
mysql -u root #直接回车即可，此时不需root密码

update mysql.user set password=password('123456') where User="root" and Host="localhost";

grant all on *.* to 'root'@'localhost' identified by '123456' with grant option;

flush privileges;  #刷新系统授权表

```
#### 取消mysqld.cnf中的skip-grant-tables
找到mysql.conf.d，将skip-grant-tables注释或删除
重启mysql服务
`service mysql restart`
#### 进入mysql控制台
```bash
mysql -u root -p
123456 #输入刚才设置的root密码
```
