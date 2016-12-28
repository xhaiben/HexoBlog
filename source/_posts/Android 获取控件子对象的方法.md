---
title: Android 获取控件子对象的方法
tags:
  - Android
id: 134
categories:
  - Java
  - Android
date: 2016-08-15 00:49:24
---

+ 利用 Java 的反射机制
+ 通过包中的 id 获取

<!--more-->

### 利用 **java** 的反射机制

查看 **Android** 源码获得 **SearchView** 的布局

```xml
...
<LinearLayout
            android:id="@+id/search_plate"
            android:layout_width="wrap_content"
            android:layout_height="wrap_content"
            android:layout_weight="1"
            android:layout_gravity="center_vertical"
            android:orientation="horizontal">

            <view class="android.widget.SearchView$SearchAutoComplete"
                android:id="@+id/search_src_text"
                ....
            />
...
```

注意 **AutoComplete** 外层的 **LinerLayout** 还有一层 **LinerLayout**

使用反射机制和上转型获得**AutoComplete**对象

```java
Field mSearchEditFrame = searchView.getClass().getDeclaredField("mSearchEditFrame");
mSearchEditFrame.setAccessible(true); //设置字段可编辑
LinearLayout linearLayout = (LinearLayout) mSearchEditFrame.get(searchView); //第一层
LinearLayout linearLayout1 = (LinearLayout)  linearLayout.getChildAt(1); //第二层
AutoCompleteTextView a = (AutoCompleteTextView)  linearLayout1.getChildAt(0);//上转型
a.setThreshold(1); //设置AutoComplete在第一个字符的时候就开始匹配
a.setTextColor(Color.WHITE);
mag_icon = (ImageView) linearLayout.getChildAt(0);
mag_icon.setImageDrawable(null);
linearLayout.removeViewAt(0);
```

### 通过包中的 **id** 获取

查看 **android.support.v7.appcompat.SearchView** 的源码，获得控件的**id**

```java
mSearchEditFrame = findViewById(R.id.search_edit_frame);
mSearchPlate = findViewById(R.id.search_plate);
mSubmitArea = findViewById(R.id.submit_area);
mSearchButton = (ImageView) findViewById(R.id.search_button);
mGoButton = (ImageView) findViewById(R.id.search_go_btn);
mCloseButton = (ImageView) findViewById(R.id.search_close_btn);
mVoiceButton = (ImageView) findViewById(R.id.search_voice_btn);
mCollapsedIcon = (ImageView) findViewById(R.id.search_mag_icon);
```

通过 **id** 获取子控件，并进行属性设置

```java
ImageView ico=(ImageView) searchView.findViewById(android.support.v7.appcompat.R.id.search_mag_icon);
ImageView mGoButton=(ImageView)searchView.findViewById(android.support.v7.appcompat.R.id.search_go_btn);
mGoButton.setImageDrawable(ico.getDrawable());
ico.setVisibility(View.GONE);
ico.setImageDrawable(null);
```
