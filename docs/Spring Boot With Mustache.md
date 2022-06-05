---

tags: ["Spring", "SpringBoot"]

---

# Spring Boot With Mustache
## What Is The Mustache?
- `Mustache` is a logic-less templates. `Mustache` can be used for HTML, config files, source code - anything. It works by expanding tags in a template using values provided in a hash or object.
- We call it "logic-less" because there are no if statements, else clauses, or for loops. Instead there are only tags. Some tags are replaced with a value, some nothing, and others a series of values.
- [More information](https://mustache.github.io/mustache.5.html)

## Mustache Syntax
- Let's check more detail in [this page](https://mustache.github.io/mustache.5.html)

### Variables
- The most basic tag type is the variable. A `{{name}}` tag in a basic template will try to find the `name` key in the current context. If there is no `name` key, the parent contexts will be checked recursively. If the top context is reached and the `name` key is still not found, nothing will be rendered.
- All variables are HTML escaped by default. If you want to return unescaped HTML, use the triple mustache: `{{{name}}}`.
- You can also use `&` to unescape a variable: `{{& name}}`. This may be useful when changing delimiters (see "Set Delimiter" below).
- By default a variable "miss" returns an empty string. This can usually be configured in your Mustache library. The Ruby version of Mustache supports raising an exception in this situation, for instance.
- Template: sample.mustache

```json

{
	"id": "{{{id}}}"
}

```

- Result

```json

{

	"id": "9c107c20-d989-4628-83e1-e728b3d4a5e5"
	
}

```

### Section
- Sections render blocks of text one or more times, depending on the value of the key in the current context.
- A section begins with a pound and ends with a slash. That is, `{{#persons}}` begins a "person" section while `{{/persons}}` ends it.
- The behavior of the section is determined by the value of the key.
- **False Values or Empty Lists**
- If the `persons` key exists and has a value of false or an empty list, the HTML between the pound and slash will not be displayed.
- Template: Person.mustache

```json

{
    "persons": [
                {{#persons}}
                {
                    "id": {{{id}}},
                    "name": {{{name}}},
                    "sex": {{{sex}}},
                    "age": {{{age}}},
                }
                {{^-last}},{{/-last}}
                {{/persons}}
    ]
}



```

- Result:

```json

{
    "persons": [
        {
            "id": "9c107c20-d989-4628-83e1-e728b3d4a5e5",
            "name": "Duc",
            "sex": "male",
            "age": "27"
        }
    ]
}

```

### Inverted Sections
- An inverted section begins with a caret (hat) and ends with a slash. That is `{{^person}}` begins a "person" inverted section while `{{/person}}` ends it.
- While sections can be used to render text one or more times based on the value of the key, inverted sections may render text once based on the inverse value of the key. That is, they will be rendered if the key doesn't exist, is false, or is an empty list.

```json

{

	{{#car}}  
     "vehicleId": {{{id}}},  
     "vehicleName": {{{carName}}}  
	{{/car}}  
	{{^car}}  
			 "noCar": true  
	{{/car}}

}

```

- Results: that car has values

```json

{

	"vehicleId": "9c107c20-d989-4628-83e1-e728b3d4a5e0",
	"vehicleName": "minicoper"
	
}

```

- Results: that car has no values

```json

{

	"noCar": true
	
}

```

### Comments
- Comments begin with a bang and are ignored. The following template:

```json

{

	"comment": "{{! ignore me}}"

}


```

- Will render as follows:

```json

{

	"comment": ""

}

```

### Partials
- Partials begin with a greater than sign, like `{{> laptop}}`.
- Partials are rendered at runtime (as opposed to compile time), so recursive partials are possible. Just avoid infinite loops.
- Mustache requires only this:

```

{{> laptop}}

```

- Why? Because the `person.mustache` file will inherit the `size` and `start` methods from the calling context.
- In this way you may want to think of partials as includes, imports, template expansion, nested templates, or sub-templates, even though those aren't literally the case here.
- For example, this template and partial:

```json
person.mustache:

{
    "persons": [
                {{#persons}}
                {
                    "id": {{{id}}},
                    "name": {{{name}}},
                    "sex": {{{sex}}},
                    "age": {{{age}}},
                    "additionalInfo": {
                        "comment": "{{! ignore me}}",
                        {{#info}}
                            "job": {{{mainJob}}},
                            "companyAddress": {{{workplace}}},
                            "employeeId": {{{staffId}}},
                        {{/info}}
                        {{#car}}
                             "vehicleId": {{{id}}},
                             "vehicleName": {{{carName}}},
                        {{/car}}
                        {{^car}}
                             "noCar": true,
                        {{/car}}
                        {{> laptop}}
                    }
                }
                {{^-last}},{{/-last}}
                {{/persons}}
    ]
}
```

- Can be thought of as a single, expanded template:

```json

{{#laptop}}
    "laptopName": {{{name}}},
    "branch": {{{branch}}},
    "price": {{{price}}}
{{/laptop}}

```

## Mustache Example With Spring Boot
- Now, let's take an example with using mustache in spring boot service for mapping json.

### Dependencies
- Let's add the dependency below for using mustache in spring boot.

```xml

<dependency>
		<groupId>com.samskivert</groupId>
		<artifactId>jmustache</artifactId>
		<version>1.15</version>
</dependency>

```

### Create Mustache Templates
- Now, in the `resources` in your spring boot project, we will create a directory with named `templates`. This directory will be a place to contain all your mustache templates.
- Then let's create 2 templates, `person.mustache` and `laptop.mustache` as below

![[spring-boot-sample-mustache-templates.png]]

- person.mustache
```json

{
    "persons": [
                {{#persons}}
                {
                    "id": {{{id}}},
                    "name": {{{name}}},
                    "sex": {{{sex}}},
                    "age": {{{age}}},
                    "additionalInfo": {
                        "comment": "{{! ignore me}}",
                        {{#info}}
                            "job": {{{mainJob}}},
                            "companyAddress": {{{workplace}}},
                            "employeeId": {{{staffId}}},
                        {{/info}}
                        {{#car}}
                            "vehicleId": {{{id}}},
                            "vehicleName": {{{carName}}},
                        {{/car}}
                        {{^car}}
                            "noCar": true,
                        {{/car}}
                        {{> laptop}}
                    }
                }
                {{^-last}},{{/-last}}
                {{/persons}}
    ]
}

```

- laptop.mustache

```json

{{#laptop}}
    "laptopName": {{{name}}},
    "branch": {{{branch}}},
    "price": {{{price}}}
{{/laptop}}

```

- As you can see, we will bind data to the template `person` and `laptop` in which the template `laptop` will be a sub-template of template `person`. In this example we will use the json data as below to map key-value with templates above.

```json

{
    "persons": [
        {
            "id": "9c107c20-d989-4628-83e1-e728b3d4a5e5",
            "name": "Duc",
            "sex": "male",
            "age": "27",
            "car": {
                "id": "9c107c20-d989-4628-83e1-e728b3d4a5e0",
                "carName": "minicoper"
            },
            "info": {
                "mainJob": "director",
                "workplace": "mr duc",
                "staffId": "4628"
            },
            "laptop": {
                "name": "BF103TU",
                "branch": "HP",
                "price": "1000$"
            }
        }
    ]
}

```

### Controller
- Let's create a simple controller with api as below, then we can use postman to test.

```java

package com.springboot.project.mustache.app.controller;

import com.springboot.project.mustache.app.service.MustacheTemplateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class MustacheController {

    @Autowired
    private MustacheTemplateService mustacheTemplateService;

    @RequestMapping(method = RequestMethod.POST, path = "/v1/mustache/transform", produces = {MediaType.APPLICATION_JSON_VALUE})
    public ResponseEntity<String> tranformJson(@RequestBody String body) {
        return new ResponseEntity<>(this.mustacheTemplateService.transform(body), HttpStatus.CREATED);
    }

}

```

### Service
- Let's create a service class `MustacheTemplateService` and put the code as below, to map the input json to the template and get the mapped json back.

```java

package com.springboot.project.mustache.app.service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.samskivert.mustache.Mustache;
import com.samskivert.mustache.Template;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.concurrent.ConcurrentHashMap;

@Service
public class MustacheTemplateService {

    @Autowired
    private Mustache.TemplateLoader templateLoader;
    @Autowired
    private Mustache.Compiler compiler;
    private static final String CLASS_PATH_TEMPALTE = "person";

    @Autowired
    private ObjectMapper objectMapper;

    private static final ConcurrentHashMap<String, Template> TEMPLATE_CACHE = new ConcurrentHashMap<>();


    public String transform(String inputData) {
        try {
            System.out.println(inputData);
            ObjectMapper mapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
            Object obj = mapper.readValue(inputData, Object.class);
            Template template = TEMPLATE_CACHE.computeIfAbsent(CLASS_PATH_TEMPALTE, s -> {
                try {
                    return compiler.defaultValue("null").withFormatter(new Mustache.Formatter() {
                        @Override
                        public String format(Object value) {
                            if(!"null".equalsIgnoreCase(value.toString())){
                                if(value instanceof  String){
                                    return '\"'+value.toString()+'\"';
                                }
                            }
                            return value.toString();
                        }
                    }).compile(templateLoader.getTemplate(CLASS_PATH_TEMPALTE));
                } catch (Exception e) {
                    e.printStackTrace();
                    return null;
                }
            });
            String result = template.execute(obj);
            System.out.println(result);
            return result;
        }catch(Exception e){
            e.printStackTrace();
        }
        return null;
    }

}

```

- We will need to @Autowired two service from the Mustache library, they are `TemplateLoader` and `Compiler`. 
	- In which the `TemplateLoader` with method `getTemplate()` is use to get the root mustache template that you created in `sources/templates/`.
	- The `Compiler` is used to configure binding data into the template, in this example, we will configure the mustache `compiler` ignore null values, so with non null and string values, they will be wrapped into the double quotes `" "` for other values as null, number and boolean value, they will be keep as default.

### Testing
- Now, let's start your spring boot service and use postman to execute the api with body as below:

```json

curl --location --request POST 'http://localhost:8080/v1/mustache/transform' \
--header 'Content-Type: application/json' \
--data-raw '{
    "persons": [
        {
            "id": "9c107c20-d989-4628-83e1-e728b3d4a5e5",
            "name": "Duc",
            "sex": "male",
            "age": "27",
            "car": {
                "id": "9c107c20-d989-4628-83e1-e728b3d4a5e0",
                "carName": "minicoper"
            },
            "info": {
                "mainJob": "director",
                "workplace": "mr duc",
                "staffId": "4628"
            },
            "laptop": {
                "name": "BF103TU",
                "branch": "HP",
                "price": "1000$"
            }
        }
    ]
}'

```

- Then you will received with response json as below:

```json

{
    "persons": [
        {
            "id": "9c107c20-d989-4628-83e1-e728b3d4a5e5",
            "name": "Duc",
            "sex": "male",
            "age": "27",
            "additionalInfo": {
                "comment": "",
                "job": "director",
                "companyAddress": "mr duc",
                "employeeId": "4628",
                "vehicleId": "9c107c20-d989-4628-83e1-e728b3d4a5e0",
                "vehicleName": "minicoper",
                "laptopName": "BF103TU",
                "branch": "HP",
                "price": "1000$"
            }
        }
    ]
}

```

![[spring-boot-mustache-test-result.png]]

## References
- [Mustache Github Io](https://mustache.github.io/mustache.5.html).