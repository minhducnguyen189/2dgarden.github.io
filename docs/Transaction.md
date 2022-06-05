---

tags: ["Spring", "SpringData"]

---

# Transaction Introduction
## What Is The Transaction?
- A `transaction` is a set of operations that either fail or succeed as a unit. `Transactions` are a fundamental part of persistence. A database `transaction` consists of a set of SQL DML (Data Manipulation Language) operations that are committed or rolled back as a single unit. An object level `transaction` is one in which a set of changes made to a set of objects are committed to the database as a single unit.

- [[Spring Data JPA | JPA]] provides two mechanisms for `transactions`. When used in Java EE JPA provides integration with JTA (Java Transaction API). JPA also provides its own EntityTransaction implementation to Java SE and for use in a non-managed mode in Java EE. `Transactions` in JPA are always at the object level, this means that all changes made to all persistent objects in the persistence context are part of the transaction.

- [More information](https://en.wikibooks.org/wiki/Java_Persistence/Transactions)

## See Also
- [[Spring Data JPA]]

## References
- [Wikibooks](https://en.wikibooks.org/wiki/Java_Persistence/Transactions)