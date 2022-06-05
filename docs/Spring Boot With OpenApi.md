---

tags: ["Spring", "SpringBoot"]

---

# Spring Boot With OpenApi
## What Is The OpenApi?
- The OpenAPI Specification (OAS) defines a standard, language-agnostic interface to RESTful APIs which allows both humans and computers to discover and understand the capabilities of the service without access to source code, documentation, or through network traffic inspection. When properly defined, a consumer can understand and interact with the remote service with a minimal amount of implementation logic.

- An OpenAPI definition can then be used by documentation generation tools to display the API, code generation tools to generate servers and clients in various programming languages, testing tools, and many other use cases.
- [More Information](https://swagger.io/specification/).

## Dependencies And Plugins
- You need to import some dependencies and plugins below into `pom.xml` of your spring boot project

```xml

...

<!--Openapi Generator-->  
<dependency>  
    <groupId>org.openapitools</groupId>  
    <artifactId>openapi-generator</artifactId>  
    <version>5.4.0</version>  
</dependency>  
  
  
<!--Openapi UI with validation-->  
<dependency>  
    <groupId>com.fasterxml.jackson.core</groupId>  
    <artifactId>jackson-core</artifactId>  
    <version>2.13.1</version>  
</dependency>  
  
<dependency>  
    <groupId>com.fasterxml.jackson.core</groupId>  
    <artifactId>jackson-annotations</artifactId>  
    <version>2.13.1</version>  
</dependency>  
  
<dependency>  
    <groupId>org.openapitools</groupId>  
    <artifactId>jackson-databind-nullable</artifactId>  
    <version>0.2.2</version>  
</dependency>  
  
<dependency>  
    <groupId>org.springdoc</groupId>  
    <artifactId>springdoc-openapi-ui</artifactId>  
    <version>1.6.5</version>  
</dependency>

...


```

```xml


   <build>
        <plugins>
            <plugin>
                <groupId>org.openapitools</groupId>
                <artifactId>openapi-generator-maven-plugin</artifactId>
                <version>5.4.0</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                        <configuration>
                            <!-- path to the openapi file spec `.yml` -->
                            <inputSpec>
                                ${project.basedir}/src/main/resources/openapi/openapi-server.yml
                            </inputSpec>
                            <generatorName>spring</generatorName>
                            <!-- generated package for api interface -->
                            <apiPackage>com.springboot.cloud.openfeign.openapi.server.app.api</apiPackage>
                            <!-- generated package for models -->
                            <modelPackage>com.springboot.cloud.openfeign.openapi.server.app.model</modelPackage>
                            <!-- using supportingFilesToGenerate -->
                            <supportingFilesToGenerate>
                                ApiUtil.java
                            </supportingFilesToGenerate>
                            <configOptions>
                                <delegatePattern>true</delegatePattern>
                                <dateLibrary>java8</dateLibrary>
                                <interfaceOnly>true</interfaceOnly>
                                <useBeanValidation>true</useBeanValidation>
                            </configOptions>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
```

## OpenApi Implementation And Configuration
- Now let create swagger package in the `resources` folder and create `swagger-input.yml` with your api definitions. You can use [swagger editor](https://editor.swagger.io/) to write your api definitions easily. The example swagger yml will look like below.

![[spring-boot-openapi-resources.png]]

```yml

openapi: 3.0.1
info:
  title: Swagger Openapi Server
  description: 'This is the Openapi Specification For Feign Server'
  license:
    name: Apache 2.0
    url: http://www.apache.org/licenses/LICENSE-2.0.html
  version: 1.0.0
tags:
- name: server
  description: all server apis
paths:
  /v1/server/customers:
    post:
      tags:
      - server
      summary: Create a customer
      description: create a customer
      operationId: createCustomer
      requestBody:
        description: request body
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CustomerRequest'
        required: true
      responses:
        201:
          description: successful operation
          content:
            application/json:
              schema:
                type: string
                format: uuid
    get:
      tags:
      - server
      summary: get customers
      description: get customers
      operationId: getCustomers
      responses:
        200:
          description: successful operation
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Customer'
components:
  schemas:
    CustomerRequest:
      type: object
      properties:
        fullName:
          type: string
          example: Nguyen Minh Duc
        email:
          type: string
          format: email
          example: ducnguyen@gmail.com
        address:
          type: string
          example: 3/115 Binh Duong
        phone:
          type: string
          example: 0999123445
        gender:
          type: string
          enum: [M, F]
        dob:
          type: string
          format: date
    Customer:
      type: object
      properties:
        id:
          type: string
          format: uuid
        fullName:
          type: string
        email:
          type: string
          format: email
        address:
          type: string
        phone:
          type: string
        gender:
          type: string
          enum: [ M, F ]
        dob:
          type: string
          format: date
        createdAt:
          type: string
          format: date-time
        updatedAt:
          type: string
          format: date-time


```

## Testing
- Now, you will use command `mvn clean package` to build your project with swagger then you will see the generated source as in the image below

![[spring-boot-openapi-generated-source.png]]

- Now, let create a `ServerController` component and implement `V1Api` from generated source, all your apis was generated with validations following your openapi specification, so you just need implement the generated api for using.

```java

package com.springboot.project.openapi.app.controller;

import com.springboot.cloud.openfeign.openapi.server.app.api.V1Api;
import com.springboot.cloud.openfeign.openapi.server.app.model.Customer;
import com.springboot.cloud.openfeign.openapi.server.app.model.CustomerRequest;
import com.springboot.project.openapi.app.service.CustomerService;
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

- You can see full [source code here](https://github.com/minhducnguyen189/com.springboot.project/tree/master/openapi-app) which includes samples for, `Repository` `Entity` and  `Service`. Because we just focus on OpenApi so we will not put these implementation details here.
- Now let's start your Spring Boot service and go to `http://localhost:8080/swagger-ui/index.html` to check the openapi UI.

![[spring-boot-openapi-ui.png]]

- You can also execute api on the openapi ui directly instead of using postman to execute apis.

![[spring-boot-openapi-ui-test.png]]

## Advances
- By default, OpenApi will automatically scan all your controllers in project and generate all UIs for them. However, in some case you want to hide your sensitive apis from OpenApi UI, you can create a configuration class with content as below.

```java

package com.springboot.project.openapi.app.config;

import org.springdoc.core.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {

    @Bean
    public GroupedOpenApi groupedOpenApiConfiguration() {
        return GroupedOpenApi.builder()
                .group("server")
                .pathsToMatch("/v1/**")
                .build();
    }
}


```

- In which, only api paths that matched in the `pathsToMatch`  configuration will be generated on the UI. Other api paths will not generated. The UI now will look like below with selected `group` that you configured.

![[spring-boot-openapi-config-generated-ui.png]]

- Sometimes, you want to take more controls on openapi generator like using Java Instant for generated models then you can add more configuration option as below.

```xml

<configOptions>

	...
	
	<typeMappings>
			 <typeMapping>OffsetDateTime=Instant</typeMapping>
	</typeMappings>
	<importMappings>                                
			 <importMapping>java.time.OffsetDateTime=java.time.Instant</importMapping>
	</importMappings>
	
	...

</configOptions>

```
- You can check more configuration options in [this git source](https://github.com/OpenAPITools/openapi-generator/blob/master/docs/generators/spring.md).
- Moreover, you can control generated models  classes by creating a `templates` package in your `resources` directory. Then in your `pom.xml` add `templateDirectory` tag with the path to your custom templates. Your plugin will look like below.

```xml

    <build>
        <plugins>
            <plugin>
                <groupId>org.openapitools</groupId>
                <artifactId>openapi-generator-maven-plugin</artifactId>
                <version>5.4.0</version>
                <executions>
                    <execution>
                        <goals>
                            <goal>generate</goal>
                        </goals>
                        <configuration>
                            <!-- path to the openapi file spec `.yml` -->
                            <inputSpec>
                                ${project.basedir}/src/main/resources/openapi/openapi-server.yml
                            </inputSpec>
                            <generatorName>spring</generatorName>
                            <!-- generated package for api interface -->
                            <apiPackage>com.springboot.cloud.openfeign.openapi.server.app.api</apiPackage>
                            <!-- generated package for models -->
                            <modelPackage>com.springboot.cloud.openfeign.openapi.server.app.model</modelPackage>
                            <!-- using supportingFilesToGenerate -->
                            <supportingFilesToGenerate>
                                ApiUtil.java
                            </supportingFilesToGenerate>
                            <!-- using templateDirectory custom templates for openapi generator -->
                            <templateDirectory>${project.basedir}/src/main/resources/templates</templateDirectory>
                            <configOptions>
                                <delegatePattern>true</delegatePattern>
                                <dateLibrary>java8</dateLibrary>
                                <interfaceOnly>true</interfaceOnly>
                                <useBeanValidation>true</useBeanValidation>
                            </configOptions>
                        </configuration>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>

```

- Then add your custom template `mustaches` file there. Note the name of mustaches files have to be the same as in [this repository](https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator/src/main/resources/JavaSpring).
- You can copy the content of the mustaches files as in the repo above and edit the content as the way you want.
- For example, I want to add `@JsonIgnoreProperties` into every generated models. So I can do it as the image below.
![[spring-boot-openapi-custom-template.png]]
- Then build your project again and check your generated models, you can see the annotation as below
![[spring-boot-openapi-custom-template-test.png]]

## References
- [OpenApi](https://swagger.io/specification/)
- [swagger editor](https://editor.swagger.io/)
- [OpenApi Git Config](https://github.com/OpenAPITools/openapi-generator/blob/master/docs/generators/spring.md).
- [OpenApi Git Templates](https://github.com/OpenAPITools/openapi-generator/tree/master/modules/openapi-generator/src/main/resources/JavaSpring).
- [Full Sample SourceCode](https://github.com/minhducnguyen189/com.springboot.project/tree/master/openapi-app)

