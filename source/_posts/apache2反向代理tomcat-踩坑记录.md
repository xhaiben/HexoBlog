---
title: Apache2反向代理Tomcat 踩坑记录
date: 2017-01-02 19:57:44
tags:
 - apache2
 - tomcat
categories:
 - Linux
permalink: apache2-reverse-proxy-tomcat
---
　　有一台运行在内网的Tomcat服务器，想通过公网的Apache服务器，使用反向代理来达到公网访问的目的，记录一下踩的坑。
The proxy server received an invalid response from an upstream server.
The proxy server could not handle the request GET /tomcat.css.
　　环境：
　　UbuntuServer 14.04
　　Apache 2.4.7
<!--more-->

---
### Apache2添加虚拟主机
首先为Apache2添加了一个虚拟主机，共用80端口，使用域名来区分。
编辑虚拟主机的配置文件
默认位置 `/etc/apache2/sites-enabled/000-default.conf`

```xml
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        #DocumentRoot /var/www/html
        ServerName ****.cacher.cc

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

```
![](https://oizhq5zzs.qnssl.com/2017/01/02/2XN%7DUTOG@2EIJ~VW2RI$GFU.png)

可以看到两个虚拟主机共用了80端口，但是通过访问的域名不同，跳转到不同的站点。
由于直接使用代理，不需要主机根目录，所以将DocumentRoot注释掉了

### 为Apache2添加代理模块
需要添加的模块有：
1. mod_proxy
2. mod_proxy_http

在mods-available文件夹下，已有这两个模块的加载文件，只需在mods-enabled文件夹下建立软链接即可。
```bash
ln -s ../mods-available/proxy.load proxy.load
ln -s ../mods-available/proxy.conf proxy.conf
ln -s ../mods-available/proxy_http.load proxy_http.load
```
![](https://oizhq5zzs.qnssl.com/2017/01/02/_43QKW2V%5BTT2IC~O8JYONS0.png)

### 配置虚拟主机的代理

为刚才添加的虚拟主机配置代理
10.161.192.82 是要代理的内网ip

```xml
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        #DocumentRoot /var/www/html
        ServerName ****.cacher.cc

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        <Proxy *>
          Order Deny,Allow
          Allow from all
        </Proxy>
        ProxyPass / http://10.161.192.82:8080/
        ProxyPassReverse / http://10.161.192.82:8080/
</VirtualHost>

```

![](https://oizhq5zzs.qnssl.com/2017/01/02/%28$YZ3D%7D%29S4%5D%5DLQ_0KDYX33W.png)

### 结果

通过外网，成功访问Tomcat服务器

![](https://oizhq5zzs.qnssl.com/2017/01/02/P07_OCHO9%280%60%258%28%7BG~AD4S4.png)

### 踩的坑

一开始配完的时候，主页是这样的。

![](https://oizhq5zzs.qnssl.com/2017/01/02/3Y1E1PBV6U4%290%60C271WSIEG.png)

通过F12发现代理错误，没能正确加载样式表

![](https://oizhq5zzs.qnssl.com/2017/01/02/BX%5B%28N%253X%29_XMNJC$0_%60UR@2.png)

![](https://oizhq5zzs.qnssl.com/2017/01/02/%25FQ2_$T8JDB1%5DT%29E6OIPN%60N.png)

百度，Google N久无果，最后发现是代理服务器的地址配错了，端口号后要加 / 即 `http://10.161.192.82:8080/`

![](https://oizhq5zzs.qnssl.com/2017/01/02/B8%2599QN%5BM_PL%7B6UIV%7BF19%290.png)
