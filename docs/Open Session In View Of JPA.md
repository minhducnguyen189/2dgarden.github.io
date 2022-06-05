---

tags: ["Spring", "SpringData"]

---

# Open Session In View Of JPA
## What Is The Open Session In View Of JPA
- Session per request is a transactional pattern to tie the persistence session and request life-cycles together. Not surprisingly, Spring comes with its own implementation of this pattern, named OpenSessionInViewInterceptor, to facilitate working with lazy associations and therefore, improving developer productivity.
- By default In [[Spring Boot Introduction | SpringBoot]] Service, JPA use OSIV (Open session in view) parttern with `open-in-view=true` configuration which allow a session will be created when the a HTTP request come in the `SpringBoot` service and this session will be closed until the HTTP request has been end. This session is bound into the TransactionSynchronizationManager. So It means that there is a [[Transaction]] that will be opened from from the beginning to the end of the HTTP request. So that's the reason why although you put a lot of queries and do update to many tables in Database or get child entities from parent entities you just can see in the log just one `JDBC` connection is used (physical database connection) with many SQL statements. So, if your service is small and you don't call any request to another system, just work with your DB so it is okay for you, you can manipulate with data in DB anywhere in your service methods. But if you have to call to another system, so using this way is not too good, because the `transaction` and database connection will be hold for a long time and can make the connection pool become full if there are may request at the same time, you can see this issue happen when you run your springboot service on production.
- If we set `open-in-view=false`, then be careful when you use Lazy loading because now, every executed query will be made in a `transaction` and connection privately, you can image that if there are 3 queries in your service method, so every time the query is executed, then a `transaction` and connection will be created and executed into the database and closed, then 3 queries you will have 3 times to make connections to DB. So if you use lazy load, you get parent from the first query, then you get childs from parent the LazyInitializationException will be through because the `transaction` of getting parent has been closed. So using this way is better when your service is interacting with many systems, the DB connections in pool will not be hold for a long time and we can improve our service performance on production when we received many connections because connections are opened and closed instantly.

## See Also
- [[Spring Data JPA]]
- [[Transaction]]

## References
- [You can find more here](https://stackoverflow.com/questions/30549489/what-is-this-spring-jpa-open-in-view-true-property-in-spring-boot)
- [You can find more here](https://www.baeldung.com/spring-open-session-in-view#choose-wisely)