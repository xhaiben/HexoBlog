---
title: Android 使用ViewPager实现课程切换
tags:
  - Android
id: 134
categories:
  - Java
  - Android
date: 2016-10-27 21:16:24
---
+ 添加PopupWindow的view的layout
+ 添加ViewPager的view的layout
+ 在MainActivity中初始化PopupWindow的View
+ 创建ViewPager的View
+ 为ViewPager创建Adapter
+ 为ViewPager创建Transformer

<!--more-->

---

### PopupWindow的布局
重点：设置根布局和ViewPager的`clipChildren`为`false`从而使其可以同时显示多个view

`android:clipChildren="false"`

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/page_container"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:clipChildren="false"
    android:gravity="center"
    android:weightSum="3"
    android:orientation="horizontal"
    android:layout_gravity="center"
    >
    <android.support.v4.view.ViewPager
        android:id="@+id/viewpager"
        android:layout_width="150dp"
        android:layout_height="150dp"
        android:clipChildren="false"
        android:overScrollMode="never" />
</LinearLayout>
```

### ViewPager中的View

使用TextView作为ViewPager中显示的内容

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical">
    <TextView
        android:id="@+id/textview"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:gravity="center"
        android:padding="5dp"
        android:textColor="@android:color/white" />
</LinearLayout>
```

### 创建ViewPager的Adapter

创建List<View>作为adapter的数据源

```java
List<View> viewList=new ArrayList<>();
View view=View.inflate(this,R.layout.course_textview,null);
TextView courseText=(TextView)view.findViewById(R.id.textview);
courseText.setBackgroundResource(R.drawable.course_info_blue);
courseText.setText("计算机组成原理@东环306");
viewList.add(view);

view=View.inflate(this,R.layout.course_textview,null);
courseText=(TextView)view.findViewById(R.id.textview);
courseText.setBackgroundResource(R.drawable.course_info_green);
courseText.setText("数据通信原理@南堂420");
viewList.add(view);

view=View.inflate(this,R.layout.course_textview,null);
courseText=(TextView)view.findViewById(R.id.textview);
courseText.setBackgroundResource(R.drawable.course_info_pink);
courseText.setText("数据库原理@西廊103");
viewList.add(view);
//将viewList添加到adapter中
adapter.addAll(viewList);
```

### 显示PopupWindow

实例化PopupWindow的View，并设置PopupWindow的属性

```java
View popupView=View.inflate(this,R.layout.content_main,null);
mViewPager = (ViewPager) popupView.findViewById(R.id.viewpager);
mViewPager.setPageTransformer(true,new RotateTransformer());
//设置两个View之间的间距
mViewPager.setPageMargin(dip2px(this,-30));
popupView.findViewById(R.id.page_container).setOnTouchListener(new View.OnTouchListener() {
    @Override
    public boolean onTouch(View v, MotionEvent event) {
        return mViewPager.dispatchTouchEvent(event);
    }
});
adapter=new CourseAdapter(this);
mViewPager.setAdapter(adapter);
PopupWindow popupWindow=new PopupWindow(this);
popupWindow.setContentView(popupView);
popupWindow.setWidth(ViewGroup.LayoutParams.MATCH_PARENT);
popupWindow.setHeight(ViewGroup.LayoutParams.WRAP_CONTENT);
popupWindow.setBackgroundDrawable(new ColorDrawable());
popupWindow.setFocusable(true);
popupWindow.showAtLocation(popupWindow.getContentView(),Gravity.CENTER,0,0);
```

### 效果图

![效果图](http://oiz8hjtml.bkt.clouddn.com/images/2016/10/未标题-2.gif)
