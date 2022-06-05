---

tags: ["Spring", "SpringBoot"]

---

# Spring Boot With Exception Handler And Message Source
## Why Do We Need Exception Handling?
- Exception handling is very important in software projects because it will decide what are next steps that software should handle when an exception happens in run time. For example, if an exception happens in loading data in database so we can notify to FE a message with is friendly and familiar with user/business so they can know what is happening to take action. For developers they will know where this exception happened and find root causes easier by reading or searching logs. Moreover, in special software regarding to finance and banking, developers have to handle all exceptions that can occur closely with business cases.

## What Is The Message Source?
- `MessageSource` is a powerful feature available in Spring applications. This helps application developers handle various complex scenarios with writing much extra code, such as environment-specific configuration, internationalization or configurable values. One more scenario could be modifying the default validation messages to more user-friendly/custom messages.
- [More information](https://www.baeldung.com/spring-custom-validation-message-source).
- In spring boot `MessageSource` has been added as default, so you don't need to add any dependency for this feature. However, you have to create a configuration for using. So, let's create a configuration class `AppConfig` and put configuration codes as below

## Code Example
### Configure Message Source

```java

package com.exception.handler.demo.config;

import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.support.ResourceBundleMessageSource;

@Configuration
public class AppConfig {

    @Bean(name = "messageSource")
    public MessageSource messageSourceConfig() {
        ResourceBundleMessageSource messageSource = new ResourceBundleMessageSource();
        messageSource.setBasenames("messages/error");
        messageSource.setDefaultEncoding("UTF-8");
        messageSource.setUseCodeAsDefaultMessage(true);
        return messageSource;
    }
}

```

- Note: by default the name of the bean is the method name, so you have to add `@Bean(name = "messageSource")` if you are using a custom method name. Then you need to set `Basenames` for messageSource which include the path and the suffix of your properties files. Let's see the image below.

![[spring-boot-message-source-structure-project.PNG]]
- Then you need to create `properties` files to contain messages, I will create 3 properties file with 3 different languages.

- Note: By default when you use Intellij to create `properties` files, your files will be encoded as `ISO-88591`. So when you put other languages, for example: Japanese or Vietnamese languages, the messages can not be encoded to `UTF-8` then you can not read your messages in these languages. To solve this issue you need to create `properties` files with `UTF-8` encoding.

- So you need to open `File` -> `Settting` of Intellij, then you choose the path to your `properties` files with Encoding is `UTF-8` and choose default encoding for `properties` files as `UTF-8` too. let's see the image below.

![[spring-boot-message-source-intellij-encoding-config.png]]

- Next, create`error.properties` file as in the image, it will contain default language as English, so we will define an example message as below.

- Next, create`error.properties` file as in the image, it will contain default language as English, so we will define an example message as below.

```properties

service.customer.email.1=can not find any customer following email {0}

```

- In the `error_ja.properties` file we will add Japanese message as below:

```properties

service.customer.email.1=メールをフォローしている顧客が見つかりません {0} - JP

```

- Finally, in the `error_vi.properties` file, we will add Vietnamese message as below:

```properties

service.customer.email.1=Không tìm thấy bất kỳ khác hàng nào với email {0} - VN

```

### Create A Custom Exception
- We will create a custom exception from `RuntimeException` class, because it is the top and represent for `unchecked exception` in Java. If you don't know what is the **checked exception** or **unchecked exception** you can view [[Java Core Introduction]] for more details.

- So, we will create an exception name `ResourceNotFoundException` and it is extended from `RuntimeException`. Then we will create 3 constructors and 2 attributes as below.

```java

package com.exception.handler.demo.exception;

public class ResourceNotFoundException extends RuntimeException {

    private final String messageKey;
    private final String[] param;


    public ResourceNotFoundException(String message) {
        super(message);
        this.messageKey = message;
        param = null;
    }

    public ResourceNotFoundException(String message, String... param) {
        super(message);
        this.messageKey = message;
        this.param = param;
    }

    public ResourceNotFoundException(String message, Throwable cause, String... param) {
        super(message, cause);
        this.messageKey = message;
        this.param = param;
    }

    public String getMessageKey() {
        return messageKey;
    }

    public String[] getParam() {
        return param;
    }
}

```

- So with these constructors, we will have 3 ways to create `ResourceNotFoundException`. For example.

```java

ResourceNotFoundException exception1 = new ResourceNotFoundException("message")

ResourceNotFoundException exception2 = new ResourceNotFoundException("message", "sample param")

ResourceNotFoundException exception3 = new ResourceNotFoundException("message", cause, "sample param")

```

### Create An Exception Handler

- To create an exception handler, the first thing we need to do is creating a response model (response body). Create a model `ErrorDetail` as below

```java

package com.exception.handler.demo.model.exception;

import java.time.LocalDateTime;

public class ErrorResponse {

    private LocalDateTime timestamp;
    private String message;
    private int errorCode;
    private String status;
    private String api;
    private String key;
    private ErrorDetail detail;

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getErrorCode() {
        return errorCode;
    }

    public void setErrorCode(int errorCode) {
        this.errorCode = errorCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getApi() {
        return api;
    }

    public void setApi(String api) {
        this.api = api;
    }

    public String getKey() {
        return key;
    }

    public void setKey(String key) {
        this.key = key;
    }

    public ErrorDetail getDetail() {
        return detail;
    }

    public void setDetail(ErrorDetail detail) {
        this.detail = detail;
    }
}

```

- The `ErrorResponse` contains `ErrorDetail` so we will create `ErrorDetail` as below.

```java

package com.exception.handler.demo.model.exception;

public class ErrorDetail {

    private String stacktrace;

    public String getStacktrace() {
        return stacktrace;
    }

    public void setStacktrace(String stacktrace) {
        this.stacktrace = stacktrace;
    }
}

```

- Next, We will create an exception handler class named `GlobalExceptionHandler` which will extends from `ResponseEntityExceptionHandler` class, by default the `ResponseEntityExceptionHandler` will provide an `@ExceptionHandler` method for handling internal Spring MVC exceptions which include exceptions below.

---

  - HttpRequestMethodNotSupportedException.class
  - HttpMediaTypeNotSupportedException.class
  - HttpMediaTypeNotAcceptableException.class
  - MissingPathVariableException.class
  - MissingServletRequestParameterException.class
  - ServletRequestBindingException.class
  - ConversionNotSupportedException.class
  - TypeMismatchException.class
  - HttpMessageNotReadableException.class
  - HttpMessageNotWritableException.class
  - MethodArgumentNotValidException.class
  - MissingServletRequestPartException.class
  - BindException.class
  - NoHandlerFoundException.class
  - AsyncRequestTimeoutException.class

---

- In our case, we want to handle our custom exception and return custom response body so that is the reason why we extends from `ResponseEntityExceptionHandler`.


```java

package com.exception.handler.demo.handler;

import com.exception.handler.demo.exception.ResourceNotFoundException;
import com.exception.handler.demo.model.exception.ErrorDetail;
import com.exception.handler.demo.model.exception.ErrorResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.mvc.method.annotation.ResponseEntityExceptionHandler;

import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.Locale;

@ControllerAdvice
public class GlobalExceptionHandler extends ResponseEntityExceptionHandler {

    @Autowired
    private MessageSource messageSource;

    @ResponseStatus(HttpStatus.NOT_FOUND)
    @ResponseBody
    @ExceptionHandler(value = {ResourceNotFoundException.class})
    public ErrorResponse handleResourceNotFoundException(ResourceNotFoundException ex, WebRequest request, Locale locale) {
        String errorMessage = messageSource.getMessage(ex.getMessageKey(), ex.getParam(), locale);
        ErrorResponse errorResponse = new ErrorResponse();
        errorResponse.setErrorCode(HttpStatus.NOT_FOUND.value());
        errorResponse.setMessage(errorMessage);
        errorResponse.setTimestamp(LocalDateTime.now());
        errorResponse.setApi(request.getDescription(false));
        errorResponse.setStatus(HttpStatus.NOT_FOUND.getReasonPhrase());
        errorResponse.setKey(ex.getMessageKey());
        ErrorDetail errorDetail = new ErrorDetail();
        errorDetail.setStacktrace(Arrays.toString(ex.getStackTrace()));
        errorResponse.setDetail(errorDetail);
        return errorResponse;
    }

}

```

- We will define the exception that we want to resolve in `@ExceptionHandler(value = {<your custome exception class>})`. Then We also use the `MessageSource` to get the message that we defined in `properties` file following the default `Locale`. Form the custom exception `ResourceNotFoundException` we can get some information and put it into the reponse body `ErrorResponse`.

### Testing

- Now, we will create a sample service and controller to test our custom exception. A sample service will look like below

```java

@Service
public class CustomerService {

    @Autowired
    private CustomerRepository customerRepository;

    public CustomerResponse getCustomerByEmail(String email) {
        CustomerEntity customerEntity = this.customerRepository.findCustomerByEmail(email);
        if (Objects.isNull(customerEntity)) {
            throw new ResourceNotFoundException("service.customer.email.1", email);
        }
        return this.toCustomerResponse(customerEntity);
    }

```

- We create `ResourceNotFoundException` with message `service.customer.email.1` which is the key of message that we defined in `properties` files.
- Then we create a controller as below

```java

package com.exception.handler.demo.controller;

import com.exception.handler.demo.model.CustomerRequest;
import com.exception.handler.demo.model.CustomerResponse;
import com.exception.handler.demo.service.CustomerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@RestController
public class Controller {

    @Autowired
    private CustomerService customerService;

    @RequestMapping(method = RequestMethod.GET, path = "/v1/customers", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<CustomerResponse> getCustomerByEmail(@RequestParam(name = "email") String email ) {
        return new ResponseEntity<>(customerService.getCustomerByEmail(email), HttpStatus.OK);
    }

}

```

- For the Entity and Repository, please view full source code in `SUMMARY` path of this post or you can create them by yourself.
- Finally, we will add some configuration in to `application.yml`, I would like to set the default `Locale` as **Japan**. So I should got the error message with Japanese languages.

```yaml

spring:
  datasource:
#    url: jdbc:h2:mem:testdb
    url: jdbc:h2:file:./testdb
    username: sa
    password: password
    driver-class-name: org.h2.Driver
    platform: h2
  jpa:
    database-platform: org.hibernate.dialect.H2Dialect
    hibernate.ddl-auto: update
    generate-ddl: true
    show-sql: true
  h2:
    console:
      enabled: true
      path: /h2-console
      settings:
        trace: false
        web-allow-others: false
  web:
    locale: ja_JP
    locale-resolver: fixed

```

- Now, start the service and use postman to call api, then you will see the result as below.

![[spring-boot-message-source-test-result-1.png]]
- Then when we configure locale as **VietNam** so, we will received a Vietnamese message.

```yaml

spring:
  web:
    locale: vi_VN
    locale-resolver: fixed

```

![[spring-boot-message-source-test-result-2.png]]
- If we do not configure default Locale or we configure a locale that does not existed in our messages resource, so the service will automatically return the default message in `error.properties` file.

```yaml

spring:
  web:
    locale: it_IT
    locale-resolver: fixed

# or comment out as below.

# spring:
#   web:
#     locale: it_IT
#     locale-resolver: fixed    

```

![[spring-boot-message-source-test-result-3.png]]

## Summary
- In conclusion, Exception handling is very important in software development, it is not only help users know what happened in system but also help developer can determine quickly and exactly the root causes.
- We create a custom exception by extend `RuntimeException` class because it is the top of unchecked exceptions. It means every exception happened at runtime will be navigated to `RuntimeException`.
- We can create an exception handler with a class using `@ControllerAdvice` and extended from `ResponseEntityExceptionHandler`. In this class methods can handle one or more Exceptions with support of `@ExceptionHandler`. From information of custom exceptions we can build the response body following what we want.
- With the supports from Spring Framework, `MessageSource` is very helpful when we want to change error message language or simply use it as a place to contain all error messages which will help us maintain error messages and use them easier.
- To view full source code you can go to this [github link](https://github.com/minhducnguyen189/com.springboot.project/tree/master/exception-handler-app)

## References
- [Baeldung](https://www.baeldung.com/spring-custom-validation-message-source)
