---

tags: ["Spring", "SpringBoot"]

---

# SpringBoot Starter Introduction
## What Is The SpringBoot Starter?
- `Spring boot starters` is one of the major key features or components of **Spring Boot Framework**. The main responsibility of Spring boot stater is to combine a group of common or related dependencies into single dependencies.
- Major advantanges of `Spring boot Stater`:
- `Spring boot stater` reduces defining many dependencies simplify project build dependencies.
- `Spring boot stater` simplifies project build dependencies.
- Ex: To develop a spring WebApplication with Tomcat webserver, we need to add some dependencies and below into Maven's `pom.xml` file.
	- Spring core jar file.
	- Spring web jar file.
	- Spring web MVC jar file.
	- Servlet jar file.
- So, if we add "**spring-boot-stater-web**" jar file dependency to our build file, then spring boot framework will **automatically download all required jars** and add to our project classpath.
- As you can see in the image below, `Spring Boot Stater` has a dependency on `Spring Boot AutoConfigurator`, so the `Spring Boot Stater` will triggers `Spring Boot AutiConfigurator` automatically.

![[spring-boot-starter-dependencies.png]]

## References
- [Journal Dev](https://www.journaldev.com/7969/spring-boot-tutorial)