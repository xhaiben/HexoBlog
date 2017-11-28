---
title: KafkaProducer发送过程
date: 2017-11-28 21:28:08
tags:
 - Kafka
categories:
 - Kafka
permalink: KafkaProducer-send-progress
---

<div align="center">
通过KafkaProducer源码，研究send方法的执行过程。
</div>
<!--more-->

---
### doSend方法

1. 确定指定topic的元数据可用
2. 序列换key,value
3. 获取partition
4. 整合ballback方法
5. 满足条件的情况下，唤醒I/O线程，发送消息，主线程直接返回

```java
private Future<RecordMetadata> doSend(ProducerRecord<K, V> record, Callback callback) {
    TopicPartition tp = null;
    try {
 // 确定指定topic的元数据可用
 ClusterAndWaitTime clusterAndWaitTime = waitOnMetadata(record.topic(), record.partition(), maxBlockTimeMs);
        //剩余可用时间 最大阻塞时间-获取元数据用去的时间
 long remainingWaitMs = Math.max(0, maxBlockTimeMs - clusterAndWaitTime.waitedOnMetadataMs);
        Cluster cluster = clusterAndWaitTime.cluster;
        //序列化key
 byte[] serializedKey;
        try {
            serializedKey = keySerializer.serialize(record.topic(), record.key());
        } catch (ClassCastException cce) {
            throw new SerializationException("Can't convert key of class " + record.key().getClass().getName() +
                    " to class " + producerConfig.getClass(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG).getName() +
                    " specified in key.serializer");
        }
        //序列化value
 byte[] serializedValue;
        try {
            serializedValue = valueSerializer.serialize(record.topic(), record.value());
        } catch (ClassCastException cce) {
            throw new SerializationException("Can't convert value of class " + record.value().getClass().getName() +
                    " to class " + producerConfig.getClass(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG).getName() +
                    " specified in value.serializer");
        }
        //如果record中指定了partition，则使用指定的partition，否则根据partitioner获取partition，默认为DefaultPartitioner
 int partition = partition(record, serializedKey, serializedValue, cluster);
        int serializedSize = Records.LOG_OVERHEAD + Record.recordSize(serializedKey, serializedValue);
        ensureValidRecordSize(serializedSize);
        //封装topic-partition
 tp = new TopicPartition(record.topic(), partition);
        long timestamp = record.timestamp() == null ? time.milliseconds() : record.timestamp();
        log.trace("Sending record {} with callback {} to topic {} partition {}", record, callback, record.topic(), partition);
 // 整合自定义callback中的 onCompletion 方法，和拦截器中的 onAcknowledgement 方法，在消息发送完毕，收到服务端应答后调用。
 Callback interceptCallback = this.interceptors == null ? callback : new InterceptorCallback<>(callback, this.interceptors, tp);
        // 尝试添加到缓存中
 RecordAccumulator.RecordAppendResult result = accumulator.append(tp, timestamp, serializedKey, serializedValue, interceptCallback, remainingWaitMs);
        if (result.batchIsFull || result.newBatchCreated) {
            log.trace("Waking up the sender since topic {} partition {} is either full or getting a new batch", record.topic(), partition);
            //符合条件，唤醒I/O线程，向服务端发送数据
 this.sender.wakeup();
        }
        //主线程直接返回。
 return result.future;
        // handling exceptions and record the errors;
 // for API exceptions return them in the future,
 // for other exceptions throw directly
 } catch (ApiException e) {
        log.debug("Exception occurred during message send:", e);
        if (callback != null)
            callback.onCompletion(null, e);
        this.errors.record();
        if (this.interceptors != null)
            this.interceptors.onSendError(record, tp, e);
        return new FutureFailure(e);
    } catch (InterruptedException e) {
      this.errors.record();
        if (this.interceptors != null)
            this.interceptors.onSendError(record, tp, e);
        throw new InterruptException(e);
    } catch (BufferExhaustedException e) {
        this.errors.record();
        this.metrics.sensor("buffer-exhausted-records").record();
        if (this.interceptors != null)
            this.interceptors.onSendError(record, tp, e);
        throw e;
    } catch (KafkaException e) {
        this.errors.record();
        if (this.interceptors != null)
            this.interceptors.onSendError(record, tp, e);
        throw e;
    } catch (Exception e) {
        // we notify interceptor about all exceptions, since onSend is called before anything else in this method
 if (this.interceptors != null)
            this.interceptors.onSendError(record, tp, e);
        throw e;
    }
}
```

### send方法

```java
@Override
public Future<RecordMetadata> send(ProducerRecord<K, V> record) {
    return send(record, null);
}
@Override
public Future<RecordMetadata> send(ProducerRecord<K, V> record, Callback callback) {
 // 调用拦截器中的onSend方法，先将数据处理一遍。
 ProducerRecord<K, V> interceptedRecord = this.interceptors == null ? record : this.interceptors.onSend(record);
    return doSend(interceptedRecord, callback);
}
```
send方法默认为异步方法。不阻塞主线程。

### 同步发送消息

send方法返回Future<RecordMetadata>对象，通过调用此future对象的get()方法，可实现同步发送消息。

```java
try {
    producer.send(new ProducerRecord<>(topic,messageNo,messageStr)).get();
} catch (InterruptedException | ExecutionException e) {
    e.printStackTrace();
}
```

kafkaProducer.send()方法返回Future<RecordMetadata>对象，此future的具体实现为FutureRecordMetadata，其中有一个ProduceRequestResult属性，在ProduceRequestResult中，有CountDownLatch属性。

在future对象上调用get方法，会阻塞当前线程，直到有线程调用了countDownLatch对象的countDown()方法，将count减为0，说明消息已经发送完毕。即实现同步发送。

![](https://oizhq5zzs.qnssl.com/image2017-11-27%2017_40_22.png)
![](https://oizhq5zzs.qnssl.com/image2017-11-27%2017_41_10.png)

future对象中的方法
```java
@Override
public RecordMetadata get() throws InterruptedException, ExecutionException {
    this.result.await();
    return valueOrError();
}
```
result对象中的方法
```java
public void done(TopicPartition topicPartition, long baseOffset, RuntimeException error) {
    this.topicPartition = topicPartition;
    this.baseOffset = baseOffset;
    this.error = error;
    this.latch.countDown();
}
```
在sender线程中，创建I/O传输，当收到kafka服务器的应答后，会通过回调函数，调用countDownLatch的countDown()方法，唤醒因同步发送而阻塞的线程。
