---
title: Ubuntu14.04 mysql的安装
date: 2016-04-18 19:13:53
tags:
  - ubuntu
categories:
  - Linux
---

+ 安装 **mysql**
+ 设置 **root** 用户密码
+ **mysql -u root -p** 登录

<!--more-->

---

### 安装 **mysql**

```bash
apt-get install mysql-server mysql-client
```

设置**mysql root**用户的密码

![setpasswd](https://oizhq5zzs.qnssl.com/images/2016/08/mysqlSetRootPasswd.png)

使用`mysql -u root -p`输入密码后即可登录 `mysql`

![mysqlLogin](https://oizhq5zzs.qnssl.com/images/2016/08/mysql-login.png)
