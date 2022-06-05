---

tags: ["Spring", "SpringData"]

---

# HikariCP Introduction
## WHAT IS THE HIKARICP?
- `HikariCP` is solid high-performance [[Spring Data JDBC | JDBC]] connection pool. A connection pool is a cache of database connections maintained so that the connections can be reused when future requests to the database are required. Connection pools may significantly reduce the overall resource usage. [You can find more here](https://zetcode.com/articles/hikaricp/).
- `HikariCP` is a very lightweight and high performance compared with other connection pooling frameworks. So It is the reason why `HikariCP` become the default pool implementation in Spring Boot 2.0.
- One more thing, `HikariCP` has some default configurations and configure `HikariCP` is also simple, so It will not take you many times to work with. [You can find more here](https://github.com/brettwooldridge/HikariCP).

## See Also
- [[Spring Data JDBC]]

## References
- [ZetCode](https://zetcode.com/articles/hikaricp/).
- [GitHub HikariCp](https://github.com/brettwooldridge/HikariCP).