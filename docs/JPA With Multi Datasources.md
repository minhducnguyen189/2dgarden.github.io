---

tags: ["Spring", "SpringData", "SpringBoot"]

---

## JPA With Multi Datasource Introduction

> In some special cases, sometimes we have to connect to multi databases to handle the business logic. In this post I will show you step by step configuration for spring boot service.

## Step 1: Add Dependencies In Pom.xml
- I'm using MySQL database so I need to add 2 dependencies are `mysql-connector-java` and `spring-boot-starter-data-jpa`

```xml
    <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
    </dependency>

    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>

```

## Step 2: Project Structure Overview
![[spring-boot-multi-datasource-project-structure.JPG]]
- As you can see in the picture above. We have two sub `packages` (`primary`, `secondary`) in `entity` and `repository` package respectively, one is `primary package` which contains all **repositories** and **entities** for the `primary` datasource. The second one is the `secondary package` which contains all **repositories** and **entities** for the `secondary` datasource.

- Then we also have `configurations package` which contains all **datasource configuration**.

## Step 3: Application.yml
- to connect to two database schemas we need to add some configuration in the `application.yml` as below:

```yaml
spring:
  datasource:
    driverClassName: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/primaryDb?useSSL=false  #This is the primary DB connection url
    username: root
    password: password
  second-datasource:
    driverClassName: com.mysql.jdbc.Driver
    url: jdbc:mysql://localhost:3306/secondaryDb?useSSL=false  #This is the secondary DB connection url
    username: root
    password: password
  jpa:
    hibernate.ddl-auto: update
    hibernate.dialect: org.hibernate.dialect.MySQL5Dialect
    generate-ddl: true
    show-sql: true
```

## Step 4: Create And Config Configuration File For Primary Schema
- To config for `primary schema` we need to create a configuration file named `PrimarySchemaConfiguration.java` in the package `configurations`
- The configuration for the `primary datasource` is showed as below:

```java
package com.springboot.data.jpa.multi.datasource.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Objects;

@Configuration
/**
 use this anotation to define the base package repository for primary data source,
 the EntityFactory and the transactionManager
 **/
@EnableJpaRepositories(
        basePackages = "com.springboot.data.jpa.multi.datasource.repository.primary",
        entityManagerFactoryRef = "primaryEntityManager",
        transactionManagerRef = "primaryTransactionManager")
public class PrimarySchemaConfiguration {

  @Autowired
  private Environment env;

  @Bean(name = "primaryDataSource")
  @Primary
  public DataSource primaryDataSourceConfiguration() {
    DriverManagerDataSource dataSource = new DriverManagerDataSource();
    dataSource.setDriverClassName(Objects.requireNonNull(env.getProperty("spring.datasource.driverClassName")));
    dataSource.setUrl(env.getProperty("spring.datasource.url"));
    dataSource.setUsername(env.getProperty("spring.datasource.username"));
    dataSource.setPassword(env.getProperty("spring.datasource.password"));
    return dataSource;
  }

  @Bean(name = "primaryEntityManager")
  @Primary
  public LocalContainerEntityManagerFactoryBean primaryEntityManager() {
    LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
    em.setDataSource(primaryDataSourceConfiguration());
    /**
      this is the package url which contains entities of primary datasource
      **/
    em.setPackagesToScan("com.springboot.data.jpa.multi.datasource.entity.primary");

    HibernateJpaVendorAdapter vendorAdapter = new HibernateJpaVendorAdapter();
    em.setJpaVendorAdapter(vendorAdapter);
    HashMap<String, Object> properties = new HashMap<String, Object>();
    properties.put("hibernate.hbm2ddl.auto", env.getProperty("spring.jpa.hibernate.ddl-auto"));
    properties.put("hibernate.dialect", env.getProperty("spring.jpa.hibernate.hibernate.dialect"));
    em.setJpaPropertyMap(properties);
    return em;
  }

  @Bean(name = "primaryTransactionManager")
  @Primary
  public PlatformTransactionManager primaryTransactionManager() {
    JpaTransactionManager jpaTransactionManager = new JpaTransactionManager();
    jpaTransactionManager.setEntityManagerFactory(primaryEntityManager().getObject());
    return jpaTransactionManager;
  }
}

```

## Step 5: Create And Config Configuration File For Secondary Schema
- To config for `secondary schema` we need to create a configuration file named `secondaryDataSourceConfiguration.java` in the package `configurations`
- The configuration for the `secondary datasource` is showed as below:

