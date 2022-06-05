---

tags: ["Spring", "SpringData"]

---

# Application Managed Persistence Context Introduction

## What is the Application Managed Persistence Context Introduction?
- The `Application Managed Persistence Context` is managed by the application (JSE): The application is responsible for `Persistence Context` creation and disposal. The application is also required to ensure that the application created `Persistence Context` is aware of any eventual ongoing [[Transaction]]. An `Application Managed Persistence Context scope` is always `Extended persistence scope`.
-  For the `Application Managed Persistence Context`, developers have to create each time the [[EntityManager]] from the `EntityManagerFactory`. They have more control over the flow, but also more responsibilities (e.g. they have to remember to close the `EntityManager`, they have to explicitly call commit and rollback operations).
-  	[You can find more here](https://www.byteslounge.com/tutorials/container-vs-application-managed-entitymanager)
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