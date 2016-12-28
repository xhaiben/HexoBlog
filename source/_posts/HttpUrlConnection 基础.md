---
title: HttpUrlConnection 基础
tags:
  - Web
id: 131
categories:
  - Java
date: 2016-08-14 19:15:21
---

+ 创建 **URL** 对象
+ 使用 **url** 创建 **HttpUrlConnection** 对象
+ 设置 **httpUrlConnection** 对象的参数
+ 创建连接
+ 创建 **InpueStream** 接受返回数据

<!--more-->

---

> 以获取教务系统验证码为例

### 创建 **URL** 对象
```java
URL url=new URL("http://jwxt.upc.edu.cn/jwxt/verifycode.servlet");
```
### 使用 **url** 创建 **HttpUrlConnection** 对象
```java
httpURLConnection=(HttpURLConnection)url.openConnection();
```
### 设置 **httpUrlConnection** 对象的参数
```java
httpURLConnection.setRequestMethod("GET");//GET请求
httpURLConnection.setDoInput(true);//需接收数据
```
### 创建连接并接收验证码
```java
httpURLConnection.connect();
InputStream instream=new BufferedInputStream(httpURLConnection.getInputStream());
File randomCode=new File("randomCode.jpg");
FileOutputStream fos=new FileOutputStream(randomCode);
try{
	byte[] b=new byte[1024];
	int length=instream.read(b);
	while(length!=-1){
	    fos.write(b,0,length);
	    length=instream.read(b);
	}
}finally{
		instream.close();
		fos.close();
}
```
### 完整代码
```java
URL url=new URL("http://jwxt.upc.edu.cn/jwxt/verifycode.servlet");
httpURLConnection=(HttpURLConnection)url.openConnection();
httpURLConnection.setRequestMethod("GET");
httpURLConnection.setDoInput(true);
try{
    httpURLConnection.connect();
    InputStream instream=new BufferedInputStream(httpURLConnection.getInputStream());
    File randomCode=new File("randomCode.jpg");
    FileOutputStream fos=new FileOutputStream(randomCode);
    try{
        byte[] b=new byte[1024];
        int length=instream.read(b);
        while(length!=-1){
        	fos.write(b,0,length);
        	length=instream.read(b);
        }
    }finally{
    	instream.close();
    	fos.close();
    }
}finally{
    httpURLConnection.disconnect();
}
```
