---
title: Ubuntu14.04 VSFTP 的安装与配置
date: 2016-04-18 16:20:51
tags:
  - ubuntu
categories:
  - Linux
---

+ 安装**VSFTP**
+ 添加**ftp**账户和目录
+ 配置**vsftp**
+ 修改**shell**配置
+ 重启**vsftp**服务，测试登录

<!--more-->

---

### 安装VSFTP
更新索引

    apt-get update

安装vsftpd
```bash
apt-get install vsftp -y
```

### 添加ftp账号和目录

由于ftp账号一般是要设置成不能登陆系统的，所以先检查一下`nologin`的位置。

通常是在`/usr/sbin/nologin`

使用下面的命令创建ftp账户，指定了ftp账户的home目录 `/home/ftp` 和用户名`ftproot`，可以自己定义别的目录和用户名：
```bash
useradd -d /home/ftp -s /usr/sbin/nologin ftproot
```

修改该账户密码：
```bash
passwd ftproot
```

将`/home/ftp`的拥有者改为`ftproot`
```bash
chown -R ftproot.ftproot /home/ftp
```

### 配置vsftp
```bash
vim /etc/vsftpd/vsftpd.conf
```

如果被注释了就先取消注释
没有的就手动添加上

```bash
anonymous_enable=NO
local_umask=022
chroot_local_user=YES
chroot_list_enable=YES
chroot_list_file=/etc/vsftpd.chroot_list_file
pam_service_name=ftp
```

保存修改

### 修改shell配置

```bash
vim /etc/shells
```
如果没有`/usr/sbin/nologin`则添加进去
### 重启vsftp服务 并测试登录
重启：

    service vsftpd restart

测试：

windows:

    略

linux:

    ftp 192.168.0.1

![ftp登录](https://oizhq5zzs.qnssl.com/images/2016/08/X7EB@W4X544MRO2_PTO.png)
