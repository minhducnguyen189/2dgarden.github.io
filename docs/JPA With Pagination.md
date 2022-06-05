---

tags: ["Spring", "SpringData", "SpringBoot"]

---

# Pagination With JPA Introduction
## Dependencies
- First, you need to add some dependencies below into your `pom.xml`. In this example I will use `mysql database`. You can choose other databases if you like, [[Database Configuration In SpringBoot]] maybe is helpful for you.

```xml

    <dependencies>

        <!-- ....other dependencies... -->

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
        </dependency>

        <!-- ....other dependencies... -->

    </dependencies>

```

## Implementation
### Entity And Models
- First, you need to create an `Entity` which will reflect with the table in your database and It will be the object for manipulation information between JPA and Database. Below is my example `Entity`

```java
    package com.application.adapter.models.entities;

    import javax.persistence.Column;
    import javax.persistence.Entity;
    import javax.persistence.Id;
    import javax.persistence.Table;

    @Entity
    @Table(name = "Post")
    public class PostEntity {


        @Id
        @Column(name = "ID", length = 36)
        private String id;

        @Column(name = "CREATED_DATE", length = 50)
        private String createdDate;

        @Column(name = "LAST_MODIFIED_DATE", length = 50)
        private String lastModifiedDate;

        @Column(name = "AUTHOR", length = 100, nullable = false)
        private String author;

        @Column(name = "TITLE", nullable = false)
        private String title;

        @Column(name = "CONTENT", nullable = false)
        private String content;

        @Column(name = "SUMMARY", nullable = false)
        private String summary;


        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getCreatedDate() {
            return createdDate;
        }

        public void setCreatedDate(String createdDate) {
            this.createdDate = createdDate;
        }

        public String getLastModifiedDate() {
            return lastModifiedDate;
        }

        public void setLastModifiedDate(String lastModifiedDate) {
            this.lastModifiedDate = lastModifiedDate;
        }

        public String getAuthor() {
            return author;
        }

        public void setAuthor(String author) {
            this.author = author;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }

        public String getSummary() {
            return summary;
        }

        public void setSummary(String summary) {
            this.summary = summary;
        }
    }

```

- Next, We will create a model for filter request which contains some information like `current page`,  `number of item in page`, `sort field` and `sort order`.

```java
    package com.application.adapter.models.request;


    import javax.validation.constraints.NotNull;

    public class Filter {

        // current page
        @NotNull
        private Integer page;

        // number of item in page
        @NotNull
        private Integer pageSize;

        // sort field
        private String sortField;

        //sort order
        private SortOrder sortOrder;

        public Integer getPage() {
            return page;
        }

        public void setPage(Integer page) {
            this.page = page;
        }

        public Integer getPageSize() {
            return pageSize;
        }

        public void setPageSize(Integer pageSize) {
            this.pageSize = pageSize;
        }

        public String getSortField() {
            return sortField;
        }

        public void setSortField(String sortField) {
            this.sortField = sortField;
        }

        public SortOrder getSortOrder() {
            return sortOrder;
        }

        public void setSortOrder(SortOrder sortOrder) {
            this.sortOrder = sortOrder;
        }
    }

```

- Then create a model for response result.

```java

    package com.application.adapter.models.response;

    public class PostResponse {

        private String id;

        private String createdDate;

        private String lastModifiedDate;

        private String title;

        private String summary;

        private String author;

        private String content;

        public String getId() {
            return id;
        }

        public void setId(String id) {
            this.id = id;
        }

        public String getCreatedDate() {
            return createdDate;
        }

        public void setCreatedDate(String createdDate) {
            this.createdDate = createdDate;
        }

        public String getLastModifiedDate() {
            return lastModifiedDate;
        }

        public void setLastModifiedDate(String lastModifiedDate) {
            this.lastModifiedDate = lastModifiedDate;
        }

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getSummary() {
            return summary;
        }

        public void setSummary(String summary) {
            this.summary = summary;
        }

        public String getAuthor() {
            return author;
        }

        public void setAuthor(String author) {
            this.author = author;
        }

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }
    }

```

### RESPOSITORY

- Now, you need to create a `Respository` which will be the layer to help you do queries and get results from your database, because we are using JPA for paging and sorting so we will extend our repository from `PagingAndSortingRepository` that JPA provided.

```java

    package com.application.adapter.repositories;

    import com.application.adapter.models.entities.PostEntity;
    import org.springframework.data.repository.PagingAndSortingRepository;
    import org.springframework.stereotype.Repository;

    @Repository
    public interface PostPagingRepository extends PagingAndSortingRepository<PostEntity, Long> {
    }

```

### Service
- So now, you can create a `Service` and put some implementation code as below. Note that because we are extending our repository from `PagingAndSortingRepository` so we have to use `Pageable` and `Page` of JPA as the object for queries and response results from database, respectively.

