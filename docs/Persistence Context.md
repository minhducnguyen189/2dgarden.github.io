---

tags: ["Spring", "SpringData"]

---

# Persistence Context Introduction
## What Is The Persistence Context
- `Persistence context`: The `persistence context` defines the set of active instances that the application is handling. The `persistence context` can be created manually or through injection.
	- The `Persistence Context` is responsible for JPA entity management: When an application loads an [[Entity]] from the database, the `entity` is in fact stored in the `Persistence Context`, so the `entity` becomes managed by the `Persistence Context`. Any further change made over that same `entity` will be monitored by the `Persistence Context`.
	- The `Persistence Context` will also flush changed `entities` to the database when appropriate. When a transaction commits, the associated `Persistence Context` will also flush any eventual pending changes to the Database.
	- We can understand like the `persistence context` is the first-level cache where all the `entities` are fetched from the database or saved to the database.

## Persistence Context Types
-  `Persistence Context` have two types:
	- [[Container Managed Persistence Context]]
	- [[Application Managed Persistence Context]]

## See Also
- [[Entity]]
- [[Container Managed Persistence Context]]
- [[Application Managed Persistence Context]]