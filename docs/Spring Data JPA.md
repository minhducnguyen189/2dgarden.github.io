---

tags: ["Spring", "SpringData", "SpringBoot"]

---

# Spring JPA

## What Is The JPA?
- The `Java Persistence API (JPA)` represents a simplification of the persistence programming model.
- Data persistence, the ability to maintain data between application sessions in some form of nonvolatile storage (such as a relational database), is crucial to enterprise applications. Applications that are developed for this environment must either manage data persistence themselves or make use of third-party solutions to handle database updates and retrievals. `JPA` provides a mechanism for managing data persistence and object-relational mapping and functions.
- `JPA` is based on the Java programming model that applies to Java EE environments, but JPA can also function within the Java SE environment. The JPA specification defines the [[Object Relational Mapping | object-relational mapping (ORM)]] internally, rather than relying on vendor-specific mapping implementations, and uses either annotations or XML to map objects into database tables. By default, `JPA` use [[Hibernate]] as the implementation for it's `ORM`. So we can say that, `JPA` defines interfaces for `ORM` and `Hibernate` is the implementation of these interfaces.
- `JPA` is designed to operate both inside and outside of a Java Enterprise Edition (Java EE) container. When you run JPA inside a container, applications can use the container to manage the persistence. If there is no container to manage JPA, the application must handle the persistence management itself. Applications that are designed for container managed persistence cannot be used outside a container, while applications that manage their own persistence can function either in a container environment or a Java SE environment.
- `JPA` also provides a query language - JPQL - that you can use to retrieve objects without writing SQL queries specific to the database you are working with.
- Java EE containers that support JPA must supply a persistence provider. A JPA persistence provider uses the following elements to persist data in an EJB 3.0 environment:

## JPA Elements
- [[Persistence Unit]]
- [[EntityManagerFactory]]
- [[Persistence Context]]
- [[EntityManager]]
- [[Entity]]

## JPA In SpringBoot
- [[JDBC And JPA In SpringBoot]]

## Open Session In View Of JPA
- [[Open Session In View Of JPA]]

## Example With JPA
- In this example, we will use JPA in a SpringBoot project to understand, how strong JPA support us to handle data from database.
- So, I advise to read [[JDBC And JPA In SpringBoot]] before getting start with the example.

### Dependencies
- So to use JPA you just simple import some dependencies as below

```xml

    <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-data-jpa</artifactId>
        <version>2.4.4</version>
    </dependency>
    <dependency>
        <groupId>mysql</groupId>
        <artifactId>mysql-connector-java</artifactId>
        <version>8.0.27</version>
        <scope>runtime</scope>
    </dependency>

```

### Entity
- We will create entities which represent for 3 tables in the database.

![[spring-boot-jdbc-core-database-tables.png]]

- Note: You don't need to create these 3 tables in the database because JPA will create for you automatically when the Spring Boot application has started.
- So in Entity classes we will use a lot of mapping annotations from JPA, so you can review these annotations in the table below:

| Annotation | Description |
| --- | --- |
| @Entity | The @Entity annotation is used to specify that the currently annotated class represents an entity type. Unlike basic and embeddable types, entity types have an identity and their state is managed by the underlying Persistence Context. |
| @Table | The @Table annotation is used to specify the primary table of the currently annotated entity. |
| @Id | The @Id annotation specifies the entity identifier. An entity must always have an identifier attribute which is used when loading the entity in a given Persistence Context. |
| @GeneratedValue | The @GeneratedValue annotation specifies that the entity identifier value is automatically generated using an identity column, a database sequence, or a table generator. Hibernate supports the @GeneratedValue mapping even for UUID identifiers. |
| @Type | The @Type annotation is used to specify the Hibernate @Type used by the currently annotated basic attribute. |
| @Column | The @Column annotation is used to specify the mapping between a basic entity attribute and the database table column. |
| @Enumerated | The @Enumerated annotation is used to specify that an entity attribute represents an enumerated type. In which, ORDINAL: stored according to the enum value’s ordinal position within the enum class, as indicated by java.lang.Enum#ordinal STRING: stored according to the enum value’s name, as indicated by java.lang.Enum#name |
| @OneToMany | The @OneToMany annotation is used to specify a one-to-many database relationship. |
| @ManyToOne | The @ManyToOne annotation is used to specify a many-to-one database relationship. |
| @JoinColumn | The @JoinColumn annotation is used to specify the FOREIGN KEY column used when joining an entity association or an embeddable collection. |
| @PrePersist | The @PrePersist annotation is used to specify a callback method that fires before an entity is persisted. |
| @PreUpdate | The @PreUpdate annotation is used to specify a callback method that fires before an entity is updated. |

