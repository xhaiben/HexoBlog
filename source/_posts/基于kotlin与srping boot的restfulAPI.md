---
title: 基于kotlin与spring boot的restfulAPI
date: 2017-01-12 19:57:44
tags:
 - kotlin
 - spring
categories:
 - kotlin
permalink: kotlin-restful
---
<div align=center>基于kotlin与spring boot的restfulAPI gradle配置</div>

<!--more-->

---
### gradle配置
```gradle
group 'cacher'
version '1.0-SNAPSHOT'

buildscript {

    ext.kotlin_version = '1.0.6'
    ext.spring_boot_version='1.4.3.RELEASE'

    repositories {
        maven{ url 'http://maven.aliyun.com/nexus/content/groups/public'}
        mavenCentral()
    }
    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath("org.springframework.boot:spring-boot-gradle-plugin:$spring_boot_version")
    }
}

apply plugin: "kotlin"
apply plugin: 'idea'
apply plugin: 'war'
apply plugin: 'org.springframework.boot'

jar {
    baseName = 'UPCAidAPI'
    version = '0.1-SNAPSHOT'
}

repositories {
    maven{ url 'http://maven.aliyun.com/nexus/content/groups/public'}
    mavenCentral()
}

sourceCompatibility = 1.8
targetCompatibility = 1.8

// class文件保留参数名称
compileJava.options.compilerArgs.add '-parameters'
compileTestJava.options.compilerArgs.add '-parameters'


dependencies {
    compile group: 'org.jsoup', name: 'jsoup', version: '1.9.2'

    compile 'org.springframework.boot:spring-boot-starter-aop'
    compile 'org.springframework.boot:spring-boot-starter-web'
    testCompile("org.springframework.boot:spring-boot-starter-test")
    compile "org.jetbrains.kotlin:kotlin-stdlib:$kotlin_version"
}
sourceSets {
    main.java.srcDirs += 'src/main/java'
    main.kotlin.srcDirs += 'src/main/kotlin'
}

```
