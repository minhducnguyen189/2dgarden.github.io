---

tags: ["Spring", "SpringBoot", "SpringData"]

---

# Database Configuration In SpringBoot
> Below are all [[Spring Data JPA | JPA]] configurations for databases in SpringBoot application.
## Configuration For MySQL Database
### Dependencies
- To connect mysql database from spring boot service we need to add dependencies as below into our pom.xml.

```xml

  <!-- we will use jpa in our project
  so we need to add jpa dependency -->
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>

  <dependency>
      <groupId>mysql</groupId>
      <artifactId>mysql-connector-java</artifactId>
      <scope>runtime</scope>
  </dependency>

```

### Application.properties

```.properties

  # ===============================
  # DB
  # ===============================

  #datasource url
  spring.datasource.url=jdbc:mysql://localhost:3306/todo?useUnicode=true&characterEncoding=UTF-8

  #username of database
  spring.datasource.username=root

  #password of database
  spring.datasource.password=password

  #Database platform
  spring.jpa.database-platform=org.hibernate.dialect.MySQL5InnoDBDialect

  #configure for auto generate and update table by entities
  spring.jpa.hibernate.ddl-auto=update
  spring.jpa.generate-ddl=true
  spring.jpa.show-sql=true

```

### Application.yml

```yml

  spring:
    datasource:
      driverClassName: com.mysql.jdbc.Driver
      url: jdbc:mysql://localhost:3306/todo?useUnicode=true&characterEncoding=UTF-8
      username: root
      password: password
    jpa:
      database-platform: org.hibernate.dialect.MySQL5InnoDBDialect
      hibernate.ddl-auto: update
      generate-ddl: true
      show-sql: true

```

## Configuration For Oracle Database
### Dependencies
- To connect oracle database from spring boot service we need to add dependencies as below into our pom.xml.

```xml

  <!-- we will use jpa in our project
  so we need to add jpa dependency -->
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>

  <!-- Oracle JDBC driver -->
  <dependency>
      <groupId>com.oracle.database.jdbc</groupId>
      <artifactId>ojdbc8</artifactId>
      <scope>runtime</scope>
  </dependency>

```

### Application.properties

```.properties

  #datasource connection configuration
  spring.datasource.url=jdbc:oracle:thin:@localhost:1521:XE
  spring.datasource.username=xe
  spring.datasource.password=password
  spring.datasource.driver-class-name=oracle.jdbc.OracleDriver

  #jpa database platform
  spring.jpa.database-platform=org.hibernate.dialect.Oracle10gDialect

  #configure for auto generate and update table by entities
  spring.jpa.hibernate.ddl-auto=update
  spring.jpa.generate-ddl=true
  spring.jpa.show-sql=true

```


### Application.yml

```yml

  spring:
    datasource:
      url: jdbc:oracle:thin:@localhost:1521:XE
      username: xe
      password: password
      driver-class-name: oracle.jdbc.OracleDriver
    jpa:
      database-platform: org.hibernate.dialect.Oracle10gDialect
      hibernate.ddl-auto: update
      generate-ddl: true
      show-sql: true

```

## Configuration For Posgresql Database
### Dependencies
- To connect progessql database from spring boot service we need to add dependencies as below into our pom.xml.

```xml

  <!-- we will use jpa in our project
  so we need to add jpa dependency -->
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>

  <dependency>
      <groupId>org.postgresql</groupId>
      <artifactId>postgresql</artifactId>
      <scope>runtime</scope>
  </dependency>

```

### Application.properties

```.properties

  #datasource connection configuration
  spring.datasource.url=jdbc:postgresql://localhost:5432/book_db
  spring.datasource.username=postgres
  spring.datasource.password=postgres
  spring.datasource.driver-class-name=org.postgresql.Driver

  #jpa database platform
  spring.jpa.database=postgresql
  spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect

  #configure for auto generate and update table by entities
  spring.jpa.hibernate.ddl-auto=update
  spring.jpa.generate-ddl=true
  spring.jpa.show-sql=true

```