```java
package com.springboot.data.jpa.multi.datasource.configuration;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;
import org.springframework.jdbc.datasource.DriverManagerDataSource;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.orm.jpa.LocalContainerEntityManagerFactoryBean;
import org.springframework.orm.jpa.vendor.HibernateJpaVendorAdapter;
import org.springframework.transaction.PlatformTransactionManager;

import javax.sql.DataSource;
import java.util.HashMap;
import java.util.Objects;

@Configuration
/**
 use this anotation to define the base package repository for secondary data source,
 the EntityFactory and the transactionManager
 **/
@EnableJpaRepositories(basePackages = "com.springboot.data.jpa.multi.datasource.repository.secondary",
        entityManagerFactoryRef = "secondaryEntityManager",
        transactionManagerRef = "secondaryTransactionManager")
public class SecondarySchemaConfiguration {

  @Autowired
  private Environment env;

  @Bean(name = "secondaryDataSource")
  public DataSource secondaryDataSourceConfiguration() {
    DriverManagerDataSource dataSource = new DriverManagerDataSource();
    dataSource.setDriverClassName(Objects.requireNonNull(env.getProperty("spring.second-datasource.driverClassName")));
    dataSource.setUrl(env.getProperty("spring.second-datasource.url"));
    dataSource.setUsername(env.getProperty("spring.second-datasource.username"));
    dataSource.setPassword(env.getProperty("spring.second-datasource.password"));
    return dataSource;
  }

  @Bean(name = "secondaryEntityManager")
  public LocalContainerEntityManagerFactoryBean secondaryEntityManager() {
    LocalContainerEntityManagerFactoryBean em = new LocalContainerEntityManagerFactoryBean();
    em.setDataSource(secondaryDataSourceConfiguration());
    /**
      this is the package which contains entities of primary datasource
      **/
    em.setPackagesToScan("com.springboot.data.jpa.multi.datasource.entity.secondary");
    HibernateJpaVendorAdapter jpaVendorAdapter = new HibernateJpaVendorAdapter();
    em.setJpaVendorAdapter(jpaVendorAdapter);
    HashMap<String, Object> properties = new HashMap<>();
    properties.put("hibernate.hbm2ddl.auto", env.getProperty("spring.jpa.hibernate.ddl-auto"));
    properties.put("hibernate.dialect", env.getProperty("spring.jpa.hibernate.hibernate.dialect"));
    em.setJpaPropertyMap(properties);
    return em;
  }

  @Bean(name = "secondaryTransactionManager")
  public PlatformTransactionManager secondaryTransactionManager() {
    JpaTransactionManager transactionManager = new JpaTransactionManager();
    transactionManager.setEntityManagerFactory(secondaryEntityManager().getObject());
    return transactionManager;
  }

}

```

## Step 6: Create And Config Configuration File For Transaction Chain
- Sometime we will work with two/multiple databases in **a single request**, and if we have an error in any transaction of two schema while executing. We will **need to revert all data which are saved in one of two databases**. Thus we need to configure the `transaction chain` to handle this issue.

- Assume that we save a data into **DB A successfully** then we continous saving data to **DB B**. Unfortunally, **saving data to DB B is failed** and we want to **revert the data which is saved into DB A**.

- We need to create a configuration file named `TransactionChainConfiguration.java` in `configurations package`. The contents of file are showed as below:

```java
package com.springboot.data.jpa.multi.datasource.configuration;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.transaction.ChainedTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;

@Configuration
public class TransactionChainConfiguration {

  /**
    we will create ChainedTransactionManager by two PlatformTransactionManager
    which are `primaryTransactionManager` and `secondaryTransactionManager`
    because we want to revert transaction if one of them happens issue in saving data.
    **/
  @Bean(name = "chainedTransactionManager")
  public ChainedTransactionManager transactionChainConfiguration(
          @Qualifier("primaryTransactionManager") PlatformTransactionManager primaryTransaction,
          @Qualifier("secondaryTransactionManager") PlatformTransactionManager secondaryTransaction) {
    return new ChainedTransactionManager(primaryTransaction, secondaryTransaction);
  }

}

```

## Step 7: Declare Entity In Using With Multi Datasources
- For delaration entities, please look at the examples belows:

```java

package com.springboot.data.jpa.multi.datasource.entity.primary;

import org.hibernate.annotations.Type;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;
import java.util.UUID;

@Entity
/**
 This entity is used for primary DB with the schema = "primaryDb"
 **/
@Table(schema = "primaryDb", name = "customers")
public class PrimaryCustomerEntity {

  @Id
  @GeneratedValue
  @Type(type="uuid-char")
  private UUID id;
  private String fullName;
  private String email;
  private String address;
  private String phone;
  private Date dob;

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

  public Date getDob() {
    return dob;
  }

  public void setDob(Date dob) {
    this.dob = dob;
  }
}



```

