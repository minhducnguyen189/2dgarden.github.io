---

tags: ["Spring", "SpringData"]

---

# Spring Data JDBC Introduction
## What Is The JDBC?
- `JDBC` stands for `Java Database Connectivity`. **JDBC** is a **Java API** to connect and execute the query with the database. It is a part of JavaSE (Java Standard Edition). **JDBC API** uses **JDBC drivers** to connect with the database.
- We can use **JDBC API** to access tabular data stored in any relational database. By the help of **JDBC API**, we can save, update, delete and fetch data from the database.
- The JDBC interface consists of two layers:
	- The JDBC API supports communication between the Java application and the JDBC manager.
	- The JDBC driver supports communication between the JDBC manager and the database driver.
- JDBC is the common API that your application code interacts with. Beneath that is the JDBC-compliant driver for the database you are using.
- [More information](https://www.infoworld.com/article/3388036/what-is-jdbc-introduction-to-java-database-connectivity.html)

![[jdbc-structure.jpg]]

## Example Project With Spring JDBC Core
- We will make examples with JDBC core in [[Spring Boot Introduction | SpringBoot]] projects.
### Dependencies
- So in this example we need to imports dependencies as `spring-jdbc` and `commons-dbcp` as below. In which `commons-dbcp` (dbcp - Database Connection Pool) from Apache will help us to manage database connections pool.

```xml

  <dependency>
      <groupId>org.springframework</groupId>
      <artifactId>spring-jdbc</artifactId>
      <version>5.3.14</version>
  </dependency>
  <dependency>
      <groupId>commons-dbcp</groupId>
      <artifactId>commons-dbcp</artifactId>
      <version>1.4</version>
  </dependency>
  <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <version>8.0.27</version>
      <scope>runtime</scope>
  </dependency>

```

### DAO

- In Database we will have some tables with **One to Many** relationships as the image below

![[spring-boot-jdbc-core-database-tables.png]]

- Note: you need to go to Database and create these tables manually before running this Spring Boot application.
- Then we will create a DAO (Data Access Object) java class which will contain queries for Create a customer with orders and items in database. The code in `CustomerDao` will look like as below

```java

package com.springboot.data.jdbc.app.dao;

import com.springboot.data.jdbc.app.model.OrderStatus;
import com.springboot.data.jdbc.app.model.request.CustomerRequest;
import com.springboot.data.jdbc.app.model.request.ItemRequest;
import com.springboot.data.jdbc.app.model.request.OrderRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.namedparam.MapSqlParameterSource;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcOperations;
import org.springframework.jdbc.core.namedparam.SqlParameterSource;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Repository
public class CustomerDao {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Autowired
    private NamedParameterJdbcOperations namedParameterJdbcOperations;


    public UUID createCustomer(CustomerRequest customerRequest) {
        String sqlCustomerQuery =
                           "INSERT INTO customers(                          "
                +          "id,                                             "   /*1*/
                +          "address,                                        "   /*2*/
                +          "dob,                                            "   /*3*/
                +          "email,                                          "   /*4*/
                +          "full_name,                                      "   /*5*/
                +          "gender,                                         "   /*6*/
                +          "phone)                                          "   /*7*/
                +          "VALUES (?, ?, ?, ?, ?, ?, ?)                    "
                ;
        UUID uuid = this.getRandomUUID();
        this.jdbcTemplate.update(sqlCustomerQuery,
                uuid.toString(),
                customerRequest.getAddress(),
                customerRequest.getDob(),
                customerRequest.getEmail(),
                customerRequest.getFullName(),
                customerRequest.getGender().toString(),
                customerRequest.getPhone());
        return uuid;
    }

    public Map<UUID, OrderRequest> createOrders(UUID customerId, List<OrderRequest> orderRequestList) {
        Map<UUID, OrderRequest> map = new HashMap<>();
        final int size = orderRequestList.size();
        String sqlOrderQuery =
                         "INSERT INTO orders(                                "
                 +       "id,                                                " /*1*/
                 +       "created_date,                                      " /*2*/
                 +       "last_updated_date,                                 " /*3*/
                 +       "order_name,                                        " /*4*/
                 +       "order_status,                                      " /*5*/
                 +       "customer_id)                                       " /*6*/
                 +       "VALUES(                                            "
                 +       ":id,                                               " /*1*/
                 +       ":created_date,                                     " /*2*/
                 +       ":last_updated_date,                                " /*3*/
                 +       ":order_name,                                       " /*4*/
                 +       ":order_status,                                     " /*5*/
                 +       ":customer_id)                                      " /*6*/
                ;
        List<SqlParameterSource> sqlParameterSources = new ArrayList<>(size);
        for (OrderRequest orderRequest: orderRequestList) {
            UUID uuid = this.getRandomUUID();
            MapSqlParameterSource mapSqlParameterSource = new MapSqlParameterSource();
            LocalDateTime now = LocalDateTime.now();
            mapSqlParameterSource.addValue("id", uuid.toString());
            mapSqlParameterSource.addValue("created_date",now);
            mapSqlParameterSource.addValue("last_updated_date", now);
            mapSqlParameterSource.addValue("order_name", orderRequest.getOrderName());
            mapSqlParameterSource.addValue("order_status", OrderStatus.CREATED.toString());
            mapSqlParameterSource.addValue("customer_id", customerId.toString());
            sqlParameterSources.add(mapSqlParameterSource);
            map.put(uuid, orderRequest);
        }
        this.namedParameterJdbcOperations.batchUpdate(sqlOrderQuery, sqlParameterSources.toArray(new SqlParameterSource[size]));
        return map;
    }

    public void createItems(UUID orderId, List<ItemRequest> itemRequests) {
        final int size = itemRequests.size();
        String itemSqlQuery =
                                "INSERT INTO items(                                 "
                        +       "id,                                                " /*1*/
                        +       "item_name,                                         " /*2*/
                        +       "price,                                             " /*3*/
                        +       "quantity,                                          " /*4*/
                        +       "order_id)                                          " /*5*/
                        +       "VALUES(                                            "
                        +       ":id,                                               " /*1*/
                        +       ":item_name,                                        " /*2*/
                        +       ":price,                                            " /*3*/
                        +       ":quantity,                                         " /*4*/
                        +       ":order_id)                                         " /*5*/
                        ;
        UUID uuid = this.getRandomUUID();
        List<SqlParameterSource> sqlParameterSources = new ArrayList<>(size);
        for (ItemRequest itemRequest: itemRequests) {
            MapSqlParameterSource mapSqlParameterSource = new MapSqlParameterSource();
            mapSqlParameterSource.addValue("id", uuid.toString());
            mapSqlParameterSource.addValue("item_name", itemRequest.getItemName());
            mapSqlParameterSource.addValue("price", itemRequest.getPrice());
            mapSqlParameterSource.addValue("quantity", itemRequest.getQuantity());
            mapSqlParameterSource.addValue("order_id", orderId.toString());
            sqlParameterSources.add(mapSqlParameterSource);
        }
        this.namedParameterJdbcOperations.batchUpdate(itemSqlQuery, sqlParameterSources.toArray(new SqlParameterSource[size]));
    }

    private UUID getRandomUUID() {
        return UUID.randomUUID();
    }
}

```

### Service
- Next we need to create a service named `CustomerJdbcService` to handle logics for create a Customer with many orders and items. The Customer will be created first, then if the Customer contains orders so orders will be created and if in every order which contains items then items will be also created. See example code below:

```java

package com.springboot.data.jdbc.app.service;

import com.springboot.data.jdbc.app.dao.CustomerDao;
import com.springboot.data.jdbc.app.model.request.CustomerRequest;
import com.springboot.data.jdbc.app.model.request.OrderRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;
import java.util.UUID;

@Service
public class CustomerJdbcService {


    @Autowired
    private CustomerDao customerDao;

    public UUID createCustomer(CustomerRequest customerRequest) {
        UUID customerId = this.customerDao.createCustomer(customerRequest);
        List<OrderRequest> orders = customerRequest.getOrders();
        if (orders != null && !orders.isEmpty()) {
            Map<UUID, OrderRequest> orderRequestMap = this.customerDao.createOrders(customerId, customerRequest.getOrders());
            for (Map.Entry<UUID, OrderRequest> map : orderRequestMap.entrySet()) {
                if (map.getValue().getItems() != null && !map.getValue().getItems().isEmpty()) {
                    this.customerDao.createItems(map.getKey(), map.getValue().getItems());
                }
            }
        }
        return customerId;
    }

}

```

### Configuration
- Now we will go to connection pool configuration with `commons-dbcp` from Apache. To do this, firstly you need to add these enviroment variables below into **application.yml**.

```yml

spring:
  datasource:
    driverClassName: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/sample?useUnicode=true&characterEncoding=UTF-8
    username: root
    password: password
    # config dbcp pool for jdbc
    maxWait: 10000
    maxActive: -1
    maxIdle: 20
    minIdle: 10
    initialSize: 10

```

- Then we will create an `ApplicationConfig` java class for **DataSource** and **JdbcTemplate** configurations as below

```java

package com.springboot.data.jdbc.app.config;

import org.apache.commons.dbcp.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;

import javax.sql.DataSource;
import java.util.Objects;

@Configuration
public class ApplicationConfig {

    @Autowired
    private Environment env;

    @Bean("dataSource")
    public DataSource getDataSource() {

        final String sqlInitQuery = "SHOW PROCESSLIST;";

        BasicDataSource basicDataSource = new BasicDataSource();
        basicDataSource.setDriverClassName(Objects.requireNonNull(env.getProperty("spring.datasource.driverClassName")));
        basicDataSource.setUrl(env.getProperty("spring.datasource.url"));
        basicDataSource.setUsername(env.getProperty("spring.datasource.username"));
        basicDataSource.setPassword(env.getProperty("spring.datasource.password"));
        basicDataSource.setInitialSize(Integer.parseInt(Objects.requireNonNull(env.getProperty("spring.datasource.initialSize"))));
        basicDataSource.setMinIdle(Integer.parseInt(Objects.requireNonNull(env.getProperty("spring.datasource.minIdle"))));
        basicDataSource.setMaxIdle(Integer.parseInt(Objects.requireNonNull(env.getProperty("spring.datasource.maxIdle"))));
        basicDataSource.setMaxWait(Long.parseLong(Objects.requireNonNull(env.getProperty("spring.datasource.maxWait"))));
        basicDataSource.setMaxActive(Integer.parseInt(Objects.requireNonNull(env.getProperty("spring.datasource.maxActive"))));
        return basicDataSource;
    }

    @Bean("jdbcTemplate")
    public JdbcTemplate getJdbcTemplate() {
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.setDataSource(getDataSource());
        jdbcTemplate.setLazyInit(false);
        return jdbcTemplate;
    }
}

```

- For **DataSource** configuration, we will create a **BasicDataSource** with some parameters that we will load from the **application.yml**.
- To configure **BasicDataSource** to make conntections to DB we just need to focus on those parameters in table below.

| Prameter | Description | Set Method | Sample Configuration Value |
| --- | --- | --- | --- |
| username |	The connection user name to be passed to our JDBC driver to establish a connection. | setUsername() | root |
| password	| The connection password to be passed to our JDBC driver to establish a connection. | setPassword() | password |
| url	| The connection URL to be passed to our JDBC driver to establish a connection. | setUrl() | jdbc:mysql://localhost:3306/sample?useUnicode=true&characterEncoding=UTF-8 |
| driverClassName |	The fully qualified Java class name of the JDBC driver to be used. | setDriverClassName() | com.mysql.cj.jdbc.Driver |

- To configure **BasicDataSource** with DBCP (Database Connection Pool) we will focus on some parameters below

| Prameter | Description | Set Method | Default Value | Sample Configuration Value |
| --- | --- | --- | --- | --- |
| initialSize | The initial number of connections that are created when the pool is started. Since: 1.2 | setInitialSize() | 0 | 10 |
| maxTotal | The maximum number of active connections that can be allocated from this pool at the same time, or negative for no limit. | setMaxActive() | 8 | -1 |
| maxIdle | The maximum number of connections that can remain idle in the pool, without extra ones being released, or negative for no limit. | setMaxIdle() | 8 | 20 |
| minIdle | The minimum number of connections that can remain idle in the pool, without extra ones being created, or zero to create none. | setMinIdle() | 0 | 10 |
| maxWaitMillis | The maximum number of milliseconds that the pool will wait (when there are no available connections) for a connection to be returned before throwing an exception, or -1 to wait indefinitely. | setMaxWait() | indefinitely | 10000 |

- [You can find more here](https://commons.apache.org/proper/commons-dbcp/configuration.html).

- So after we have configured **BasicDataSource** then we will use it to create **JdbcTemplate** bean. As you can see in the code we will set `setLazyInit(false)`, So this mean when our application is started, all connections in pool will conntect to database.

### Testing

- So now, let's start your Spring Boot service then login into mysql and use command `show processlist;` you will see the result as below

```text

mysql> show processlist;
+----+-----------------+------------------+--------+---------+------+------------------------+------------------+
| Id | User            | Host             | db     | Command | Time | State                  | Info             |
+----+-----------------+------------------+--------+---------+------+------------------------+------------------+
|  5 | event_scheduler | localhost        | NULL   | Daemon  | 6356 | Waiting on empty queue | NULL             |
| 12 | root            | 172.18.0.1:43650 | sample | Sleep   |  156 |                        | NULL             |
| 13 | root            | 172.18.0.1:43652 | sample | Sleep   |  156 |                        | NULL             |
| 14 | root            | 172.18.0.1:43656 | sample | Sleep   |  156 |                        | NULL             |
| 15 | root            | 172.18.0.1:43658 | sample | Sleep   |  156 |                        | NULL             |
| 16 | root            | 172.18.0.1:43660 | sample | Sleep   |  156 |                        | NULL             |
| 17 | root            | 172.18.0.1:43662 | sample | Sleep   |  156 |                        | NULL             |
| 18 | root            | 172.18.0.1:43664 | sample | Sleep   |  156 |                        | NULL             |
| 19 | root            | 172.18.0.1:43666 | sample | Sleep   |  156 |                        | NULL             |
| 20 | root            | 172.18.0.1:43668 | sample | Sleep   |  156 |                        | NULL             |
| 21 | root            | 172.18.0.1:43670 | sample | Sleep   |  155 |                        | NULL             |
| 24 | root            | localhost        | NULL   | Query   |    0 | init                   | show processlist |
+----+-----------------+------------------+--------+---------+------+------------------------+------------------+
12 rows in set (0.00 sec)

```

- As you can see, 10 database connections have been created (from Id 12 to Id 21) by our Spring Boot service to MySQL Database, It mean our database connection pool configuration has worked.
- Now when we execute a query from our Spring Boot service a transaction will be created then a database connection will be taken from the pool to run the query, when the query is committed a transaction will close and the connection will be available in pool again. So using connection pool will help us get connections to Database quickly and save time for create new connections for every executed query.

## See Also
- [[Spring Boot Introduction]]

## References
- [You can find the source code here](https://github.com/minhducnguyen189/com.springboot.data)
- [INFO WORLD](https://www.infoworld.com/article/3388036/what-is-jdbc-introduction-to-java-database-connectivity.html)
- [GEEKS FOR GEEKS](https://www.geeksforgeeks.org/difference-between-jdbc-and-hibernate-in-java/)
- [COMMONS DBCP APACHE](https://commons.apache.org/proper/commons-dbcp/configuration.html).