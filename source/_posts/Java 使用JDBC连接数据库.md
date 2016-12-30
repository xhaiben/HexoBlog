---
title: Java 使用JDBC连接数据库
id: 249
categories:
  - Java
date: 2016-12-13T09:38:41.000Z
tags:
  - java
  - 数据库
---
+ 注册数据库驱动
+ 使用DriverManager获取数据库连接
+ 创建Statement
+ 执行SQL语句

<!--more-->

----

#### 下载数据库驱动

![MySQL驱动下载](/images/2016/12/6NXL9SA2XE5CM996_JD_O.png)

#### 添加jar到工程下
* IDEA

![](/images/2016/12/0FCY7O14OF@UIF1KK.png)
* Eclipse

![](/images/2016/12/6QKBB2XCCY1Z111NEI.png)

#### 代码
```java
import java.sql.*;
public class DBDemo {
    //mysql驱动类名称
    public static String DBDriver = "com.mysql.jdbc.Driver";
    //mysql数据库链接路径
    public static String DBUrl = "jdbc:mysql://cacher.cc:3306/DBlearn";
    //mysql数据库用户名
    public static String USER = "user";
    //mysql数据库密码
    public static String PASSWORD = "password";
    public static void main(String[] args) throws Exception {
        //利用反射注册数据库驱动
        Class.forName(DBDriver);
        //获取数据库连接
        Connection
            connection = DriverManager.getConnection(DBUrl, USER, PASSWORD);
        //问号是占位符
        String sql = " SELECT Student.Sno,Sname,Ssex,Sage,Major,Details " +
                " FROM Student LEFT JOIN Award ON Student.Sno=Award.Sno " +
                " WHERE Student.Sno = ? ";
        //创建预编译SQL语句
        PreparedStatement statement = connection.prepareStatement(sql);
        //设置占位符的值
        statement.setString(1, "20100001");
        //执行SQL获取查询结果
        ResultSet resultSet = statement.executeQuery();
        //输出第一到第六列的值
        while (resultSet.next()) {
            System.out.print(resultSet.getString(1));
            System.out.print(resultSet.getString(2));
            System.out.print(resultSet.getString(3));
            System.out.print(resultSet.getString(4));
            System.out.print(resultSet.getString(5));
            System.out.print(resultSet.getString(6));
        }
        //释放数据库连接
        connection.close();
    }
}

```

SQLServer的数据库路径配置和MySQL不大一样，获取连接后的使用基本相同

```java
public static String DBDriver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
public static String DBUrl = "jdbc:sqlserver://192.168.44.131:1433;DatabaseName=DB";
public static String USER = "sa";
public static String PASSWORD = "password";
```
#### 表结构

* Student表

![](/images/2016/12/H1ISBGIWUII9Y_LQ3.png)

* Award表

![](/images/2016/12/KCCPTBX@CL3BIN4S.png)
> 备注：
使用`PreparedStatement`代替`Statement`，以设置占位符的方式代替`String`拼接，可在一定程度上防止**SQL注入**。
