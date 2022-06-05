---

tags: ["Spring", "SpringData"]

---

# Spring Data Introduction
## What Is The Spring Data?
- `Spring Data’s mission` is to provide a familiar and consistent, Spring-based programming model for data access while still retaining the special traits of the underlying data store.
- It makes it easy to use data access technologies, relational and non-relational databases, map-reduce frameworks, and cloud-based data services. This is an umbrella project which contains many subprojects that are specific to a given database. The projects are developed by working together with many of the companies and developers that are behind these exciting technologies.

## Features
-   Powerful repository and custom object-mapping abstractions.
-   Dynamic query derivation from repository method names.
-   Implementation domain base classes providing basic properties.
-   Support for transparent auditing (created, last changed).
-   Possibility to integrate custom repository code.
-   Easy Spring integration via JavaConfig and custom XML namespaces.
-   Advanced integration with Spring MVC controllers.
-   Experimental support for cross-store persistence.

## Main Modules
### Spring Data JDBC
- [[Spring Data JDBC]]
	- JDBC In SpringBoot
	- [[JDBC And JPA In SpringBoot]]
		- [[HikariCP]]

### Spring Dada JPA
- [[Spring Data JPA]]
	- JPA Core
		- [[Persistence Unit]]
		- [[EntityManagerFactory]]
		- [[Persistence Context]]
				- [[Container Managed Persistence Context]]
				- [[Application Managed Persistence Context]]
		- [[EntityManager]]
		- [[Entity]]
 	- JPA In SpringBoot
		- [[JDBC And JPA In SpringBoot]]
		- [[Object Relational Mapping]]
			- [[Hibernate]]
		- [[Open Session In View Of JPA]]
			- [[Transaction]]
		- [[Database Configuration In SpringBoot]]
		- [[JPA With Pagination]]
		- [[JPA With Multi Datasources]]
		- [[JPA Native Query With Optional Params]]
		- [[JPA Entity Lifecycle Events]]
	- Auditing
		- [[Auditing With Hibernate Envers]]

### Database Migration
- Database Migration
	- [[Database Migrations with Flyway]]
		- [[Flyway Migrations]]
			- [[Flyway Versioned Migrations]]
				- [[Flyway Regular Versioned Migration Example]]
			- [[Flyway Repeatable Migrations]]
		- [[Flyway SQL-based Migrations]]

## References
- [Spring IO](https://spring.io/projects/spring-data)
