---
title: Sum of Two Integers
date: 2017-02-06 19:16:50
tags:
 - Bit Manipulation
categories:
 - LeetCode
 - Bit Manipulation
permalink: Sum-of-Two-Integers
---
#### Description
Calculate the sum of two integers a and b, but you are not allowed to use the operator + and -
<!--more-->
#### 解题思路
要求不使用 + 或者 - 完成两个数加和。
使用位运算
a&b 求得两数加和的进位信息
a^b 求得两数不带进位的加法结果
> [一语道破天机](https://zhidao.baidu.com/question/265960283.html&__bd_tkn__=7ab543262e1b8d235316ae66a7bb32a08b0393fd8078338d51fed8133ea5c69d362ad36bb4bcda3b39bb3949f6bbe47087ac3af56e60b1f4e7eb60157a5af83b9b67abf05d0f03de0125277ad332ce0b49769372082ebaffa03d320b01293521cd15783348c0afa2e97a8aaccbdc8c0bc83c22f246a0)

##### 解法一
使用迭代
```java
public int getSum(int a, int b) {
        do {
            int carry = a & b;
            a = a ^ b;
            b = carry << 1;
        } while (b != 0);
        return 0;
}
```
##### 解法二
使用递归
```java
public int getSum(int a, int b) {
        return b == 0 ? a : getSum2(a ^ b, (a & b) << 1);
}
```
##### 小技巧
不适用第三个变量交换两个变量的值
1. 使用异或
```java
a = a ^ b;
b = a ^ b;
a = a ^ b;
```
2. 使用加减法
```java
a = a + b;
b = a - b;
a = a - b;
```

##### 参考链接
1. [不用加减乘除做加法题目](http://blog.sina.com.cn/s/blog_6558840b0101e4ek.html)
2. [不用加减乘除做加法](http://blog.csdn.net/imzoer/article/details/8078712)
3. [Java simple easy understand solution with explanation](https://discuss.leetcode.com/topic/49771/java-simple-easy-understand-solution-with-explanation)
