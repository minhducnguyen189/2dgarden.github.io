---

tags: ["Spring", "SpringData"]

---

# Flyway Regular Versioned Migration Example
## Regular Versioned Migration With Spring Boot
- In this example, we will use flyway with [[Flyway Versioned Migrations]] and [[Database Migrations with Flyway | SQL-based migrations]] for [[Spring Boot Introduction | Spring Boot]] service.

### Dependencies
- To use Flyway in Spring Boot, we need to add the dependencies as below:

```xml

	<!--flyway dependency-->
	<dependency>
			<groupId>org.flywaydb</groupId>
			<artifactId>flyway-core</artifactId>
			<version>8.2.0</version>
	</dependency>

```

### CONFIGURATION
- In this example, we will use mysql database and [[Spring Data JPA | JPA]]. So we will need to add some configurations below into our `application.yml`

```yml

spring:
  datasource:
    driverClassName: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/customer?useSSL=false
    username: root
    password: password
  jpa:
    hibernate.ddl-auto: none
    hibernate.dialect: org.hibernate.dialect.MySQL5Dialect
    generate-ddl: true
    show-sql: false
  flyway:
#    enabled: true
#    baselineOnMigrate: true
    driverClassName: ${spring.datasource.driverClassName}
    url: ${spring.datasource.url}
    user: ${spring.datasource.username}
    password: ${spring.datasource.password}
    locations: classpath:db/migration
		
```

- As you can see, we will stop using `ddl-auto` of JPA by set `none` value, because we want to control our table structures by Flyway with versions, not from the [[Entity | Entities]] relationships.
- In `flyway` configuration, we will need to reuse configurations from the `datasource` such as `url`, `username`, `password` and `driverClassName`. By default, the `flyway.enabled` will be `true`.
- In the `locations` field, you will put your path from your `resources` to the directory that contains `migration` files.

![[spring-boot-versioned-migration-flyway-path.png]]

- For the `baselineOnMigrate` we will have another topic about it.

### Create Migration File
- We are using `Versioned Migration` so we will set the name of migration file as below.

```text

V1.0_20220426223800__Initial_Table.sql

```
- View more about naming in [[Flyway SQL-based Migrations | Flyway SQL-based Migrations]].
- In which:
	-  `V` is the prefix which used for `Versioned Migration`.
	- `1.0_20220426223800` is the version with timestamp.
	- `__` is the separator.
	- `Initial_Table` is the description.
	- `.sql` is the suffix.

- Then, in the migration file, we should put the the SQL scripts for creating table as below:

```sql

CREATE TABLE `customers` (
  `id` varchar(255) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `dob` datetime(6) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `fullName` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

```

### Testing 1
- Now, let's start your Spring Boot service and go to your database. You should see there are two tables that created.

```sql

mysql> show tables;
+-----------------------+
| Tables_in_customer    |
+-----------------------+
| customers             |
| flyway_schema_history |
+-----------------------+
2 rows in set (0.00 sec)

mysql> describe customers;
+-----------+--------------+------+-----+---------+-------+
| Field     | Type         | Null | Key | Default | Extra |
+-----------+--------------+------+-----+---------+-------+
| id        | varchar(255) | NO   | PRI | NULL    |       |
| address   | varchar(255) | YES  |     | NULL    |       |
| dob       | datetime(6)  | YES  |     | NULL    |       |
| email     | varchar(255) | YES  |     | NULL    |       |
| fullName  | varchar(255) | YES  |     | NULL    |       |
| phone     | varchar(255) | YES  |     | NULL    |       |
| full_name | varchar(255) | YES  |     | NULL    |       |
+-----------+--------------+------+-----+---------+-------+
7 rows in set (0.00 sec)

mysql> describe flyway_schema_history;
+----------------+---------------+------+-----+-------------------+-------------------+
| Field          | Type          | Null | Key | Default           | Extra             |
+----------------+---------------+------+-----+-------------------+-------------------+
| installed_rank | int           | NO   | PRI | NULL              |                   |
| version        | varchar(50)   | YES  |     | NULL              |                   |
| description    | varchar(200)  | NO   |     | NULL              |                   |
| type           | varchar(20)   | NO   |     | NULL              |                   |
| script         | varchar(1000) | NO   |     | NULL              |                   |
| checksum       | int           | YES  |     | NULL              |                   |
| installed_by   | varchar(100)  | NO   |     | NULL              |                   |
| installed_on   | timestamp     | NO   |     | CURRENT_TIMESTAMP | DEFAULT_GENERATED |
| execution_time | int           | NO   |     | NULL              |                   |
| success        | tinyint(1)    | NO   | MUL | NULL              |                   |
+----------------+---------------+------+-----+-------------------+-------------------+
10 rows in set (0.00 sec)


```

