---
title: Java 使用矩阵幂计算斐波那契数列
id: 248
categories:
  - Java
date: 2016-04-27T11:30:41.000Z
tags:
  - java
  - 斐波那契
---

- 快速求幂
- 移位判断奇偶
- 矩阵乘法
- 斐波那契数列的矩阵求法

<!-- more -->

---
```java
public class Main {
    public static void main(String[] args) {
        // 初始化
        int[][] a = { { 1, 1 }, { 1, 0 } };
        Scanner scanner = new Scanner(System.in);
        int n = scanner.nextInt();
        // 计算A的n-1次方
        int[][] result = matrixPow(a, n - 1);
        // 矩阵的第一个数即为所求
        System.out.println(result[0][0]);
    }
    public static int[][] matrixMult(int[][] matrix1,int[][] matrix2){
        int[][] result=new int[matrix1.length][matrix2[0].length];
        for(int i=0;i<result[0].length;i++){
            for(int j=0;j<result[0].length;j++){
                result[i][j]=0;
                for(int k=0;k<matrix1[0].length;k++){
                    //矩阵乘法，结果的[i][j]=第一个[i][k]*第二个[k][j]
                    result[i][j]+=matrix1[i][k]*matrix2[k][j];
                    }
                }
            }
        return result;
        }
    public static int[][] matrixPow(int[][] matrix,int n){
        int[][] result=eMatrix(matrix.length);
        int[][] temp=matrix;
        //快速求幂
        for(;n>0;n>>=1){
            //判断奇偶
            if((n&1)==1){
                result=matrixMult(result, temp);
            }
            temp=matrixMult(temp, temp);
        }
        return result;
    }

    // 初始化单位矩阵
    public static int[][] eMatrix(int n) {
        int[][] E = new int[n][n];
        for (int i = 0; i<n; i++) {
            for (int j = 0; j<n; j++) {
                if (i == j) {
                    E[i][j] = 1;
                } else {
                    E[i][j] = 0;
                }
            }
        }
        return E;
    }
}
```
