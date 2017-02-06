---
title: Counting-Bits
date: 2017-02-06 18:55:17
tags:
 - Bit Manipulation
 - Dynamic Programming
categories:
 - LeetCode
 - Dynamic Programming
permalink: Counting-Bits
---
#### Description
Given a non negative integer number num. For every numbers i in the range 0 ≤ i ≤ num calculate the number of 1's in their binary representation and return them as an array.
<!--more-->
#### 解题思路
求从0到n的每一个数的二进制中，所含有的1的个数。
属于动态规划
##### 解法1
如果一个数是2的次方数，则其二进制中1个数为1。如
1,2,4,8,16...
否则其二进制中1的个数为其左边的2的次方数的1加上其与该次方数的差的1的个数。如
11
左边的2的次方数为8
11与8的差为3
则11的二进制的1的个数为8的二进制的1的个数(1)加上3的二进制的1的个数(2)为3
```java
public int[] countBits(int num) {
        int[] bits = new int[num + 1];
        bits[0] = 0;
        if (num >= 1) {
            bits[1] = 1;
        }
        for (int i = 2; i <= num; i++) {
            Double x = Math.log(i) / Math.log(2);
            if (x - x.intValue() <= 0.0000000001) {
                bits[i] = 1;
            } else {
                int p = x.intValue();
                bits[i] = bits[1 << p] + bits[i - (1 << p)];
            }
        }
        return bits;
}
```
##### 解法2
评论区大神解法
某数的二进制的1的个数，为左移1位后结果的二进制的1的个数，加上其最后一位1的个数。
如 11 的8位二进制
0000 1011 最后一位为1
右移1位
0000 0101 (5)
则8的二进制中1的个数为5的二进制中1的个数(2)，加上其最后一位1的个数(1)为3
```java
public int[] countBits2(int num) {
        int[] bits = new int[num + 1];
        for (int i = 1; i <= num; i++) {
            bits[i] = bits[i >> 1] + (i & 1);
        }
        return bits;
}
```