- Now, let's check the table `flyway_schema_history` then you can see one record is saved.
```sql

mysql> select * from flyway_schema_history;
+----------------+--------------------+-------------------+------+-------------------------------------------------+------------+--------------+---------------------+----------------+---------+
| installed_rank | version            | description       | type | script                                          | checksum   | installed_by | installed_on        | execution_time | success |
+----------------+--------------------+-------------------+------+-------------------------------------------------+------------+--------------+---------------------+----------------+---------+
|              1 | 1.0.20220426223800 | Initial Table     | SQL  | V1.0/V1.0_20220426223800__Initial_Table.sql     | 1800508254 | root         | 2022-04-30 14:45:16 |             56 |       1 |
+----------------+--------------------+---------------+------+----------------------------------------+------------+--------------+---------------------+----------------+---------+
1 row in set (0.00 sec)

```

- In which:
	-  `version` is `1.0.20220426223800`, 
	-  `description` is `Initial Table`,
	-  `checksum` is `1800508254`

### Add New Migration Version
- Now, let's create another migration version like 1.1 and because in the software development we want to extend the current table with two more column `createdDate` and `updatedDate` into our table.
- So we will set the new migration file with name as below.

```text

V1.1_20220430223800__Add_New_2_Columns.sql

```

- In which:
	-  `V` is the prefix which used for `Versioned Migration`.
	- `1.1_20220430223800` is the new version with timestamp.
	- `__` is the separator.
	- `Add_New_2_Columns` is the description.
	- `.sql` is the suffix.

- Then let's add the SQL scripts below to add more two column into the table.

```sql

ALTER TABLE `customers` ADD `created_date` TIMESTAMP;  
ALTER TABLE `customers` ADD `updated_date` TIMESTAMP;

```

### Testing 2
- Now, restart your spring boot service again, then check the `customers` and `flyway_schema_history`.

```sql

mysql> describe customers;
+--------------+--------------+------+-----+---------+-------+
| Field        | Type         | Null | Key | Default | Extra |
+--------------+--------------+------+-----+---------+-------+
| id           | varchar(255) | NO   | PRI | NULL    |       |
| address      | varchar(255) | YES  |     | NULL    |       |
| dob          | datetime(6)  | YES  |     | NULL    |       |
| email        | varchar(255) | YES  |     | NULL    |       |
| fullName     | varchar(255) | YES  |     | NULL    |       |
| phone        | varchar(255) | YES  |     | NULL    |       |
| created_date | timestamp    | YES  |     | NULL    |       |
| updated_date | timestamp    | YES  |     | NULL    |       |
| full_name    | varchar(255) | YES  |     | NULL    |       |
+--------------+--------------+------+-----+---------+-------+
9 rows in set (0.01 sec)

```

```sql

mysql> select * from flyway_schema_history;
+----------------+--------------------+-------------------+------+-------------------------------------------------+------------+--------------+---------------------+----------------+---------+
| installed_rank | version            | description       | type | script                                          | checksum   | installed_by | installed_on        | execution_time | success |
+----------------+--------------------+-------------------+------+-------------------------------------------------+------------+--------------+---------------------+----------------+---------+
|              1 | 1.0.20220426223800 | Initial Table     | SQL  | V1.0/V1.0_20220426223800__Initial_Table.sql     | 1800508254 | root         | 2022-04-30 14:45:16 |             56 |       1 |
|              2 | 1.1.20220430223800 | Add New 2 Columns | SQL  | V1.1/V1.1_20220430223800__Add_New_2_Columns.sql |  222139554 | root         | 2022-04-30 14:45:16 |             68 |       1 |
+----------------+--------------------+-------------------+------+-------------------------------------------------+------------+--------------+---------------------+----------------+---------+
2 rows in set (0.00 sec)


```

- As you can see, new two columns `created_date` and `updated_date` have been added into the `customers` table. Then you also see the new record in `flyway_schema_history` has been added:
- In which:
	-  `version` is `1.1.20220430223800`, 
	-  `description` is `Add New 2 Columns`,
	-  `checksum` is `222139554`

## See Also
- [[Database Migrations with Flyway]]
- [[Flyway Versioned Migrations]]
- [[Flyway SQL-based Migrations]]

## References
- [Full Source Code](https://github.com/minhducnguyen189/com.springboot.data/tree/master/flyway-app)