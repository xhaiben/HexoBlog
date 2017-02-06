---
title: Hamming Distance
date: 2017-02-06 18:11:17
tags:
 - Bit Manipulation
categories:
 - LeetCode
 - Bit Manipulation
permalink: Hamming-Distance
---

#### Description
The Hamming distance between two integers is the number of positions at which the corresponding bits are different.
Given two integers x and y, calculate the Hamming distance.
<!--more-->
两个int之间的汉明距离指的是相对位置bit不同的个数
如：
```
1   (0 0 1 1)
4   (0 1 0 0)
       ↑ ↑ ↑
```
1与4的汉明距离为2
#### 解题思路
将两个int做异或，结果中bit为1的位置，即为两个数bit不同的位置，统计bit为1的个数即可得到两个int的汉明距离。
```java
public int hammingDistance(int x, int y) {
        int z = x ^ y;
        int count = 0;
        while (z != 0) {
            if ((z & 1) == 1) {
                count++;
            }
            z >>= 1;
        }
        return count;
}
```
