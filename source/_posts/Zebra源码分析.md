---
title: Zebra源码分析
date: 2017-12-27 01:53:23
tags:
 - Zebra  
categories:
 - Zebra
permalink: zebra-code-analysis
---

<div align="center">
美团点评开源数据库访问层中间件
</div>
<!--more-->

---

### GitHub地址
https://github.com/dianping/zebra

### 简介
zebra是一个基于JDBC API协议上开发出的高可用、高性能的数据库访问层解决方案。类似阿里的tddl，zebra是一个smart客户端，提供了诸如动态配置、监控、读写分离、分库分表等功能。

zebra是由基础架构团队开发和维护，定位是公司统一的数据库访问层组件（Data Access Layer），是新美大DBA团队推荐的官方数据源组件，将来也会以zebra为核心进行数据访问层的演进。

整体架构图如下所示，zebra客户端会根据路由配置直连到MySQL数据库进行读写分离和负载均衡。RDS是一个一站式的数据库管理平台，提供zebra的路由配置信息的维护。MHA组件和从库监控服务分表负责主库和从库的高可用。

![](https://oizhq5zzs.qnssl.com/image2017-2-8%2010_12_30.png)

zebra的客户端架构图如下所示，GroupDataSource下面连接一个数据库服务组集群，分为一个主和若干个从，主要进行读写分离。ShardDataSource下面包含了若干个GroupDataSource，主要进行分库分表。

![](https://oizhq5zzs.qnssl.com/image2017-2-6%2011_6_44.png)

### GroupDataSource结构

![](https://oizhq5zzs.qnssl.com/GroupDataSource.png)

GroupDataSource中包含一个FailOverDataSource(主库,writeDataSource)和一个LoadBalanceDataSource(从库群,readDataSource)。
FailOverDataSource中只有一个SingleDataSource即master。
LoadBalanceDataSource中可以有多个从库Map<String,SingleDataSource>，即dataSources，包含从库ID到从库的映射。

### Zebra初始化过程

Spring通过init-method初始化GroupDataSource
```java
public synchronized void init() {
    //检查jdbcRef配置是否为空
        if (StringUtils.isBlank(jdbcRef)) {
            throw new ZebraException("jdbcRef cannot be empty");
        } else {
      //检查当前jdbcRef创建了多少个GroupDataSource，保证其不大于设定值。默认为3
            Integer count = jdbcRefMaxInitialCountMap.get(jdbcRef);
            if (count != null && count >= jdbcRefMaxInitialCount) {
                throw new ZebraException("jdbcRef [" + jdbcRef + "] count exceed limit[" + jdbcRefMaxInitialCount +
                        "],see: https://wiki.sankuai.com/pages/viewpage.action?pageId=1181853636");
            }

            logger.info("initialize a new GroupDataSource by using jdbcRef[" + jdbcRef + "].");
        }

        if (init) {
            throw new ZebraException(String.format("GroupDataSource [%s] is already initialized once.", jdbcRef));
        } else {
            this.init = true;
        }

        try {
      //lion权限检查
            this.securityCheck();
      //出lion中读取配置信息，初始化配置
            this.initConfig();
      //初始化过滤器
            this.initFilters();
      //责任链模式，初始化GroupDataSource
            if (filters != null && filters.size() > 0) {
                JdbcFilter chain = new DefaultJdbcFilterChain(filters) {
                    @Override
                    public void initGroupDataSource(GroupDataSource source, JdbcFilter chain) {
                        if (index < filters.size()) {
                            filters.get(index++).initGroupDataSource(source, chain);
                        } else {
                            source.initInternal();
                        }
                    }
                };
                chain.initGroupDataSource(this, chain);
            } else {
                initInternal();
            }
        } catch (Exception e) {
            String errorMsg = "init GroupDataSource[" + jdbcRef + "] error!";
            logger.error(errorMsg, e);
            throw new ZebraException(errorMsg, e);
        }
    //jdbcRef对应的创建数+1
        Integer count = jdbcRefMaxInitialCountMap.get(jdbcRef);
        if (count == null) {
            count = 0;
        }
        jdbcRefMaxInitialCountMap.put(jdbcRef, count++);

    }
```

### SQL执行过程

* 通过groupDataSource.getConnection()获取Connection对象

```java
@Override
  public Connection getConnection() throws SQLException {
      return getConnection(null, null);
  }

  @Override
  public Connection getConnection(final String username, final String password) throws SQLException {
      if (filters != null && filters.size() > 0) {
          JdbcFilter chain = new DefaultJdbcFilterChain(filters) {
              @Override
              public GroupConnection getGroupConnection(GroupDataSource source, JdbcFilter chain) throws SQLException {
                  if (index < filters.size()) {
                      return filters.get(index++).getGroupConnection(source, chain);
                  } else {
                      return source.getConnectionInternal(username, password);
                  }
              }
          };
          return chain.getGroupConnection(this, chain);
      } else {
          return getConnectionInternal(username, password);
      }
  }

  private GroupConnection getConnectionInternal(String username, String password) throws SQLException {
      checkInit();
      return new GroupConnection(readDataSource, writeDataSource, readWriteStrategy, routerType, filters);
  }

  private void checkInit() throws SQLException {
      if (!init) {
          throw new SQLException(String.format("GroupDataSource [%s] is not initialized", jdbcRef));
      }
  }
```

责任链模式

创建GroupConnection对象，设置readDataSource与writeDataSource及读写策略readWriteStrategy、路由策略、过滤器。

此时并没有创建真实的Connection。

* 通过groupConnection.createStatement()创建Statement

```java
@Override
public Statement createStatement() throws SQLException {
  checkClosed();
  Statement stmt = new GroupStatement(this, this.filters);
  openedStatements.add(stmt);
  return stmt;
}

@Override
public Statement createStatement(int resultSetType, int resultSetConcurrency) throws SQLException {
  GroupStatement stmt = (GroupStatement) createStatement();
  stmt.setResultSetType(resultSetType);
  stmt.setResultSetConcurrency(resultSetConcurrency);
  return stmt;
}

@Override
public Statement createStatement(int resultSetType, int resultSetConcurrency, int resultSetHoldability)
      throws SQLException {
  GroupStatement stmt = (GroupStatement) createStatement(resultSetType, resultSetConcurrency);
  stmt.setResultSetHoldability(resultSetHoldability);
  return stmt;
}
```

创建GroupStatement对象，传入this(GroupConnection)和过滤器(filters)

* 执行SQL，以statement.executeQuery()以例

```java
@Override
public ResultSet executeQuery(final String sql) throws SQLException {
  checkClosed();
  closeCurrentResultSet();

  Connection conn = this.groupConnection.getRealConnection(sql, false);

  return executeQueryOnConnection(conn, sql);
}

private ResultSet executeQueryOnConnection(Connection conn, String sql) throws SQLException {
  Statement stmt = createInnerStatement(conn, false);
  currentResultSet = new GroupResultSet(stmt.executeQuery(sql));
  return currentResultSet;
}
```

此时会判断SQL串，通过对SQL串的判断，选择readDataSource或writeDataSource创建真实的Connection。

### 动态变化配置

在GroupDataSource初始化时，会初始化LionConfigService，添加了对Lion配置的监听，当收到Lion推送的数据变化信息时，对数据库的配置进行更新。

```java
@Override
public void init() {
  try {
    configListener = new ConfigListener() {
      @Override
      public void configChanged(ConfigEvent configEvent) {
        String key = configEvent.getKey();
        String value = configEvent.getValue();

        logger.info(String.format("Receive lion change notification. Key[%s], Value[%s]", key, value));

        PropertyChangeEvent event = new AdvancedPropertyChangeEvent(this, key, null, value);
        for (PropertyChangeListener listener : listeners) {
          listener.propertyChange(event);
        }
      }
    };

    Lion.addConfigListener(configListener);
  } catch (LionException e) {
    logger.error("fail to initilize Remote Config Manager for DAL", e);
    throw new ZebraConfigException(e);
  }
}
```

### 主从切换

通过MHA对主库进行监控，当主库发生故障时，MHA更新Lion配置，Zebra收到Lion的推送时，更新主库配置，将writeDataSource中的master置为null，阻止后续对主库的操作。

当主从切换完成后，MHA向Lion更新主库IP地址，Zebra收到Lion推送后，更新主库信息，主从切换完成。

```java
public synchronized void refresh(Map<String, DataSourceConfig> newFailoverConfig) {
  if (this.configs.toString().equals(newFailoverConfig.toString())) {
    return;
  }

  if (newFailoverConfig.isEmpty()) {
    this.dataSourceManager.destoryDataSource(this.master);
    //将master置为null
    this.master = null;
    this.configs = newFailoverConfig;
  } else {
    SingleDataSource newMaster = null;
    for (DataSourceConfig config : newFailoverConfig.values()) {
      newMaster = this.dataSourceManager.createDataSource(config, this.filters);

      // switch first
      SingleDataSource oldMaster = master;
      this.master = newMaster;
      this.configs = newFailoverConfig;

      // close after
      this.dataSourceManager.destoryDataSource(oldMaster);
      break;
    }
  }
}
//获取连接时，检查master状态，若master为null，则抛出异常。
@Override
public Connection getConnection() throws SQLException {
  return getConnection(null, null);
}

@Override
public Connection getConnection(String username, String password) throws SQLException {
  checkMaster();

  return master.getConnection();
}

private void checkMaster() throws SQLException {
  if (master == null) {
    throw new SQLException("master is not avaliable now, MHA failover may happened");
  }
}
```

### 备注

* Zebra默认使用懒加载的方式创建数据库连接池，为了避免懒加载模式造成数据库第一次访问请求的延迟，在Spring的配置中应关闭其懒加载。
