---

tags: ["Spring", "SpringData"]

---

# Persistence Unit Introduction
## What Is The Persistence Unit?
- `Persistence Unit`:  Defines a complete [[Object Relational Mapping | Object-Relational Model mapping (ORM)]] (entities + supporting structures) with a relational database. The [[EntityManagerFactory]] uses this data to create a [[EntityManager]] that is associated with a [[Persistence Context]].
- A` persistence unit` specifies all entities, which are managed by the `EntityManagers` of the application. Each `persistence unit` contains all entities classes representing the data stored in a single database.

## See Also
- [[Object Relational Mapping]]
- [[EntityManagerFactory]]
- [[EntityManager]]
- [[Persistence Context]]