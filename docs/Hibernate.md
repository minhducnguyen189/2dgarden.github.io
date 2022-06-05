---

tags: ["Spring", "SpringData"]

---

# Hibernate Introduction
## What Is The Hibernate?
- `Hibernate` is an open-source, non-invasive, light-weight java ORM(Object-relational mapping) framework to develop objects which are independent of the database software and make independent persistence logic in all JAVA, JEE. It simplifies the interaction of java applications with databases. Hibernate is an implementation of JPA(Java Persistence API).
- `Hibernate` maps Java classes to database tables and from **Java data types** to **SQL data types** and relieves the developer from 95% of common data persistence related programming tasks.
- `Hibernate` sits between traditional Java objects and database server to handle all the works in persisting those objects based on the appropriate O/R mechanisms and patterns.
![[orm-example.png]]
- There is an important thing to remember that "internally", `Hibernate` uses `JDBC` to interact with the database.
- [More information](https://dzone.com/articles/what-is-the-difference-between-hibernate-and-sprin-1)

## Some Differences Between JDBC And Hibernate
- Because `Hibernate` is used as an implementation of JPA, so we will compare some differences between [[Spring Data JDBC| JDBC]] and `Hibernate` as below.

| NO | JDBC | HIBERNATE |
| ------ | -------- | -------- |
| 1. | In `JDBC`, one needs to **write code to map** the object model’s data representation to the schema of the relational model. | `Hibernate` maps the object model’s data to the schema of the database itself **with the help of annotations**. |
| 2. | `JDBC` enables developers to create queries and update data to a relational database `using the Structured Query Language (SQL)`. | `Hibernate` `uses HQL (Hibernate Query Language)` which is similar to SQL but understands object-oriented concepts like inheritance, association etc. |
| 3. | `JDBC` code needs to be written in a try catch block as it throws checked exception(SQLexception). | Whereas `Hibernate` manages the exceptions itself by marking them as unchecked. |
| 4. | `JDBC` is database dependent i.e. one needs to write different codes for different database. | Whereas `Hibernate` is database independent and same code can work for many databases with minor changes. |
| 5. | Creating associations between relations is quite **hard** in `JDBC`. | Associations like one-to-one, one-to-many, many-to-one, and many-to-many can be acquired **easily** with the help of annotations. |

- [View more](https://www.geeksforgeeks.org/difference-between-jdbc-and-hibernate-in-java/)

## See Also
- [[Spring Data JDBC]]

## References
- [DZone](https://dzone.com/articles/what-is-the-difference-between-hibernate-and-sprin-1)