```java

    package com.application.adapter.services;

    import com.application.adapter.models.entities.PostEntity;
    import com.application.adapter.models.request.Filter;
    import com.application.adapter.models.request.Post;
    import com.application.adapter.models.response.PostResponse;
    import com.application.adapter.repositories.PostPagingRepository;
    import com.application.adapter.utilities.MapperUtil;
    import org.apache.commons.lang.StringUtils;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.beans.factory.annotation.Qualifier;
    import org.springframework.beans.factory.annotation.Value;
    import org.springframework.data.domain.Page;
    import org.springframework.data.domain.PageRequest;
    import org.springframework.data.domain.Pageable;
    import org.springframework.data.domain.Sort;
    import org.springframework.stereotype.Service;

    import java.util.List;
    import java.util.stream.Collectors;

    @Service
    public class TodoServiceImpl implements TodoService{

        @Autowired
        private PostPagingRepository pagingRepository;

        @Value("${post.page.defaultKey}")
        private String defaultSortField;

        @Override
        public List<PostResponse> filterPosts(Filter filter) {
            Pageable pageable;
            if(StringUtils.isEmpty(filter.getSortField())) {
                pageable = PageRequest.of(filter.getPage(), filter.getPageSize(), Sort.by(defaultSortField).descending());
            } else if(!StringUtils.isEmpty(filter.getSortField()) && filter.getSortOrder() == null) {
                pageable = PageRequest.of(filter.getPage(), filter.getPageSize(), Sort.by(filter.getSortField()).descending());
            } else {
                pageable = PageRequest.of(filter.getPage(), filter.getPageSize(),Sort
                .by(Sort.Direction.valueOf(filter.getSortOrder().name()), filter.getSortField()));
            }
            Page<PostEntity> page = pagingRepository.findAll(pageable);
            List<PostEntity> entities = page.getContent();

            //after got entities, then map them to response model.
            return entities.stream().map(e -> MapperUtil.mappingObject(e, new PostResponse())).collect(Collectors.toList());
        }
    }

```

### Controller
- Finally, let's create a simple controller with an filter api and inject your service for using.

```java

    package com.application.adapter.controller;

    import com.application.adapter.models.request.Filter;
    import com.application.adapter.models.request.Post;
    import com.application.adapter.models.response.PostResponse;
    import com.application.adapter.services.TodoService;
    import org.springframework.beans.factory.annotation.Autowired;
    import org.springframework.http.HttpStatus;
    import org.springframework.http.ResponseEntity;
    import org.springframework.lang.NonNull;
    import org.springframework.lang.Nullable;
    import org.springframework.stereotype.Controller;
    import org.springframework.web.bind.annotation.*;

    import javax.validation.Valid;
    import javax.validation.constraints.NotNull;
    import javax.websocket.server.PathParam;
    import java.util.List;


    @Controller
    public class ApiController {

        @Autowired
        private TodoService todoService;

        @RequestMapping(method = RequestMethod.POST, path = "blog/posts/filter")
        public ResponseEntity<List<PostResponse>> filterPosts(@RequestBody @NotNull @Valid Filter filter) {
            return new ResponseEntity<>(todoService.filterPosts(filter), HttpStatus.OK);
        }
    }

```

## Testing
- Using postman and call to your api with filter body as below

```json

    //Filter body request

    {
        "page": 0,
        "pageSize": 5,
        "sortField": "createdDate",
        "sortOrder": "DESC"
    }

```

```json

    //Response body

    [
        {
            "id": "d182f776-615b-4d21-bd5e-3815c6b1e013",
            "createdDate": "03-04-2021 18:56:22",
            "lastModifiedDate": "03-04-2021 18:56:22",
            "title": "How to master java",
            "summary": "There are some tips to master java at home",
            "author": "minh duc",
            "content": "There are some tips to master java at home"
        },
        {
            "id": "01f196dd-db86-4faa-afc8-208f5ae97069",
            "createdDate": "03-04-2021 18:56:21",
            "lastModifiedDate": "03-04-2021 18:56:21",
            "title": "How to master java",
            "summary": "There are some tips to master java at home",
            "author": "minh duc",
            "content": "There are some tips to master java at home"
        },
        {
            "id": "3f89c7ff-d738-4caf-bc41-7d00ca09f6c5",
            "createdDate": "03-04-2021 18:56:19",
            "lastModifiedDate": "03-04-2021 18:56:19",
            "title": "How to master java",
            "summary": "There are some tips to master java at home",
            "author": "minh duc",
            "content": "There are some tips to master java at home"
        },
        {
            "id": "b352cf2a-fc18-43de-aac0-9d5053a62d0c",
            "createdDate": "03-04-2021 18:55:59",
            "lastModifiedDate": "03-04-2021 18:55:59",
            "title": "How to master java",
            "summary": "There are some tips to master java at home",
            "author": "minh duc",
            "content": "There are some tips to master java at home"
        }
    ]

```

## See Also
[[Database Configuration In SpringBoot]]
