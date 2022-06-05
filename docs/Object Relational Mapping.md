---

tags: ["Spring", "SpringData"]

---

# Object Relational Mapping Introduction
## What is the Object Relation Mapping (ORM)?
 - `Object-Relational Mapping (ORM)` is a programming technique for converting data between relational databases and object oriented programming languages such as Java, C#, etc.
- An `ORM` system has the following advantages over plain [[Spring Data JDBC | JDBC]].

| No. |	Advantages |
| --- | --- |
| 1 | Let’s business code access objects rather than DB tables. |
| 2 | Hides details of SQL queries from OO logic. |
| 3 | Based on [[Spring Data JDBC | JDBC]] |
| 4 | No need to deal with the database implementation. |
| 5 | Entities based on business concepts rather than database structure. |
| 6 | Transaction management and automatic key generation. |
| 7 | Fast development of application. |

An `ORM` solution consists of the following four entities

| No. |	Solutions |
| --- | --- |
| 1 | An API to perform basic CRUD operations on objects of persistent classes. |
| 2 | A language or API to specify queries that refer to classes and properties of classes. |
| 3 | A configurable facility for specifying mapping metadata. |
| 4 | A technique to interact with transactional objects to perform dirty checking, lazy association fetching, and other optimization functions. |

- There are several persistent frameworks and ORM options in Java. A persistent framework is an ORM service that stores and retrieves objects into a relational database.
    - TopLink
    - [[Hibernate]]
    - And many more
- We will mainly focus on `Hibernate` because it is the most popular one.

## See Also
- [[Hibernate]]
- [[Spring Data JDBC]]

## References
- [From Source Information](https://www.tutorialspoint.com/hibernate/orm_overview.htm)