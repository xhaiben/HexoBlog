---
title: Number Complement
date: 2017-02-06 18:20:17
tags:
 - Bit Manipulation
categories:
 - LeetCode
 - Bit Manipulation
permalink: Number-Complement
---
#### Description
Given a positive integer, output its complement number. The complement strategy is to flip the bits of its binary representation.
<!--more-->
Note:
1. The given integer is guaranteed to fit within the range of a 32-bit signed integer.
2. You could assume no leading zero bit in the integer’s binary representation.

#### 解题思路
##### 难点
题目要求将一个正整数各位取反，但是要注意前导0。例如用4位二进制表示5，二进制为

    0101

取反后为

    0010
    
即2。
int在java中为64位，在取反的时候要消去前面的0的影响。
##### 解法1
从右向左，依次将其位上取反
```java
public int findComplement(int num) {
        if (num == 0) {
            return ~0;
        }
        int count = 0;
        int num2 = num;
        while (num != 0) {
            num2 ^= 1 << count;
            num >>= 1;
            count++;
        }
        return num2;
}
```
##### 解法2
评论区大神给出的解法
先求掩码，再用掩码求结果
例如，用8位2进制表示5
```
5       0000 0101
mask    1111 1000
~mask   0000 0111
5^~mask 0000 0010
```
```java
public int findComplement2(int num) {
        //各位全1
        int mask = -1;
        while ((mask & num) != 0)
            mask <<= 1;
        return num ^ ~mask;
}
```
