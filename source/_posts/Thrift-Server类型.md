---
title: Thrift-Server类型
date: 2017-11-21 23:01:40
tags:
 - Thrift
categories:
 - Thrift
permalink: thrift-server-kinds
---

<div align="center">
比较Thrift不同类型的Server的特点
</div>
<!--more-->

---
### TSimpleServer
接受一个连接，处理连接请求，直到客户端关闭连接，才去接受下一个新连接。 单线程阻塞I/O处工作模式。
主要用于测试。
![](https://oizhq5zzs.qnssl.com/TSimpleServer.jpg)

### TNonblockingServer
多路复用，非阻塞I/O模型，使用NIO，接受多个连接，每个连接处于不同的状态（建立连接、请求处理、返回数据等）
![](https://oizhq5zzs.qnssl.com/TNonblockingServer.jpg)

### THsHaServer
是TNonblockingServer的子类，在请求处理阶段，使用线程池中的新线程处理请求。主线程需要完成对所有socket的监听以及数据读写工作，当并发请求数较大，且发送数据量较多时，监听socket上新连接请求不能被及时接受。
![](https://oizhq5zzs.qnssl.com/THaHsServer.jpg)

### TThreadPoolServer
使用主线程来监控socket请求，当有新请求进来时，将socket交给新线程，在新线程中完成请求处理。传统TCPServer模型。
受限于线程池的工作能力，当并发请求数大于线程池中的可用线程数时，新请求被阻塞。
![](https://oizhq5zzs.qnssl.com/TThreadPoolServer.jpg)

### TThreadSelectorServer
Thrift提供的最高级的模式。
1. 一个AcceptThread线程对象，专门用于处理监听socket上的新连接
2. 若干个SelectorThread对象专门用于处理业务socketd的网络I/O，所有网络数据的读写均由这些线程来完成。
3. 一个负载均衡器SelectorThreadLoadBalancerd对象，主要用于在AcceptThread线程接收到一个新socket连接请求时，决定将这个新连接请求分配给哪个SelectorThread线程。
4. 一个ExecutorService类型的工作线程，在SelectorThread线程中，监听到有业务socket中有调用请求，则将请求读取之后，交给ExecutorService线程池中的线程完成此次调用的具体执行

![](https://oizhq5zzs.qnssl.com/TThreadSelectorServer.jpg)
