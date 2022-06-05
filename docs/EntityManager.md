---

tags: ["Spring", "SpringData"]

---

# EntityManager Introduction
## What Is The EntityManager?
-`EntityManager`: The resource manager that maintains the active collection of [[Entity]] objects that are being used by the application. The `EntityManager` handles the database interaction and metadata for `object-relational mappings (ORM)` . An instance of an `EntityManager` represents a [[Persistence Context]]. 
	- An `application in a container` can obtain the `EntityManage` through injection into the application or by looking it up in the Java component name-space. 
	- If the application manages its persistence, the `EntityManager` is obtained from the `EntityManagerFactory` .
- In JPA, the `EntityManager` interface is used to allow applications to manage and search for entities in the relational database.
	- The `EntityManager` is an API that manages the life-cycle of [[Entity]] instances. An `EntityManager` object manages a set of entities that are defined by a [[Persistence Unit]]. Each `EntityManager` instance is associated with a `persistence context`. A `persistence context` defines the scope under which particular entity instances are created, persisted, and removed through the APIs made available by `EntityManager`. In some ways, a `persistence context` is conceptually similar to a transaction context.
	- The `EntityManager` tracks all [[Entity]] objects within a` persistence context` for changes and updates that are made, and flushes these changes to the database. Once a `persistence context` is closed, all managed entity object instances become detached from the `persistence context` and its associated `entity manager`, and are no longer managed. Once an object is detached from a `persistence context`, it can no longer be managed by an `entity manager`, and any state changes to this object instance will not be synchronized with the database.
	- There's always a new `Persistence Context` if there's a new `EntityManager`.
- [You can view more here](https://www.ibm.com/docs/en/wasdtfe?topic=architecture-entity-manager)

## See Also
- [[Entity]]
- [[Persistence Unit]]
- [[Persistence Context]]

## References
- [IBM Doc](https://www.ibm.com/docs/en/wasdtfe?topic=architecture-entity-manager)