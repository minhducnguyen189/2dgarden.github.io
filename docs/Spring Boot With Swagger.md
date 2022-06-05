---

tags: ["Spring", "SpringBoot"]

---

# SpringBoot With Swagger

> In this post, we will learn about swagger generator to generate Apis and swagger UI in springboot service.

## What Is The Swagger?
- `Swagger` allows you to `describe the structure of your APIs so that machines can read them`. The ability of APIs to describe their own structure is the root of all awesomeness in Swagger. Why is it so great? Well, by reading your API’s structure, we can automatically build beautiful and interactive API documentation. We can also automatically generate client libraries for your API in many languages and explore other possibilities like automated testing. Swagger does this by asking your API to return a YAML or JSON that contains a detailed description of your entire API. This file is essentially a resource listing of your API which adheres to OpenAPI Specification.
- [More Information](https://swagger.io/docs/specification/2-0/what-is-swagger/)

## Depdencies And Plugins
- You need to import some dependencies and plugins below into `pom.xml` of your spring boot project

```xml

...

<!--springfox-swagger2 -->  
<dependency>  
    <groupId>io.springfox</groupId>  
    <artifactId>springfox-swagger2</artifactId>  
    <version>2.9.2</version>  
</dependency>  
  
<!--springfox-swagger-ui -->  
<dependency>  
    <groupId>io.springfox</groupId>  
    <artifactId>springfox-swagger-ui</artifactId>  
    <version>2.9.2</version>  
</dependency>  
  
<dependency>  
    <groupId>io.swagger.core.v3</groupId>  
    <artifactId>swagger-annotations</artifactId>  
    <version>2.1.13</version>  
</dependency>

...


```

```xml

<plugin>
		<groupId>org.codehaus.mojo</groupId>
		<artifactId>build-helper-maven-plugin</artifactId>
		<version>3.3.0</version>
		<executions>
				<execution>
						<id>add-source</id>
						<phase>generate-sources</phase>
						<goals>
								<goal>add-source</goal>
						</goals>
						<configuration>
								<sources>
										<source>${basedir}/target/generated-sources/src/main/java</source>
								</sources>
						</configuration>
				</execution>
		</executions>
</plugin>
<plugin>
		<groupId>io.swagger</groupId>
		<artifactId>swagger-codegen-maven-plugin</artifactId>
		<version>2.4.27</version>
		<executions>
				<execution>
						<id>swagger-code-generate</id>
						<goals>
								<goal>generate</goal>
						</goals>
						<configuration>
								<inputSpec>${project.basedir}/src/main/resources/swagger/swagger-input.yml
								</inputSpec>
								<language>spring</language>
								<configurationFile>
										${project.basedir}/src/main/resources/swagger/service-config.json
								</configurationFile>
								<output>${project.build.directory}</output>
<!--                            <templateDirectory>src/main/resources/swagger/templates</templateDirectory>-->
								<configOptions>
										<dateLibrary>java8</dateLibrary>
										<java8>true</java8>
								</configOptions>
						</configuration>
				</execution>
		</executions>

</plugin>


```

## Swagger Implementation And Configuration
- Now let create swagger package in the `resources` folder and create `swagger-input.yml` with your api definitions. You can use [swagger editor](https://editor.swagger.io/) to write your api definitions easily. The example swagger yml will look like below.

![[spring-boot-swagger-resources.jpg]]

```yml

"swagger": "2.0"
info:
  title: "Swagger Openapi Server"
  description: "This is the Openapi Specification For Feign Server"
  license:
    name: "Apache 2.0"
    url: "http://www.apache.org/licenses/LICENSE-2.0.html"
  version: "1.0.0"
tags:
  - name: "server"
    description: "all server apis"
paths:
  /v1/server/customers:
    post:
      tags:
        - "server"
      summary: "Create a customer"
      description: "create a customer"
      operationId: "createCustomer"
      parameters:
        - in: body
          name: "customerRequest"
          description: "request body"
          required: true
          schema:
            $ref: "#/definitions/CustomerRequest"
      responses:
        "201":
          description: "successful operation"
          schema:
            type: "string"
            format: "uuid"
    get:
      tags:
        - "server"
      summary: "get customers"
      description: "get customers"
      operationId: "getCustomers"
      responses:
        200:
          description: "successful operation"
          schema:
            type: "array"
            items:
              $ref: "#/definitions/Customer"

definitions:
  CustomerRequest:
    type: "object"
    properties:
      fullName:
        type: "string"
        example: "Nguyen Minh Duc"
      email:
        type: "string"
        format: "email"
        example: "ducnguyen@gmail.com"
      address:
        type: "string"
        example: "3/115 Binh Duong"
      phone:
        type: "string"
        example: "0999123445"
      gender:
        type: "string"
        enum:
          - "M"
          - "F"
      dob:
        type: "string"
        format: "date"
  Customer:
    type: "object"
    properties:
      id:
        type: "string"
        format: "uuid"
      fullName:
        type: "string"
      email:
        type: "string"
        format: "email"
      address:
        type: "string"
      phone:
        type: "string"
      gender:
        type: "string"
        enum:
          - "M"
          - "F"
      dob:
        type: "string"
        format: "date"
      createdAt:
        type: "string"
        format: "date-time"
      updatedAt:
        type: "string"
        format: "date-time"

```

- Next, you need to create a file `service-config.json` with some configuration as below

```json

#service-config.json

{  
  "artifactId": "swagger",  
  "basePackage": "com.springboot.project.swagger.app",  
  "apiPackage": "com.springboot.project.swagger.app.api",  
  "configPackage": "com.springboot.project.swagger.app.config",  
  "modelPackage": "com.springboot.project.swagger.app.model",  
  "delegatePattern": "true",  
  "hideGenerationTimestamp": "true",  
  "useBeanValidation": "true",  
  "dateLibrary": "java8",  
  "sourceFolder": "generated-sources/src/main/java",  
  "interfaceOnly": true  
}

```

- Then to enable Swagger UI, let's create a `SwaggerConfig` class as below:

```java

package com.springboot.project.swagger.app.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

@Configuration
@EnableSwagger2
public class SwaggerConfig {

    @Bean
    public Docket docketConfiguration() {
        return new Docket(DocumentationType.SWAGGER_2)
                .select()
                .apis(RequestHandlerSelectors.any())
                .paths(PathSelectors.any())
                .build();
    }
}

```

- In which, with the `PathSelectors.any()` configuration, all the controllers will be scanned by Swagger and they will be generated on the UI. Let's go to the testing section to see the result.

## Testing
- Now, you will use command `mvn clean package` to build your project with swagger then you will see the generated source as in the image below
![[spring-boot-swagger-generated-srouce.jpg]]
- Now, let create a `ServerController` component and implement `V1Api` from generated source, all your apis was generated with validations following your swagger specification, so you just need implement the generated api for using.

```java

package com.springboot.project.swagger.app.controller;

import com.springboot.project.swagger.app.api.V1Api;
import com.springboot.project.swagger.app.model.Customer;
import com.springboot.project.swagger.app.model.CustomerRequest;
import com.springboot.project.swagger.app.service.CustomerService;
import lombok.AllArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@AllArgsConstructor(onConstructor = @__(@Autowired))
public class ServerController implements V1Api {


    private final CustomerService customerService;


    @Override
    public ResponseEntity<UUID> createCustomer(CustomerRequest customerRequest) {
        return new ResponseEntity<>(this.customerService.createCustomer(customerRequest), HttpStatus.CREATED);
    }

    @Override
    public ResponseEntity<List<Customer>> getCustomers() {
        return new ResponseEntity<>(this.customerService.getCustomers(), HttpStatus.OK);
    }

}

```

- You can see full [source code here](https://github.com/minhducnguyen189/com.springboot.project/tree/master/swagger-app) which includes samples for, `Repository` `Entity` and  `Service`. Because we just focus on Swagger Generator so we will not put these implementation details here.
- Now let's start your Spring Boot service and go to `http://localhost:8080/swagger-ui.html` to check the Swagger UI.
![[spring-boot-swagger-ui.jpg]]

- You can also execute api on the swagger ui directly instead of using postman to execute apis.
![[spring-boot-swagger-ui-test.png]]

## Advances
- Sometimes you can not control the generated classes as main class `Swagger2SpringBoot` or models `pojo` classes. So, there is a way which will help you to do that. Let's create a `templates` package in your `resources` directory. Then add your configuration `mustaches` file there. Note the name of mustaches files have to be the same as in [this repository](https://github.com/swagger-api/swagger-codegen/tree/master/modules/swagger-codegen/src/main/resources/JavaSpring).
- Your plugin will look like below.

```xml

<plugin>
		<groupId>org.codehaus.mojo</groupId>
		<artifactId>build-helper-maven-plugin</artifactId>
		<version>3.3.0</version>
		<executions>
				<execution>
						<id>add-source</id>
						<phase>generate-sources</phase>
						<goals>
								<goal>add-source</goal>
						</goals>
						<configuration>
								<sources>
										<source>${basedir}/target/generated-sources/src/main/java</source>
								</sources>
						</configuration>
				</execution>
		</executions>
</plugin>
<plugin>
		<groupId>io.swagger</groupId>
		<artifactId>swagger-codegen-maven-plugin</artifactId>
		<version>2.4.27</version>
		<executions>
				<execution>
						<id>swagger-code-generate</id>
						<goals>
								<goal>generate</goal>
						</goals>
						<configuration>
								<inputSpec>${project.basedir}/src/main/resources/swagger/swagger-input.yml
								</inputSpec>
								<language>spring</language>
								<configurationFile>
										${project.basedir}/src/main/resources/swagger/service-config.json
								</configurationFile>
								<output>${project.build.directory}</output>
								<templateDirectory>src/main/resources/swagger/templates</templateDirectory>
								<configOptions>
										<dateLibrary>java8</dateLibrary>
										<java8>true</java8>
								</configOptions>
						</configuration>
				</execution>
		</executions>
</plugin>


```

- You can copy the content of the mustaches files as in the repo above and edit the content as the way you want.
- For example, I want to add `@JsonIgnoreProperties` into every generated models. So I can do it as the image below.
![[spring-boot-swagger-pojo-template.jpg]]
- Then build your project again and check your generated models, you can see the annotation as below
![[spring-boot-swagger-mustache-pojo.jpg]]

## References
- [Swagger IO](https://swagger.io/docs/specification/2-0/what-is-swagger/)
- [Full source code here](https://github.com/minhducnguyen189/todos-application-adapter)