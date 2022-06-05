---

tags: ["Spring", "SpringBoot"]

---

# SpringBoot AutoConfigurator Introduction
## What Is The SpringBoot AutoConfigurator?
- To develop a Spring-based application requires a lot of configuration (Either XM configuration of Annotation Configuration). The solution to this problem is Spring Boot AutoConfigurator. The main responsibility of Spring Boot Autoconfigurator is to reduce the Spring Configuration. If we develop spring applications in Spring Boot, then we don't need to define single XML configuration and almost no or minimal annotation configuration. Spring Boot Autoconfigurator component will take care of providing these information.
- If we use `@SpringBootApplication` annotation at class level, then Spring Boot Autoconfigurator will add automatically all required annotations to Java Class ByteCode.

> @SpringBootApplication = @Configuration + @ComponentScan + @EnableAutoConfiguration.
	
- In simple words, `Spring Boot Starter` reduces build's dependencies and `Spring Boot AutoConfigurator` reduces the Spring Configuration.

## References
- [Journal Dev](https://www.journaldev.com/7969/spring-boot-tutorial)