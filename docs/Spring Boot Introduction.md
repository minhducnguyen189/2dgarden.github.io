---

tags: ["Spring", "SpringBoot"]

---

# SpringBoot Introduction

> `Spring Boot` is a framework from "**The Spring Team**" to ease the bootstrapping and development of new Spring applications. It provides default for code and annotation configuration to quick start new Spring projects within no time.
> It follows "**Opinionated Defaults Configuration**" approach to avoid lots of boilerplate code and configuration to improve development, UnitTest and intergration test process.

```

Springboot = SpringFramework + EmbeddedHttp servers (Tomcat, Jetty) - xml<bean> 

```

Configuration or @Configuration.
- [More information](https://www.journaldev.com/7969/spring-boot-tutorial).

## SpringBoot Features
-   Create stand-alone Spring applications.
-   Embed Tomcat, Jetty or Undertow directly (no need to deploy WAR files).
-   Provide opinionated 'starter' dependencies to simplify your build configuration.
-   Automatically configure Spring and 3rd party libraries whenever possible.
-   Provide production-ready features such as metrics, health checks, and externalized configuration.
-   Absolutely no code generation and no requirement for XML configuration.

## Key Components Of SpringBoot Framework
- There are 4 major components
![[springbootcomponents.png]]

- [[Spring Boot Starter]]
- [[Spring Boot AutoConfigurator]]
- [[Spring Boot CLI]]
- [[Spring Boot Actuator]]

## @SpringBootApplication And SpringApplication Class
- In Spring Boot project, we usually see a main class which uses `@SpringBootApplication` and `SpringApplication class` as below

```java
	package com.exception.handler.demo;
	import org.springframework.boot.SpringApplication;
	import org.springframework.boot.autoconfigure.SpringBootApplication;

	@SpringBootApplication
	public class Application {
		public static void main(String[] args) {
			SpringApplication.run(Application.class, args);
		}
	}
	
```

- So as we learned above `@SpringBootApplication` annotation is used to mark a configuration class that declares one or more @Bean methods and also triggers auto-configuration and component scanning. It's same as declaring a class with `@Configuration`, `@EnableAutoConfiguration` and `@ComponentScan` annotations.
- `SpringApplication` class is used to bootstrap and launch a spring application from a Java main method. This class automatically create the `ApplicationContext` from the classpath, scan the configuration classes and launch the application. This class is very helpful in launching Spring MVC or Spring REST application using Spring Boot.

## See Also
- [[Spring Boot With Swagger]]
- [[Spring Boot With OpenApi]]
- [[Spring Boot With @ConfigurationProperties]]
- [[Database Configuration In SpringBoot]]
- [[Spring Boot With Exception Handler And Message Source]]
- [[Spring Boot With Mustache]]

## References
- [Spring IO](https://spring.io/projects/spring-boot)
- [Journal Dev](https://www.journaldev.com/7969/spring-boot-tutorial)