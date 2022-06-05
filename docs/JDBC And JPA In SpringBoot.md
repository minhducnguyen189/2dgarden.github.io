---

tags: ["Spring", "SpringData"]

---

# JDBC And JPA In SpringBoot

## JDBC And JPA In SpringBoot Projects
- In [[Spring Boot Introduction | SpringBoot]] projects, we usually use dependency libraries `spring-boot-starter-jdbc` for `JDBC` and `spring-boot-starter-data-jpa` for `JPA`. We should note that these SpringBoot dependencies will wrap many others libraries, `JPA core` and `JDBC core` are just a part of them.
- For this reason, If you use the `spring-jdbc` on SpringFramework project, you will not see the dependency `HikariCP` and you have to import this dependency manually. For `SpringBoot projects` you just need to import only one dependency `spring-boot-starter-jdbc` then you will also have `HikariCP`. Likewise, in dependency `spring-boot-starter-data-jpa` for SpringBoot projects, It will contains these 3 main dependencies:

```text

| + spring-boot-starter-jdbc
| \- HikariCP
|  spring-data-jpa
\  hibernate-core

other dependencies.

```
- See the dependencies tree of `spring-boot-starter-data-jpa` as below:

```

+- org.springframework.boot:spring-boot-starter-data-jpa:jar:2.4.4:compile
|  +- org.springframework.boot:spring-boot-starter-aop:jar:2.4.4:compile
|  |  +- org.springframework:spring-aop:jar:5.3.5:compile
|  |  \- org.aspectj:aspectjweaver:jar:1.9.6:compile
|  +- org.springframework.boot:spring-boot-starter-jdbc:jar:2.4.4:compile
|  |  +- com.zaxxer:HikariCP:jar:3.4.5:compile
|  |  \- org.springframework:spring-jdbc:jar:5.3.5:compile
|  +- jakarta.transaction:jakarta.transaction-api:jar:1.3.3:compile
|  +- jakarta.persistence:jakarta.persistence-api:jar:2.2.3:compile
|  +- org.hibernate:hibernate-core:jar:5.4.29.Final:compile
|  |  +- org.jboss.logging:jboss-logging:jar:3.4.1.Final:compile
|  |  +- org.javassist:javassist:jar:3.27.0-GA:compile
|  |  +- net.bytebuddy:byte-buddy:jar:1.10.21:compile
|  |  +- antlr:antlr:jar:2.7.7:compile
|  |  +- org.jboss:jandex:jar:2.2.3.Final:compile
|  |  +- com.fasterxml:classmate:jar:1.5.1:compile
|  |  +- org.dom4j:dom4j:jar:2.1.3:compile
|  |  +- org.hibernate.common:hibernate-commons-annotations:jar:5.1.2.Final:compile
|  |  \- org.glassfish.jaxb:jaxb-runtime:jar:2.3.1:compile
|  |     +- org.glassfish.jaxb:txw2:jar:2.3.1:compile
|  |     +- com.sun.istack:istack-commons-runtime:jar:3.0.7:compile
|  |     +- org.jvnet.staxex:stax-ex:jar:1.8:compile
|  |     \- com.sun.xml.fastinfoset:FastInfoset:jar:1.2.15:compile
|  +- org.springframework.data:spring-data-jpa:jar:2.4.6:compile
|  |  +- org.springframework.data:spring-data-commons:jar:2.4.6:compile
|  |  +- org.springframework:spring-orm:jar:5.3.5:compile
|  |  +- org.springframework:spring-context:jar:5.3.5:compile
|  |  +- org.springframework:spring-tx:jar:5.3.5:compile
|  |  +- org.springframework:spring-beans:jar:5.3.5:compile
|  |  +- org.springframework:spring-core:jar:5.3.5:compile
|  |  |  \- org.springframework:spring-jcl:jar:5.3.5:compile
|  |  \- org.slf4j:slf4j-api:jar:1.7.26:compile
|  \- org.springframework:spring-aspects:jar:5.3.5:compile

```

## See Also
- [[HikariCP]]
- [[Spring Boot Introduction]]