```java

package com.springboot.data.jpa.multi.datasource.entity.secondary;

import org.hibernate.annotations.Type;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;
import java.util.Date;
import java.util.UUID;

@Entity
@Table(schema = "secondaryDb", name = "customers")
public class CustomerEntity {

  @Id
  @GeneratedValue
  @Type(type="uuid-char")
  private UUID id;
  private String fullName;
  private String email;
  private String address;
  private String phone;
  private Date dob;

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

  public Date getDob() {
    return dob;
  }

  public void setDob(Date dob) {
    this.dob = dob;
  }

}

```

## Step 8: Using Transaction Of Primary And Secondary Datasource In Service Class
- To use `Transactional` for primary or secondary DB when we need to get/update data we need to declare which `Transactional (belong to which DB)` that we want to use. Let's see the example below

- We will create a service class named `GeneralService`. Then we **Autowired** two **repositories**, one for `primary datasource` and one for `secondary datasource`.


```java

package com.springboot.data.jpa.multi.datasource.service;

import com.springboot.data.jpa.multi.datasource.entity.primary.PrimaryCustomerEntity;
import com.springboot.data.jpa.multi.datasource.entity.secondary.CustomerEntity;
import com.springboot.data.jpa.multi.datasource.model.Customer;
import com.springboot.data.jpa.multi.datasource.repository.primary.PrimaryCustomerRepository;
import com.springboot.data.jpa.multi.datasource.repository.secondary.CustomerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

@Service
/**
 use  @EnableTransactionManagement to enable using Transactional Management
 **/
@EnableTransactionManagement
public class GeneralService {

  @Autowired
  private PrimaryCustomerRepository primaryCustomerRepository;

  @Autowired
  private CustomerRepository customerRepository;

  /**
    use @Transactional with value (bean name of primaryTransactionManager)
    so the Jpa will know which transaction that we want to use.
    **/
  @Transactional(value = "primaryTransactionManager")
  public UUID saveDataToPrimaryCustomerSchema(Customer customer) {
    PrimaryCustomerEntity primaryCustomerEntity = new PrimaryCustomerEntity();
    primaryCustomerEntity.setAddress(customer.getAddress());
    primaryCustomerEntity.setEmail(customer.getEmail());
    primaryCustomerEntity.setFullName(customer.getFullName());
    primaryCustomerEntity.setPhone(customer.getPhone());
    primaryCustomerEntity.setDob(customer.getDob());
    return primaryCustomerRepository.save(primaryCustomerEntity).getId();
  }

  /**
    use @Transactional with value (bean name of secondaryTransactionManager)
    so the Jpa will know which transaction that we want to use.
    **/
  @Transactional(value = "secondaryTransactionManager")
  public UUID saveDataToSecondaryCustomerSchema(Customer customer) {
    CustomerEntity customerEntity = new CustomerEntity();
    customerEntity.setAddress(customer.getAddress());
    customerEntity.setEmail(customer.getEmail());
    customerEntity.setFullName(customer.getFullName());
    customerEntity.setPhone(customer.getPhone());
    customerEntity.setDob(customer.getDob());
    return customerRepository.save(customerEntity).getId();
  }

  /**
    use @Transactional with value (bean name of chainedTransactionManager)
    so the Jpa will know which transaction that we want to use.
    If saving data to secondary is failed, so the data
    which is saved in primary DB will be reverted.
    **/
  @Transactional(value = "chainedTransactionManager")
  public List<UUID> saveDataToAllSchemas(Customer customer) {
    UUID primaryCustomerId = saveDataToPrimaryCustomerSchema(customer);
    UUID customerId = saveDataToSecondaryCustomerSchema(customer);
    /**
      this comment function is used for revert all data in DB
      when this function is executed successfully
      **/
    // TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
    return Arrays.asList(primaryCustomerId, customerId);
  }

}

```

## Step 9: Testing
- Now, execute apis to primary datasource, secondary datasource and for all schemas, you can see the results as below

![[spring-boot-multi-datasource-project-primary-db-test.PNG]]

![[spring-boot-multi-datasource-project-secondary-db-test.PNG]]

![[spring-boot-multi-datasource-project-all-dbs-test.PNG]]

- After saving data into two databases, we can go to primary and secondary database to check the data as the images below:

![[spring-boot-multi-datasource-project-primary-db-table.JPG]]

![[spring-boot-multi-datasource-project-secondary-db-table.JPG]]

## References
- You can view [all source code here](https://github.com/minhducnguyen189/com.springboot.data/tree/master/jpa-multi-datasource)