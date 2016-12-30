---
title: Tomcat 数据库连接池配置
id: 248
categories:
  - Java
date: 2016-12-19T11:30:41.000Z
tags:
  - java
  - tomcat
---

+ 配置Tomcat的context.xml
+ 配置Web工程的web.xml
+ 在Servlet中使用获取配置的数据库资源

<!--more-->

----

在Tomcat的context.xml中配置数据库的连接资源

![](http://oiz8hjtml.bkt.clouddn.com/images/2016/12/QQ截图20161213094556.png)

在Web工程的web.xml中添加此资源

![](http://oiz8hjtml.bkt.clouddn.com/images/2016/12/QQ截图20161213094748.png)

servlet中连接资源的使用
```java
try {
    Connection connection;
    Context context = new InitialContext();
    Context envContext = (Context) context.lookup("java:/comp/env");
    DataSource ds = (DataSource) envContext.lookup("jdbc/DBlearn");
    connection = ds.getConnection();
    String sql = " SELECT Student.Sno,Sname,Ssex,Sage,Major,Details " +
            " FROM Student LEFT JOIN Award ON Student.Sno=Award.Sno " +
            " WHERE Student.Sno = ? ";
    PreparedStatement statement = connection.prepareStatement(sql);
    statement.setString(1, "20100001");
    ResultSet resultSet = statement.executeQuery();
    while (resultSet.next()) {
        System.out.print(resultSet.getString(1));
        System.out.print(resultSet.getString(2));
        System.out.print(resultSet.getString(3));
        System.out.print(resultSet.getString(4));
        System.out.print(resultSet.getString(5));
        System.out.print(resultSet.getString(6));
    }
    connection.close();
} catch (Exception e) {
    e.printStackTrace();
}
```
