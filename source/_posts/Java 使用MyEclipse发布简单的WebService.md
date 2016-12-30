---
title: Java 使用MyEclipse发布简单的WebService
tags:
  - java
  - WebService
id: 118
categories:
  - Java
date: 2016-04-21T17:09:46.000Z
---

- 打开**MyEclipse**新建**Web Project**
- 在工程下新建一个包
- 新建**WebService**的接口**IService**
- 实现**IService**接口
- 使用**Endpoint.publish**发布此**WebService**

<!--more-->

---

### 新建**Web Project**

![新建wewb Project](/images/2016/08/newWebProject.png)

### 在工程下新建一个包

![新建包](/images/2016/08/webServicePackage.png)

### 新建**WebService**的接口**IService**

声明一个要提供的方法 如：**String sayHello();**

```java
public interface Service {
    String sayHello(String name);
}

```


### 实现Service接口 新建一个**ServiceImp**类，实现**Service**接口。
```java
public class ServiceImp implements Service{
    public String sayHello(String name) {
        return "Hello "+name;
    }
}
```

### 使用**Java**自带的**API**发布此**WebService**

新建一个**PublishWS**类，调用**Endpoint.publish(arg0,arg1)发布服务

```java
@WebService
public class ServiceImp implements Service{
    public String sayHello(@WebParam(name="name")String name) {
        return "Hello "+name;
    }
}
```
