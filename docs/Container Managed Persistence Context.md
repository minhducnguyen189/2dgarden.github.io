---

tags: ["Spring", "SpringData"]

---

# Container Managed Persistence Context Introduction

## What Is The Container Managed Persistence Context?
- The `Container Managed Persistence Context` - as the name states - is managed by the enterprise container (JEE Container or Spring). The container is responsible for `Persistence Context` injection into enterprise components, and is also responsible for its disposal at the end of the current [[Transaction]]. `Container-managed persistence context` might be defined to have one of two different scopes: `Transaction persistence scope` or `Extended persistence scope`.
- The container, before performing an operation on the [[Entity]], checks if there is a `Persistence Context` connected to the `transaction`; if not present, it creates a new `Persistence Context` (session) and connects it. In practice, an [[EntityManager]] is automatically created for each new `transaction`. Operations such as commits and rollbacks are handled automatically by the Container.
- [You can find more here](https://www.byteslounge.com/tutorials/container-vs-application-managed-entitymanager)
- [You can find more here](https://www.vincenzoracca.com/en/blog/framework/jpa/jpa-em/)
- [You can find more here](https://www.ibm.com/docs/en/wasdtfe?topic=applications-jpa-architecture)

## See Also
- [[Entity]]
- [[EntityManager]]
- [[Transaction]]

## References
- [BytesLounge](https://www.byteslounge.com/tutorials/container-vs-application-managed-entitymanager)
- [Vincenzoracca](https://www.vincenzoracca.com/en/blog/framework/jpa/jpa-em/)
- [IBM Doc](https://www.ibm.com/docs/en/wasdtfe?topic=applications-jpa-architecture)