### Application.yml

```yml

  spring:
    datasource:
      driver-class-name: org.postgresql.Driver
      url: jdbc:postgresql://localhost:5432/book_db
      username: postgres
      password: postgres
    jpa:
      database: postgresql
      database-platform: org.hibernate.dialect.PostgreSQLDialect
      hibernate.ddl-auto: update
      generate-ddl: true
      show-sql: true

```

## Configuration For H2 Database
### Dependencies
- To connect h2 database from spring boot service we need to add dependencies as below into our pom.xml.

```xml

  <!-- we will use jpa in our project
  so we need to add jpa dependency -->
  <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
  </dependency>

  <dependency>
      <groupId>com.h2database</groupId>
      <artifactId>h2</artifactId>
      <scope>runtime</scope>
  </dependency>

```

### Application.properties
- For saving data in memory we use the configuration below. Note that all data will be lost when you turn off your service.

```.properties

  #datasource configuration

  #using in memory database
  spring.datasource.url=jdbc:h2:mem:testdb

  #using h2 file
  #spring.datasource.url=jdbc:h2:file:/data/demo

  spring.datasource.driverClassName=org.h2.Driver
  spring.datasource.username=sa
  spring.datasource.password=password

  #jpa configuration
  spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
  spring.jpa.hibernate.ddl-auto=update
  spring.jpa.generate-ddl=true
  spring.jpa.show-sql=true

  #enable h2 console ui
  spring.h2.console.enabled=true

  #set h2 ui path
  spring.h2.console.path=/h2-console

  #prevent trace output
  spring.h2.console.settings.trace=false

  #disable remote access
  spring.h2.console.settings.web-allow-others=false

```

- To save your data in h2 file, let's use `jdbc:h2:file:./testdb` for `spring.datasource.url`. In which, a file named `testdb` will be created in your project and all your data will be saved in this file. So if you turn off service, your data will not be lost unless you delete the this file.


```.properties

  #datasource configuration

  #using in memory database
  spring.datasource.url=jdbc:h2:file:./testdb

  #using h2 file
  #spring.datasource.url=jdbc:h2:file:/data/demo

  spring.datasource.driverClassName=org.h2.Driver
  spring.datasource.username=sa
  spring.datasource.password=password

  #jpa configuration
  spring.jpa.database-platform=org.hibernate.dialect.H2Dialect
  spring.jpa.hibernate.ddl-auto=update
  spring.jpa.generate-ddl=true
  spring.jpa.show-sql=true

  #enable h2 console ui
  spring.h2.console.enabled=true

  #set h2 ui path
  spring.h2.console.path=/h2-console

  #prevent trace output
  spring.h2.console.settings.trace=false

  #disable remote access
  spring.h2.console.settings.web-allow-others=false

```


### Application.yml
- For saving data in memory

```yml

  spring:
    datasource:
      url: jdbc:h2:mem:testdb
      username: sa
      password: password
      driver-class-name: org.h2.Driver
      platform: h2
    jpa:
      database-platform: org.hibernate.dialect.H2Dialect
      hibernate.ddl-auto: update
      generate-ddl: true
      show-sql: true
    h2:
      console:
        enabled: true
        path: /h2-console
        settings:
          trace: false
          web-allow-others: false

```

- For saving data in h2 file

```yml

spring:
  datasource:
    url: jdbc:h2:file:./testdb
    username: sa
    password: password
    driver-class-name: org.h2.Driver
    platform: h2
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    hibernate.ddl-auto: update
    generate-ddl: true
    show-sql: true
  h2:
    console:
      enabled: true
      path: /h2-console
      settings:
        trace: false
        web-allow-others: false

```

## See Also
- [[Spring Data JPA ]]

## References
- [Docs Spring IO](https://docs.spring.io/spring-boot/docs/current/reference/html/application-properties.html#application-properties.data.spring.jpa.database)