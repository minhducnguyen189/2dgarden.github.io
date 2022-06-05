---

tags: ["Spring", "SpringBoot"]

---

# @ConfigurationProperties In SpringBoot

> Sometimes we need to load a lot of environment variables from **application.properties** or **application.yml** to our spring boot project for using and it is not good way if we use traditional way with @Value.

## Using @ConfigurationProperties with @Component
- `@ConfigurationProperties` and `Component` will help us to convert environment variables to become a spring bean and we can use it everywhere in our project with `@Autowired`. This is the esiest way to config. Now, let's see the example below

- For example we have an **application.yml** with some environment as below. As you can see the **data** has 3 attributes are **name**, **amount** and **price**, so we can imagine that there is an object data has 3 attributes.

```yml
    data:
        name: notebook
        amount: 500
        price: 10.5
```

- So the first thing we should do is create an object class with **getter** and **setter** as default. Then we add the annotation `@ConfigurationProperties(prefix = "data")`, The prefix of the properties that are valid to bind to object. Synonym for prefix, a valid prefix is defined by one or more words separated with dots (e.g. **"company.customer.data"**).

```java

package com.springboot.project.configuration.properties.model;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;


/**
 prefix = "data" it is mean this object is "data" in application.yaml
 And name, amount and price are 3 attributes in this object.
 @Component will make this object become an spring bean and we can use it everywhere with annotation @Autowired
 */

@Component
@ConfigurationProperties(prefix = "data")
public class Data {

    private String name;
    private Integer amount;
    private double price;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }
}

```

- Then we can use it everywhere by using annotation `@Autowired`

```java

package com.springboot.project.configuration.properties.controller;

import com.springboot.project.configuration.properties.model.Data;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GeneralController {

    @Autowired
    private Data data;

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data> getSampleData() {
        return ResponseEntity.ok(data);
    }

}


```

- Now, we will start our spring boot service and call api to check the result.

![[spring-boot-configurationProperties-postman-1.PNG]]

## Using @ConfigurationProperties With Other configuration ways
- So there 2 more ways to make environment varialbes becomce spring bean with `@ConfigurationProperties`.

- The first way is using annotation `@EnableConfigurationProperties(value = {Data2.class})`. We just put this annotation in our `main` class and put the array of classes that are using `ConfigurationProperties`. Let's see the Example below

- We don't use `@Component` anymore so our data class will look like this

```java

package com.springboot.project.configuration.properties.model;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "data")
public class Data2 {

    private String name;
    private Integer amount;
    private double price;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

}


```
- Then is the our main class

```java

package com.springboot.project.configuration.properties;

import com.springboot.project.configuration.properties.model.Data2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.EnableConfigurationProperties;



/**
	 @EnableConfigurationProperties(value = {Data2.class})
	 value is the Data.class that we define above
*/

@SpringBootApplication
@EnableConfigurationProperties(value = {Data2.class})
public class ConfigurationPropertiesApplication {

    public static void main(String[] args) {
        SpringApplication.run(ConfigurationPropertiesApplication.class, args);
    }

}

```

- Then we can use it everywhere by using annotation `@Autowired`

```java

package com.springboot.project.configuration.properties.controller;

import com.springboot.project.configuration.properties.model.Data;
import com.springboot.project.configuration.properties.model.Data2;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GeneralController {

    @Autowired
    private Data data;

    @Autowired
    private Data2 data2;

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data> getSampleData() {
        return ResponseEntity.ok(data);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data2", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data2> getSampleData2() {
        return ResponseEntity.ok(data2);
    }

}

```

- Then you will see the result as below.

![[spring-boot-configurationProperties-postman-2.PNG]]

- The second way is like the way above with **no annotation @Component** in our **Data2.class** but we will use the annotation `@ConfigurationPropertiesScan(value = {"com.springboot.project.configuration.properties.model"})` the value of this annotation is an array of path to the `package` that contains our `Data.class`. So if we have **many classes using `ConfigurationProperties`** we can use this way

- So our main class we look like as below

```java

package com.springboot.project.configuration.properties;

import com.springboot.project.configuration.properties.model.Data2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

/**
		"com.example.workflow.model" is the path to the package that
		contain Data2.class which is using @ConfigurationProperties
*/

@SpringBootApplication
//@EnableConfigurationProperties(value = {Data2.class})
@ConfigurationPropertiesScan(value = {"com.springboot.project.configuration.properties.model"})
public class ConfigurationPropertiesApplication {

    public static void main(String[] args) {
        SpringApplication.run(ConfigurationPropertiesApplication.class, args);
    }

}


```

- Now, let's call api to check the result, you can see it's the same with the first way.

![[spring-boot-configurationProperties-postman-2.PNG]]

