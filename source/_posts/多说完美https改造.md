---
title: 多说完美https改造
date: 2016-12-31 13:53:49
tags:
 - https
categories:
 - Blog
permalink: duoshuo-https
---
　　多说的评论框虽然提供了https链接，但是其中的一些头像和表情还是http的，本文介绍了一种改造方式，使多说评论框完美支持https。
<!--more-->

---
### 下载多说官方的embed.js
通过F12发现多说的embed.js请求头像和表情的时候用的是http协议，但是这两个链接本身也支持https协议，所以可以通过修改embed.js使其请求https协议的链接。

![](https://oizhq5zzs.qnssl.com/duoshuohttps1.png)

下载链接

https://static.duoshuo.com/embed.js
### 使用WebStrom格式化此js
下载下来的js是经过压缩的，需要格式化，方便查看。

![](https://oizhq5zzs.qnssl.com/QQ%E6%88%AA%E5%9B%BE20161231140730.png)
### 修改头像链接
搜索avatar_url找到头像链接

![](https://oizhq5zzs.qnssl.com/%60H7K86%7DWMPS21XQ%7D%7B%250MT1X.png)

做简单的字符串替换

![](https://oizhq5zzs.qnssl.com/DCAKGWZHPQFA0MA%5D6%5B2Z%5DRN.png)
### 修改表情链接
搜索message发现是由变量s传过去的，找到s的来源

![](https://oizhq5zzs.qnssl.com/@S5I_WIB%5BBCGNF_ZVI0OEFV.png)

同样替换字符串

![](https://oizhq5zzs.qnssl.com/%7D%5B3A1H9%257B%7B%60~%5BHK_%28%29%294V7.png)

搜索wordpress发现表情链接为http

![](https://oizhq5zzs.qnssl.com/B%60E$%7BM4SM%7BM1N@1Q%258K%7DLCA.png)

替换为https

![](https://oizhq5zzs.qnssl.com/2Q47DJ@%7BR%5DX0%28%60%7DH%6042ML@S.png)

### 替换embed.js路径

以hexo为例,替换embed.js为本地

![](https://oizhq5zzs.qnssl.com/82G@B7%5B%7BOD880CY92JASYV7.png)

### 改造完毕
<br>
![](https://oizhq5zzs.qnssl.com/_R7S140%5D9$YIV%7B%60%7B2QTB%5D3W.png)
