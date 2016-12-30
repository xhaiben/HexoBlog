---
title: Android 自定义 Toolbar
tags:
  - Android
  - Toolbar
id: 133
categories:
  - Java
  - Android
date: 2016-08-14 23:56:24
---

+ 设置 **NoActionBar** 主题
+ 添加 **Toolbar**
+ 添加自定义 **menu**

<!--more-->

---

### 将 **styles** 中的 **AppTheme** 改为 **NoActionBar** 的主题
```xml
<resources>
    <!-- Base application theme. -->
    <style name="AppTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <!-- Customize your theme here. -->
        <item name="colorPrimary">@color/colorPrimary</item>
        <item name="colorPrimaryDark">@color/colorPrimaryDark</item>
        <item name="colorAccent">@color/colorAccent</item>
    </style>
</resources>
```
### 添加 **Toolbar**
为 **activity** 添加 **Toolbar** 控件

```xml
<android.support.v7.widget.Toolbar
        xmlns:android="http://schemas.android.com/apk/res/android"
        android:id="@+id/toolbar"
        android:layout_height="wrap_content"
        android:layout_width="match_parent"
        android:background="?attr/colorPrimary">
</android.support.v7.widget.Toolbar>
```
可能会出现内嵌的情况

<<<<<<< HEAD
![img](https://oizhq5zzs.qnssl.com/images/2016/08/toolbarinside.png)
=======
![img](http://oiz8hjtml.bkt.clouddn.com/images/2016/08/toolbarinside.png)
>>>>>>> parent of 53331c9... 多说https改造前

将最外层的 **RelativeLayout** 中的 **padding** 属性去掉

在 **Toolbar** 的下层布局中添加 **layout_below** 属性，使其处于 **Toolbar** 下方

<<<<<<< HEAD
![img](https://oizhq5zzs.qnssl.com/images/2016/08/20160814195056.png)
=======
![img](http://oiz8hjtml.bkt.clouddn.com/images/2016/08/20160814195056.png)
>>>>>>> parent of 53331c9... 多说https改造前

### 为 **Toolbar** 添加自定义 **Menu**

在 **res** 中新建 **menu** 文件夹

新建 **xml** 文件，根标签为 **menu**

添加 **item**

```xml
<?xml version="1.0" encoding="utf-8"?>
<menu xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:app="http://schemas.android.com/apk/res-auto">
    <item
        android:id="@+id/menu_search"
        android:title="查找"
        android:icon="@drawable/search"
        app:showAsAction="ifRoom"
        ></item>
    <item
        android:id="@+id/menu_chat"
        android:title="聊天"
        android:icon="@drawable/chat"
        app:showAsAction="ifRoom"
        ></item>
    <item
        android:id="@+id/menu_leaf"
        android:title="叶子"
        android:icon="@drawable/leaf"
        app:showAsAction="ifRoom"
        ></item>
</menu>
```

在 **activity** 对应的 **class** 中添加菜单
```java
public class MainActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar=(Toolbar)findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        toolbar.setOnMenuItemClickListener(new Toolbar.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                return false;
            }
        });
    }
    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.main_menu,menu);
        return super.onCreateOptionsMenu(menu);
    }
}
```

运行结果

<<<<<<< HEAD
![img](https://oizhq5zzs.qnssl.com/images/2016/08/20160814234139.png)
=======
![img](http://oiz8hjtml.bkt.clouddn.com/images/2016/08/20160814234139.png)
>>>>>>> parent of 53331c9... 多说https改造前

设置 **title** 不显示，添加一个 **TextView** 自定义 **Title** 样式

设置显示返回箭头
```java
ActionBar actionBar=getSupportActionBar();
if(actionBar!=null){
    actionBar.setDisplayShowTitleEnabled(false);
    actionBar.setDisplayHomeAsUpEnabled(true);
}
```