## Nested Objects With @ConfigurationProperties
- We can make the `Data3.class` contains another Object class by `@ConfigurationProperties`

- Let's see the example below: As you can see the object `shipper` will be used in `data`. So how we can load them to become spring bean.

```yml

data:
  name: notebook
  amount: 500
  price: 10.5
  shipper:
    name: Duc
    age: 26
    phone: "0123456789"

```

- First we need to create a java class named `Shipper.java` as below

```java

package com.springboot.project.configuration.properties.model;

public class Shipper {

    private String name;
    private Integer age;
    private String phone;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }
}


```

- Then in `Data3.class` we just need add it as an attribute with **getter** and **setter** as default.

```java

package com.springboot.project.configuration.properties.model;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "data")
public class Data3 {

    private String name;
    private Integer amount;
    private double price;
    private Shipper shipper;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Shipper getShipper() {
        return shipper;
    }

    public void setShipper(Shipper shipper) {
        this.shipper = shipper;
    }
}


```

- Then we can use it everywhere by using annotation `@Autowired`

```java

package com.springboot.project.configuration.properties.controller;

import com.springboot.project.configuration.properties.model.Data;
import com.springboot.project.configuration.properties.model.Data2;
import com.springboot.project.configuration.properties.model.Data3;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GeneralController {

    @Autowired
    private Data data;

    @Autowired
    private Data2 data2;

    @Autowired
    private Data3 data3;

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data> getSampleData() {
        return ResponseEntity.ok(data);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data2", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data2> getSampleData2() {
        return ResponseEntity.ok(data2);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data3", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data3> getSampleData3() {
        return ResponseEntity.ok(data3);
    }

}



```

- So our main class we look like as below

```java

package com.springboot.project.configuration.properties;

import com.springboot.project.configuration.properties.model.Data2;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.context.properties.ConfigurationPropertiesScan;
import org.springframework.boot.context.properties.EnableConfigurationProperties;

/**
		"com.example.workflow.model" is the path to the package that
		contain Data2.class which is using @ConfigurationProperties
*/

@SpringBootApplication
//@EnableConfigurationProperties(value = {Data2.class})
@ConfigurationPropertiesScan(value = {"com.springboot.project.configuration.properties.model"})
public class ConfigurationPropertiesApplication {

    public static void main(String[] args) {
        SpringApplication.run(ConfigurationPropertiesApplication.class, args);
    }

}

```

- Finally we can use the `Data3.class` everywhere with `@Autowired` and It contains the data of `Shipper.class` also.

![[spring-boot-configurationProperties-postman-3.PNG]]

## Using @ConfigurationProperties with @Configuration
- We can use `@ConfigurationProperties` and `@Bean` to initiate a bean which is loaded from `application.yml` in configuration classes.
- To do it, let's create a `Data4.class` as below, that does not require us to add any annotation more, just a default java model class.

```java

package com.springboot.project.configuration.properties.model;

public class Data4 {

    private String name;
    private Integer amount;
    private double price;
    private Shipper shipper;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getAmount() {
        return amount;
    }

    public void setAmount(Integer amount) {
        this.amount = amount;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public Shipper getShipper() {
        return shipper;
    }

    public void setShipper(Shipper shipper) {
        this.shipper = shipper;
    }
}



```

- Then let's create a configuration class name as below:

```java


package com.springboot.project.configuration.properties.config;

import com.springboot.project.configuration.properties.model.Data4;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class PropertiesConfiguration {

    @Bean
    @ConfigurationProperties(prefix = "data")
    public Data4 data4() {
        return new Data4();
    }

}

```

- So, now you can use it everywhere by `@Autowired`

```java

package com.springboot.project.configuration.properties.controller;

import com.springboot.project.configuration.properties.model.Data;
import com.springboot.project.configuration.properties.model.Data2;
import com.springboot.project.configuration.properties.model.Data3;
import com.springboot.project.configuration.properties.model.Data4;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GeneralController {

    @Autowired
    private Data data;

    @Autowired
    private Data2 data2;

    @Autowired
    private Data3 data3;

    @Autowired
    private Data4 data4;

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data> getSampleData() {
        return ResponseEntity.ok(data);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data2", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data2> getSampleData2() {
        return ResponseEntity.ok(data2);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data3", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data3> getSampleData3() {
        return ResponseEntity.ok(data3);
    }

    @RequestMapping(method = RequestMethod.GET, path = "/v1/general/data4", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<Data4> getSampleData4() {
        return ResponseEntity.ok(data4);
    }

}


```

- Let's start your application and call api, you will the result as below

![[spring-boot-configurationProperties-postman-5.PNG]]

## References
- [You can view full source code here](https://github.com/minhducnguyen189/com.springboot.project/tree/master/configuration-properties)