- [You can find more here](https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#configurations-internal).

- The fist Entity is `CustomerEntity`, this Entity will be the parent of `OrderEntity` and one `CustomerEntity` will have many `OrderEntity`. The `CustomerEntity` java class will look like the code below.

```java

package com.springboot.data.jpa.app.entity;

import com.springboot.data.jpa.app.model.response.CustomerResponse;
import org.hibernate.annotations.Type;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

//The @Entity annotation is used to specify that the currently annotated class represents an entity type. Unlike basic and embeddable types, entity types have an identity and their state is managed by the underlying Persistence Context.
@Entity
//The @Table annotation is used to specify the primary table of the currently annotated entity.
@Table(name = "customers")
public class CustomerEntity {

    //The @Id annotation specifies the entity identifier. An entity must always have an identifier attribute which is used when loading the entity in a given Persistence Context.
    @Id
    //The @GeneratedValue annotation specifies that the entity identifier value is automatically generated using an identity column, a database sequence, or a table generator. Hibernate supports the @GeneratedValue mapping even for UUID identifiers.
    @GeneratedValue
    //The @Type annotation is used to specify the Hibernate @Type used by the currently annotated basic attribute.
    @Type(type="uuid-char")
    private UUID id;
    private String fullName;
    //The @Column annotation is used to specify the mapping between a basic entity attribute and the database table column.
    @Column(unique = true)
    private String email;
    private String address;
    private String phone;
    //The @Enumerated annotation is used to specify that an entity attribute represents an enumerated type.
    @Enumerated(EnumType.STRING)
    private Gender gender;
    private Date dob;

    //The @OneToMany annotation is used to specify a one-to-many database relationship.
    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<OrderEntity> orders = new ArrayList<>();

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public List<OrderEntity> getOrders() {
        return orders;
    }

    public void setOrders(List<OrderEntity> orders) {
        this.orders = orders;
    }
}


```

- Next we will create `OrderEntity`, so this Entity will be the parent of `ItemEntity` and One `OrderEntity` will have many `ItemEntity`. The `OrderEntity` java class will be look like as below

```java

package com.springboot.data.jpa.app.entity;

import com.springboot.data.jpa.app.model.response.OrderResponse;
import org.hibernate.annotations.Type;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "orders")
public class OrderEntity {

    @Id
    @GeneratedValue
    @Type(type="uuid-char")
    private UUID id;

    private String orderName;

    private LocalDateTime createdDate;

    private LocalDateTime lastUpdatedDate;

    @Enumerated(value = EnumType.STRING)
    private OrderStatus orderStatus;

    //The @ManyToOne annotation is used to specify a many-to-one database relationship.
    @ManyToOne(fetch = FetchType.LAZY)
    //The @JoinColumn annotation is used to specify the FOREIGN KEY column used when joining an entity association or an embeddable collection.
    @JoinColumn(name = "customer_id")
    private CustomerEntity customer;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ItemEntity> items = new ArrayList<>();


    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public CustomerEntity getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerEntity customer) {
        this.customer = customer;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    @PrePersist
    private void setCreatedDate() {
        LocalDateTime localDateTime = LocalDateTime.now();
        this.createdDate = localDateTime;
        this.lastUpdatedDate = localDateTime;
    }

    public LocalDateTime getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    @PreUpdate
    private void setLastUpdatedDate() {
        this.lastUpdatedDate = LocalDateTime.now();
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public List<ItemEntity> getItems() {
        return items;
    }

    public void setItems(List<ItemEntity> items) {
        this.items = items;
    }

}

```

- Next we will create `ItemEntity`. The `OrderEntity` java class will be look like as below

```java

package com.springboot.data.jpa.app.entity;

import com.springboot.data.jpa.app.model.response.ItemResponse;
import org.hibernate.annotations.Type;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import java.util.UUID;

@Entity
@Table(name = "items")
public class ItemEntity {

    @Id
    @GeneratedValue
    @Type(type="uuid-char")
    private UUID id;

    private String itemName;

    private Long quantity;

    private Float price;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private OrderEntity order;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public Long getQuantity() {
        return quantity;
    }

    public void setQuantity(Long quantity) {
        this.quantity = quantity;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public OrderEntity getOrder() {
        return order;
    }

    public void setOrder(OrderEntity order) {
        this.order = order;
    }
}

```

- So that's all for creating Entities and relationships.

### Repository
- Now we will create the `CustomerRepository` which will look like as below

```java

package com.springboot.data.jpa.app.repository;

import com.springboot.data.jpa.app.entity.CustomerEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface CustomerRepository extends JpaRepository<CustomerEntity, UUID> {
}

```

### Service
- Finally, we will create `CustomerJpaService` which will help us to handle logics for creating customer, orders and items.

```java

package com.springboot.data.jpa.app.service;

import com.springboot.data.jpa.app.entity.CustomerEntity;
import com.springboot.data.jpa.app.entity.OrderEntity;
import com.springboot.data.jpa.app.entity.OrderStatus;
import com.springboot.data.jpa.app.model.request.CustomerRequest;
import com.springboot.data.jpa.app.model.request.ItemRequest;
import com.springboot.data.jpa.app.model.request.OrderRequest;
import com.springboot.data.jpa.app.model.response.CustomerResponse;
import com.springboot.data.jpa.app.repository.CustomerRepository;
import com.springboot.data.jpa.app.entity.ItemEntity;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class CustomerJpaService {

    @Autowired
    private CustomerRepository customerRepository;

    public UUID createCustomer(CustomerRequest customerRequest) {
        CustomerEntity customerEntity = this.toCustomerEntity(new CustomerEntity(), customerRequest);
        if (customerRequest.getOrders() != null && !customerRequest.getOrders().isEmpty()) {
            List<OrderRequest> orderRequests = customerRequest.getOrders();
            List<OrderEntity> orderEntities = this.toOrderEntities(orderRequests);
            orderEntities.forEach(o -> o.setCustomer(customerEntity));
            customerEntity.setOrders(orderEntities);
        }
        return this.customerRepository.save(customerEntity).getId();
    }

    public CustomerResponse getCustomer(UUID customerId) {
        Optional<CustomerEntity> customerEntity = this.customerRepository.findById(customerId);
        if (customerEntity.isPresent()) {
            return customerEntity.get().toCustomerResponse();
        }
        throw new RuntimeException("Customer Not Found!");
    }

    public void updateCustomer(UUID customerId, CustomerRequest customerRequest) {
        Optional<CustomerEntity> customerEntity = this.customerRepository.findById(customerId);
        if (customerEntity.isPresent()) {
           CustomerEntity updatedCustomerEntity = this.toCustomerEntity(customerEntity.get(), customerRequest);
            this.customerRepository.save(updatedCustomerEntity);
            return;
        }
        throw new RuntimeException("Customer Not Found!");
    }

    public void deleteCustomer(UUID customerId) {
        this.customerRepository.deleteById(customerId);
    }

    private List<OrderEntity> toOrderEntities(List<OrderRequest> orderRequests) {
        return orderRequests.stream().map(o -> this.toOrderEntity(new OrderEntity(), o)).collect(Collectors.toList());
    }

    private OrderEntity toOrderEntity(OrderEntity orderEntity, OrderRequest orderRequest) {
        orderEntity.setOrderName(orderRequest.getOrderName());
        orderEntity.setOrderStatus(OrderStatus.CREATED);
        if (orderRequest.getItems() != null && !orderRequest.getItems().isEmpty()) {
            List<ItemEntity> itemEntities = this.toItemEntities(orderRequest.getItems());
            itemEntities.forEach(i -> i.setOrder(orderEntity));
            orderEntity.setItems(itemEntities);
        }
        return orderEntity;
    }

    private List<ItemEntity> toItemEntities(List<ItemRequest> itemRequests) {
        return itemRequests.stream().map(i -> this.toItemEntity(new ItemEntity(), i)).collect(Collectors.toList());
    }

    private ItemEntity toItemEntity(ItemEntity itemEntity, ItemRequest item) {
        itemEntity.setItemName(item.getItemName());
        itemEntity.setQuantity(item.getQuantity());
        itemEntity.setPrice(item.getPrice());
        return itemEntity;
    }

    private CustomerEntity toCustomerEntity(CustomerEntity customerEntity, CustomerRequest customerRequest) {
        customerEntity.setAddress(customerRequest.getAddress());
        customerEntity.setDob(customerRequest.getDob());
        customerEntity.setEmail(customerRequest.getEmail());
        customerEntity.setGender(customerRequest.getGender());
        customerEntity.setFullName(customerRequest.getFullName());
        customerEntity.setPhone(customerRequest.getPhone());
        return customerEntity;
    }
}

```

### Configuration
- Now, we will add some configurations into `application.yml` for Datasource and Connection Pool, because In `spring-boot-starter-data-jpa` dependency, we have `spring-boot-starter-jdbc` dependency and in JDBC dependency we have `HikariCP` dependency. So we can configure [[HikariCP]] from the `application.yml` as below

```yml

spring:
  datasource:
    driverClassName: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/sample?useUnicode=true&characterEncoding=UTF-8
    username: root
    password: password

    #config hikari pool for jpa
    hikari:
      connection-timeout: 30000
      maximum-pool-size: 20
      minimumIdle: 15
      idleTimeout: 30000
      maxLifetime: 180000
  jpa:
    database-platform: org.hibernate.dialect.MySQL5InnoDBDialect
    hibernate.ddl-auto: update
    generate-ddl: true
    show-sql: true
    open-in-view: true
    properties:
      hibernate:
        generate_statistics: true

logging:
  level:
    org:
      hibernate:
        stat: DEBUG

```

- For configure DataSource we will focus on properties as below

| Configuretion Properties | Description |
| --- | --- |
| spring.datasource.driver-class-name | Fully qualified name of the JDBC driver. Auto-detected based on the URL by default. |
| spring.datasource.url | JDBC URL of the database. |
| spring.datasource.username | Login username of the database. |
| spring.datasource.password | Login password of the database. |

- So for congiure `HikariCP` we will focus on some properties as below

| Configuretion Properties | Description | Default Value | Sample Configuration Value |
| --- | --- | --- | --- |
| connection-timeout | This property controls the maximum number of milliseconds that a client (that's you) will wait for a connection from the pool. If this time is exceeded without a connection becoming available, a SQLException will be thrown. Lowest acceptable connection timeout is 250 ms. | 30000 | 30000 |
| maximum-pool-size | This property controls the maximum size that the pool is allowed to reach, including both idle and in-use connections. Basically this value will determine the maximum number of actual connections to the database backend. A reasonable value for this is best determined by your execution environment. When the pool reaches this size, and no idle connections are available, calls to getConnection() will block for up to connectionTimeout milliseconds before timing out | 10 | 20 |
| minimumIdle | This property controls the minimum number of idle connections that HikariCP tries to maintain in the pool. If the idle connections dip below this value and total connections in the pool are less than maximumPoolSize, HikariCP will make a best effort to add additional connections quickly and efficiently. However, for maximum performance and responsiveness to spike demands, we recommend not setting this value and instead allowing HikariCP to act as a fixed size connection pool. | same as maximumPoolSize | 15 |
| idleTimeout | This property controls the maximum amount of time that a connection is allowed to sit idle in the pool. This setting only applies when minimumIdle is defined to be less than maximumPoolSize. Idle connections will not be retired once the pool reaches minimumIdle connections. Whether a connection is retired as idle or not is subject to a maximum variation of +30 seconds, and average variation of +15 seconds. A connection will never be retired as idle before this timeout. A value of 0 means that idle connections are never removed from the pool. The minimum allowed value is 10000ms (10 seconds) | 600000 (10 minutes) | 30000 |
| maxLifetime | This property controls the maximum lifetime of a connection in the pool. An in-use connection will never be retired, only when it is closed will it then be removed. On a connection-by-connection basis, minor negative attenuation is applied to avoid mass-extinction in the pool. We strongly recommend setting this value, and it should be several seconds shorter than any database or infrastructure imposed connection time limit. A value of 0 indicates no maximum lifetime (infinite lifetime), subject of course to the idleTimeout setting. The minimum allowed value is 30000ms (30 seconds) | 1800000 (30 minutes) | 180000 |

- [You can find more here](https://github.com/brettwooldridge/HikariCP).

- For [[Database Configuration In SpringBoot | JPA configuration properties]], you can view the table below for more details.

| Configuration Properties | Description | Default Value | Sample Configuration Value |
| --- | --- | --- | --- |
| spring.jpa.database-platform | Name of the target database to operate on, auto-detected by default. Can be alternatively set using the "Database" enum. |  | org.hibernate.dialect.MySQL5InnoDBDialect |
| spring.jpa.generate-ddl | Whether to initialize the schema on startup. | false | true |
| spring.jpa.hibernate.ddl-auto | DDL mode. This is actually a shortcut for the "hibernate.hbm2ddl.auto" property. Defaults to "create-drop" when using an embedded database and no schema manager was detected. Otherwise, defaults to "none". | "none" | update |
| spring.jpa.show-sql | Whether to enable logging of SQL statements | false | true |
| spring.jpa.open-in-view | Register OpenEntityManagerInViewInterceptor. Binds a JPA EntityManager to the thread for the entire processing of the request. | true | true |
| spring.jpa.properties.* | Additional native properties to set on the JPA provider. |  |  |

### Testing

- Now, let's start your Spring Boot service then login into mysql and use command `show processlist;` you will see the result as below

```text

mysql> show processlist;
+----+-----------------+------------------+--------+---------+------+------------------------+------------------+
| Id | User            | Host             | db     | Command | Time | State                  | Info             |
+----+-----------------+------------------+--------+---------+------+------------------------+------------------+
|  5 | event_scheduler | localhost        | NULL   | Daemon  |  531 | Waiting on empty queue | NULL             |
| 28 | root            | localhost        | NULL   | Query   |    0 | init                   | show processlist |
| 29 | root            | 172.18.0.1:49390 | sample | Sleep   |    5 |                        | NULL             |
| 30 | root            | 172.18.0.1:49392 | sample | Sleep   |    5 |                        | NULL             |
| 31 | root            | 172.18.0.1:49394 | sample | Sleep   |    5 |                        | NULL             |
| 32 | root            | 172.18.0.1:49396 | sample | Sleep   |    5 |                        | NULL             |
| 33 | root            | 172.18.0.1:49398 | sample | Sleep   |    5 |                        | NULL             |
| 34 | root            | 172.18.0.1:49400 | sample | Sleep   |    4 |                        | NULL             |
| 35 | root            | 172.18.0.1:49404 | sample | Sleep   |    4 |                        | NULL             |
| 36 | root            | 172.18.0.1:49406 | sample | Sleep   |    4 |                        | NULL             |
| 37 | root            | 172.18.0.1:49408 | sample | Sleep   |    3 |                        | NULL             |
| 38 | root            | 172.18.0.1:49410 | sample | Sleep   |    3 |                        | NULL             |
| 39 | root            | 172.18.0.1:49414 | sample | Sleep   |    3 |                        | NULL             |
| 40 | root            | 172.18.0.1:49416 | sample | Sleep   |    3 |                        | NULL             |
| 41 | root            | 172.18.0.1:49418 | sample | Sleep   |    2 |                        | NULL             |
| 42 | root            | 172.18.0.1:49420 | sample | Sleep   |    2 |                        | NULL             |
| 43 | root            | 172.18.0.1:49424 | sample | Sleep   |    1 |                        | NULL             |
+----+-----------------+------------------+--------+---------+------+------------------------+------------------+
17 rows in set (0.00 sec)

```

- As you can see, the [[HikariCP]] configuration has worked, it created 15 connections in the pool of Spring Boot service to database (from Id 29 to Id 43). 
- Then, if you use command `show tables from <database name>;` (show table in your database), then you can see JPA has created all tables based on entities for you.

```text

mysql> show tables from sample;
+------------------+
| Tables_in_sample |
+------------------+
| customers        |
| items            |
| orders           |
+------------------+
3 rows in set (0.01 sec)

```

- Moreover, if you use command `select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS c where c.constraint_schema = 'sample';` to check your tables relationships, then you also see JPA craeted all for you.

```text

mysql> select * from INFORMATION_SCHEMA.TABLE_CONSTRAINTS c where c.constraint_schema = 'sample';
+--------------------+-------------------+------------------------------+--------------+------------+-----------------+----------+
| CONSTRAINT_CATALOG | CONSTRAINT_SCHEMA | CONSTRAINT_NAME              | TABLE_SCHEMA | TABLE_NAME | CONSTRAINT_TYPE | ENFORCED |
+--------------------+-------------------+------------------------------+--------------+------------+-----------------+----------+
| def                | sample            | PRIMARY                      | sample       | customers  | PRIMARY KEY     | YES      |
| def                | sample            | UK_rfbvkrffamfql7cjmen8v976v | sample       | customers  | UNIQUE          | YES      |
| def                | sample            | PRIMARY                      | sample       | items      | PRIMARY KEY     | YES      |
| def                | sample            | FKirjef006njdi706iiqdfkgk9d  | sample       | items      | FOREIGN KEY     | YES      |
| def                | sample            | PRIMARY                      | sample       | orders     | PRIMARY KEY     | YES      |
| def                | sample            | FKpxtb8awmi0dk6smoh2vp1litg  | sample       | orders     | FOREIGN KEY     | YES      |
+--------------------+-------------------+------------------------------+--------------+------------+-----------------+----------+

```

![[spring-boot-jdbc-core-database-tables.png]]

- Next, Try to add a new customer and call update customer api with orders and items as the requests below and then you will recieve a successful status.

```json

//create new customer
curl --location --request POST 'http://localhost:8080/v1/jpa/customers' \
--header 'Content-Type: application/json' \
--data-raw '{
    "fullName": "Nguyen Minh Duc",
    "email": "abc1@gmail.com",
    "address": "Binh Duong Province",
    "phone": "0123456789",
    "gender": "M",
    "dob": "1995-10-10",
    "orders": [
        {
            "orderName": "PC",
            "items": [
                {
                    "itemName": "Monitor",
                    "quantity": 1,
                    "price": 100.0
                }
            ]
        }   
    ]
}'

//update customer
curl --location --request PUT 'http://localhost:8080/v1/jpa/customers/9c107c20-d989-4628-83e1-e728b3d4a5e5' \
--header 'Content-Type: application/json' \
--data-raw '{
    "fullName": "Nguyen Minh Duc",
    "email": "abc4@gmail.com",
    "address": "Binh Duong Province",
    "phone": "0123456789",
    "gender": "M",
    "dob": "1995-10-10"
}'

```

![[spring-boot-jpa-test-customer.png ]]

![[spring-boot-jpa-test-update-customer.png]]

- If you check the Spring Boot application log, you will see for creating new customer, there are 3 SQL statements have been executed and inserted into `customers`, `orders` and `items` tables. For updating customer, it will take 2 SQL statements. Then you can see creating or updating customer took only 1 JDBC connection. It is because by default, JPA is using `open-in-view=true`, so a transaction will be opened from from the beginning to the end of the HTTP request, if you do many sql statements in a request, so there is only one transaction and the transaction will be committed into database when the request is going to close, so that's why it takes only 1 JDBC connection from the connection pool.

```text

Hibernate: insert into customers (address, dob, email, full_name, gender, phone, id) values (?, ?, ?, ?, ?, ?, ?)
Hibernate: insert into orders (created_date, customer_id, last_updated_date, order_name, order_status, id) values (?, ?, ?, ?, ?, ?)
Hibernate: insert into items (item_name, order_id, price, quantity, id) values (?, ?, ?, ?, ?)
2022-01-29 10:14:24.377  INFO 31073 --- [nio-8080-exec-2] i.StatisticalLoggingSessionEventListener : Session Metrics {
    1096712 nanoseconds spent acquiring 1 JDBC connections;
    0 nanoseconds spent releasing 0 JDBC connections;
    4879830 nanoseconds spent preparing 3 JDBC statements;
    6299283 nanoseconds spent executing 3 JDBC statements;
    0 nanoseconds spent executing 0 JDBC batches;
    0 nanoseconds spent performing 0 L2C puts;
    0 nanoseconds spent performing 0 L2C hits;
    0 nanoseconds spent performing 0 L2C misses;
    40854489 nanoseconds spent executing 1 flushes (flushing a total of 3 entities and 2 collections);
    0 nanoseconds spent executing 0 partial-flushes (flushing a total of 0 entities and 0 collections)
}
Hibernate: select customeren0_.id as id1_0_0_, customeren0_.address as address2_0_0_, customeren0_.dob as dob3_0_0_, customeren0_.email as email4_0_0_, customeren0_.full_name as full_nam5_0_0_, customeren0_.gender as gender6_0_0_, customeren0_.phone as phone7_0_0_ from customers customeren0_ where customeren0_.id=?
Hibernate: update customers set address=?, dob=?, email=?, full_name=?, gender=?, phone=? where id=?
2022-01-29 10:14:39.224  INFO 31073 --- [nio-8080-exec-3] i.StatisticalLoggingSessionEventListener : Session Metrics {
    616086 nanoseconds spent acquiring 1 JDBC connections;
    0 nanoseconds spent releasing 0 JDBC connections;
    344811 nanoseconds spent preparing 2 JDBC statements;
    1715262 nanoseconds spent executing 2 JDBC statements;
    0 nanoseconds spent executing 0 JDBC batches;
    0 nanoseconds spent performing 0 L2C puts;
    0 nanoseconds spent performing 0 L2C hits;
    0 nanoseconds spent performing 0 L2C misses;
    3348529 nanoseconds spent executing 1 flushes (flushing a total of 1 entities and 1 collections);
    0 nanoseconds spent executing 0 partial-flushes (flushing a total of 0 entities and 0 collections)
}

```

- Then, check your tables in database, you will there all information have been inserted correctly

```text

mysql> select * from customers;
+--------------------------------------+---------------------+---------------------+----------------+-----------------+--------+------------+
| id                                   | address             | dob                 | email          | full_name       | gender | phone      |
+--------------------------------------+---------------------+---------------------+----------------+-----------------+--------+------------+
| 9c107c20-d989-4628-83e1-e728b3d4a5e5 | Binh Duong Province | 1995-10-10 07:00:00 | abc4@gmail.com | Nguyen Minh Duc | M      | 0123456789 |
+--------------------------------------+---------------------+---------------------+----------------+-----------------+--------+------------+
1 row in set (0.00 sec)

mysql> select * from orders;
+--------------------------------------+---------------------+---------------------+------------+--------------+--------------------------------------+
| id                                   | created_date        | last_updated_date   | order_name | order_status | customer_id                          |
+--------------------------------------+---------------------+---------------------+------------+--------------+--------------------------------------+
| ea8cc0ce-6232-4ff3-ac91-e8146b6e57ad | 2022-01-29 10:14:24 | 2022-01-29 10:14:24 | PC         | CREATED      | 9c107c20-d989-4628-83e1-e728b3d4a5e5 |
+--------------------------------------+---------------------+---------------------+------------+--------------+--------------------------------------+
1 row in set (0.00 sec)

mysql> select * from items;
+--------------------------------------+-----------+-------+----------+--------------------------------------+
| id                                   | item_name | price | quantity | order_id                             |
+--------------------------------------+-----------+-------+----------+--------------------------------------+
| 5bd4fb0b-a1b0-4e21-becb-5bd2df4982bd | Monitor   |   100 |        1 | ea8cc0ce-6232-4ff3-ac91-e8146b6e57ad |
+--------------------------------------+-----------+-------+----------+--------------------------------------+
1 row in set (0.00 sec)

```

- As you can see, JPA helps you to reduce the workload, you can insert data without writing any SQL native queries.
- Next, we will set `open-in-view=false` then call the `update customer api` to see what will happen when we update the customer as above. 

```json

curl --location --request PUT 'http://localhost:8080/v1/jpa/customers/9c107c20-d989-4628-83e1-e728b3d4a5e5' \
--header 'Content-Type: application/json' \
--data-raw '{
    "fullName": "Nguyen Minh Duc",
    "email": "abc5@gmail.com",
    "address": "Binh Duong Province",
    "phone": "0123456789",
    "gender": "M",
    "dob": "1995-10-10"
}'

```

![[spring-boot-jpa-open-in-view-failed-test-update-customer.png]]

- Then you check the Spring Boot application log (see the log below), you will see that there are 2 JDBC connections for updating customer api. The first one is used for getting the customer, then the second one is used to update customer. Because `open-in-view=false` so everytime we interact with entity as get or update, so a transaction will be created, commited and closed immediately, In the update customer api, we do two actions: getting a customer and updating it, so JPA made 2 separated transactions and every transaction will took a JDBC connection.

```text

Hibernate: select customeren0_.id as id1_0_0_, customeren0_.address as address2_0_0_, customeren0_.dob as dob3_0_0_, customeren0_.email as email4_0_0_, customeren0_.full_name as full_nam5_0_0_, customeren0_.gender as gender6_0_0_, customeren0_.phone as phone7_0_0_ from customers customeren0_ where customeren0_.id=?
2022-01-29 11:11:05.318  INFO 32771 --- [nio-8080-exec-2] i.StatisticalLoggingSessionEventListener : Session Metrics {
    804921 nanoseconds spent acquiring 1 JDBC connections;
    0 nanoseconds spent releasing 0 JDBC connections;
    3316634 nanoseconds spent preparing 1 JDBC statements;
    1267260 nanoseconds spent executing 1 JDBC statements;
    0 nanoseconds spent executing 0 JDBC batches;
    0 nanoseconds spent performing 0 L2C puts;
    0 nanoseconds spent performing 0 L2C hits;
    0 nanoseconds spent performing 0 L2C misses;
    0 nanoseconds spent executing 0 flushes (flushing a total of 0 entities and 0 collections);
    0 nanoseconds spent executing 0 partial-flushes (flushing a total of 0 entities and 0 collections)
}
Hibernate: select customeren0_.id as id1_0_1_, customeren0_.address as address2_0_1_, customeren0_.dob as dob3_0_1_, customeren0_.email as email4_0_1_, customeren0_.full_name as full_nam5_0_1_, customeren0_.gender as gender6_0_1_, customeren0_.phone as phone7_0_1_, orders1_.customer_id as customer6_2_3_, orders1_.id as id1_2_3_, orders1_.id as id1_2_0_, orders1_.created_date as created_2_2_0_, orders1_.customer_id as customer6_2_0_, orders1_.last_updated_date as last_upd3_2_0_, orders1_.order_name as order_na4_2_0_, orders1_.order_status as order_st5_2_0_ from customers customeren0_ left outer join orders orders1_ on customeren0_.id=orders1_.customer_id where customeren0_.id=?
Hibernate: update customers set address=?, dob=?, email=?, full_name=?, gender=?, phone=? where id=?
2022-01-29 11:11:05.402  INFO 32771 --- [nio-8080-exec-2] i.StatisticalLoggingSessionEventListener : Session Metrics {
    22940 nanoseconds spent acquiring 1 JDBC connections;
    0 nanoseconds spent releasing 0 JDBC connections;
    439798 nanoseconds spent preparing 2 JDBC statements;
    2776004 nanoseconds spent executing 2 JDBC statements;
    0 nanoseconds spent executing 0 JDBC batches;
    0 nanoseconds spent performing 0 L2C puts;
    0 nanoseconds spent performing 0 L2C hits;
    0 nanoseconds spent performing 0 L2C misses;
    28010362 nanoseconds spent executing 1 flushes (flushing a total of 2 entities and 2 collections);
    0 nanoseconds spent executing 0 partial-flushes (flushing a total of 0 entities and 0 collections)
}

```

- Then, check your tables in database, you will there all information have been updated correctly


```text

mysql> select * from customers;
+--------------------------------------+---------------------+---------------------+----------------+-----------------+--------+------------+
| id                                   | address             | dob                 | email          | full_name       | gender | phone      |
+--------------------------------------+---------------------+---------------------+----------------+-----------------+--------+------------+
| 9c107c20-d989-4628-83e1-e728b3d4a5e5 | Binh Duong Province | 1995-10-10 07:00:00 | abc5@gmail.com | Nguyen Minh Duc | M      | 0123456789 |
+--------------------------------------+---------------------+---------------------+----------------+-----------------+--------+------------+
1 row in set (0.01 sec)

```

## See Also
- [[Object Relational Mapping]]
- [[Hibernate]]
- [[HikariCP]]
- [[JDBC And JPA In SpringBoot]]
- [[Transaction]]
- [[Spring Boot Introduction]]
- [[Database Configuration In SpringBoot]]

## References
- [IBM](https://www.ibm.com/docs/en/wasdtfe?topic=applications-jpa-architecture)
- [Byteslounge](https://www.byteslounge.com/tutorials/container-vs-application-managed-entitymanager)
- [Vincenzoracca](https://www.vincenzoracca.com/en/blog/framework/jpa/jpa-em/)
- [Stack Overflow](https://stackoverflow.com/questions/30549489/what-is-this-spring-jpa-open-in-view-true-property-in-spring-boot)
- [Baeldung](https://www.baeldung.com/spring-open-session-in-view#choose-wisely)
- [Jboss](https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#configurations-internal).