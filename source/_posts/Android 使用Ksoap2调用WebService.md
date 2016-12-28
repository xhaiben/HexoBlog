---
title: Android 使用Ksoap2调用WebService
tags:
  - Android
  - WebService
id: 120
categories:
  - Java
date: 2016-05-03 19:20:51
---

- 创建**SoapObject**请求对象
- 创建**SoapSerializationEnvelope**并添加信息
- 创建**HttpTransportSE**请求链接
- 解析返回结果

<!--more-->

---

### webService方法

```java
public String webService(){
      //创建SoapObject请求对象
      // WebService的命名空间为 http://WSDemo.cacher.cc/
      //请求的方法名为 sayHello
      SoapObject request=new SoapObject("http://WSDemo.cacher.cc",
                                        "sayHello");
      //为请求添加参数名 name 和参数 cacher
      request.addProperty("name","Cacher");
      //创建envelope 使用soap1.1
      SoapSerializationEnvelope envelope=new
                            SoapSerializationEnvelope(SoapEnvelope.VER11);
      envelope.bodyOut=request;
      envelope.setOutputSoapObject(request);
      //创建http连接，3秒未连接成功会抛出连接失败异常
      HttpTransportSE transportSE=new
                    HttpTransportSE("http://192.168.1.103:9999/WS?WSDL",
                                    3000);
      try{
          transportSE.call(null,envelope);
          //创建SoapObject结果对象
          SoapObject result=(SoapObject)envelope.bodyIn;
          //解析结果
          String info=result.getProperty(0).toString();
          System.out.println(info);
          return info;
      }catch (Exception e){
          e.printStackTrace();
      }
      return "failed";
}
```
