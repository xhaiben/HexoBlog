---
title: UPC 接口
tags:
  - UPC
id: 130
categories:
  - Java
date: 2016-08-14 18:54:51
---

+ 宿舍拨号接口
+ 教务系统登陆接口
+ 教务系统成绩查询接口

<!--more-->

---

### 宿舍拨号

#### 登录

    http://222.195.191.230:801/eportal/?c=ACSetting&a=Login&wlanuserip=&wlanacip=172.22.242.21&wlanacname=ME60-21&port=80&iTermType=1&session=

> `DDDDD` 学号+@upc

> `upass` 网号密码

### 教务系统登陆

#### 验证码

    http://jwxt.upc.edu.cn/jwxt/verifycode.servlet

#### 登陆

    http://jwxt.upc.edu.cn/jwxt/Logon.do?method=logon

> `USERNAME` 学号

> `PASSWOED` 密码

> `RANDOMCODE` 验证码

#### 二次登陆

    http://jwxt.upc.edu.cn/jwxt/Logon.do?method=logonBySSO

####　成绩查询

    http://jwxt.upc.edu.cn/jwxt/xszqcjglAction.do?method=queryxscj

> `kksj` 开课时间

> `xsfs` 显示方式

> `PageNum` 显示页码

### 备注

1. 教务系统需要在获取验证码的同时获取 **Cookie** 在登陆的时候将 **Cookie** 附加在 **HTTP** 报头中一起提交

2. 第一次登录请求成功后需要再发送 **二次登陆** 的请求，获取到 **xml** 表才算登陆成功
