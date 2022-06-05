---

tags: ["Spring", "SpringData"]

---

# Entity Introduction
## What Is The Entity?
- `Entity` objects: An entity is a simple Java class that represents a row in a database table.
- `Entities` can be concrete classes or abstract classes. They maintain states by using properties or fields.
- So in `Entity` classes we will use a lot of mapping annotations from JPA, you can review these annotations in the table below:

| Annotation | Description |
| --- | --- |
| @Entity | The @Entity annotation is used to specify that the currently annotated class represents an entity type. Unlike basic and embeddable types, entity types have an identity and their state is managed by the underlying Persistence Context. |
| @Table | The @Table annotation is used to specify the primary table of the currently annotated entity. |
| @Id | The @Id annotation specifies the entity identifier. An entity must always have an identifier attribute which is used when loading the entity in a given Persistence Context. |
| @GeneratedValue | The @GeneratedValue annotation specifies that the entity identifier value is automatically generated using an identity column, a database sequence, or a table generator. Hibernate supports the @GeneratedValue mapping even for UUID identifiers. |
| @Type | The @Type annotation is used to specify the Hibernate @Type used by the currently annotated basic attribute. |
| @Column | The @Column annotation is used to specify the mapping between a basic entity attribute and the database table column. |
| @Enumerated | The @Enumerated annotation is used to specify that an entity attribute represents an enumerated type. In which, ORDINAL: stored according to the enum value’s ordinal position within the enum class, as indicated by java.lang.Enum#ordinal STRING: stored according to the enum value’s name, as indicated by java.lang.Enum#name |
| @OneToMany | The @OneToMany annotation is used to specify a one-to-many database relationship. |
| @ManyToOne | The @ManyToOne annotation is used to specify a many-to-one database relationship. |
| @JoinColumn | The @JoinColumn annotation is used to specify the FOREIGN KEY column used when joining an entity association or an embeddable collection. |
| @PrePersist | The @PrePersist annotation is used to specify a callback method that fires before an entity is persisted. |
| @PreUpdate | The @PreUpdate annotation is used to specify a callback method that fires before an entity is updated. |

- [You can find more here](https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#configurations-internal).

## Entity Example
- We will create entities which represent for 3 tables in the database.

![[spring-boot-jdbc-core-database-tables.png]]

- Note: You don't need to create these 3 tables in the database because JPA will create for you automatically when the Spring Boot application has started.
- So in Entity classes we will use a lot of mapping annotations from JPA, so you can review these annotations in the table below:

| Annotation | Description |
| --- | --- |
| @Entity | The @Entity annotation is used to specify that the currently annotated class represents an entity type. Unlike basic and embeddable types, entity types have an identity and their state is managed by the underlying Persistence Context. |
| @Table | The @Table annotation is used to specify the primary table of the currently annotated entity. |
| @Id | The @Id annotation specifies the entity identifier. An entity must always have an identifier attribute which is used when loading the entity in a given Persistence Context. |
| @GeneratedValue | The @GeneratedValue annotation specifies that the entity identifier value is automatically generated using an identity column, a database sequence, or a table generator. Hibernate supports the @GeneratedValue mapping even for UUID identifiers. |
| @Type | The @Type annotation is used to specify the Hibernate @Type used by the currently annotated basic attribute. |
| @Column | The @Column annotation is used to specify the mapping between a basic entity attribute and the database table column. |
| @Enumerated | The @Enumerated annotation is used to specify that an entity attribute represents an enumerated type. In which, ORDINAL: stored according to the enum value’s ordinal position within the enum class, as indicated by java.lang.Enum#ordinal STRING: stored according to the enum value’s name, as indicated by java.lang.Enum#name |
| @OneToMany | The @OneToMany annotation is used to specify a one-to-many database relationship. |
| @ManyToOne | The @ManyToOne annotation is used to specify a many-to-one database relationship. |
| @JoinColumn | The @JoinColumn annotation is used to specify the FOREIGN KEY column used when joining an entity association or an embeddable collection. |
| @PrePersist | The @PrePersist annotation is used to specify a callback method that fires before an entity is persisted. |
| @PreUpdate | The @PreUpdate annotation is used to specify a callback method that fires before an entity is updated. |

- [You can find more here](https://docs.jboss.org/hibernate/orm/5.4/userguide/html_single/Hibernate_User_Guide.html#configurations-internal).

- The fist Entity is `CustomerEntity`, this Entity will be the parent of `OrderEntity` and one `CustomerEntity` will have many `OrderEntity`. The `CustomerEntity` java class will look like the code below.

```java

package com.springboot.data.jpa.app.entity;

import com.springboot.data.jpa.app.model.response.CustomerResponse;
import org.hibernate.annotations.Type;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

//The @Entity annotation is used to specify that the currently annotated class represents an entity type. Unlike basic and embeddable types, entity types have an identity and their state is managed by the underlying Persistence Context.
@Entity
//The @Table annotation is used to specify the primary table of the currently annotated entity.
@Table(name = "customers")
public class CustomerEntity {

    //The @Id annotation specifies the entity identifier. An entity must always have an identifier attribute which is used when loading the entity in a given Persistence Context.
    @Id
    //The @GeneratedValue annotation specifies that the entity identifier value is automatically generated using an identity column, a database sequence, or a table generator. Hibernate supports the @GeneratedValue mapping even for UUID identifiers.
    @GeneratedValue
    //The @Type annotation is used to specify the Hibernate @Type used by the currently annotated basic attribute.
    @Type(type="uuid-char")
    private UUID id;
    private String fullName;
    //The @Column annotation is used to specify the mapping between a basic entity attribute and the database table column.
    @Column(unique = true)
    private String email;
    private String address;
    private String phone;
    //The @Enumerated annotation is used to specify that an entity attribute represents an enumerated type.
    @Enumerated(EnumType.STRING)
    private Gender gender;
    private Date dob;

    //The @OneToMany annotation is used to specify a one-to-many database relationship.
    @OneToMany(mappedBy = "customer", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<OrderEntity> orders = new ArrayList<>();

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Gender getGender() {
        return gender;
    }

    public void setGender(Gender gender) {
        this.gender = gender;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public List<OrderEntity> getOrders() {
        return orders;
    }

    public void setOrders(List<OrderEntity> orders) {
        this.orders = orders;
    }
}


```

- Next we will create `OrderEntity`, so this Entity will be the parent of `ItemEntity` and One `OrderEntity` will have many `ItemEntity`. The `OrderEntity` java class will be look like as below

```java

package com.springboot.data.jpa.app.entity;

import com.springboot.data.jpa.app.model.response.OrderResponse;
import org.hibernate.annotations.Type;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Entity
@Table(name = "orders")
public class OrderEntity {

    @Id
    @GeneratedValue
    @Type(type="uuid-char")
    private UUID id;

    private String orderName;

    private LocalDateTime createdDate;

    private LocalDateTime lastUpdatedDate;

    @Enumerated(value = EnumType.STRING)
    private OrderStatus orderStatus;

    //The @ManyToOne annotation is used to specify a many-to-one database relationship.
    @ManyToOne(fetch = FetchType.LAZY)
    //The @JoinColumn annotation is used to specify the FOREIGN KEY column used when joining an entity association or an embeddable collection.
    @JoinColumn(name = "customer_id")
    private CustomerEntity customer;

    @OneToMany(mappedBy = "order", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ItemEntity> items = new ArrayList<>();


    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getOrderName() {
        return orderName;
    }

    public void setOrderName(String orderName) {
        this.orderName = orderName;
    }

    public CustomerEntity getCustomer() {
        return customer;
    }

    public void setCustomer(CustomerEntity customer) {
        this.customer = customer;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    @PrePersist
    private void setCreatedDate() {
        LocalDateTime localDateTime = LocalDateTime.now();
        this.createdDate = localDateTime;
        this.lastUpdatedDate = localDateTime;
    }

    public LocalDateTime getLastUpdatedDate() {
        return lastUpdatedDate;
    }

    @PreUpdate
    private void setLastUpdatedDate() {
        this.lastUpdatedDate = LocalDateTime.now();
    }

    public OrderStatus getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(OrderStatus orderStatus) {
        this.orderStatus = orderStatus;
    }

    public List<ItemEntity> getItems() {
        return items;
    }

    public void setItems(List<ItemEntity> items) {
        this.items = items;
    }

}

```

- Next we will create `ItemEntity`. The `OrderEntity` java class will be look like as below

```java

package com.springboot.data.jpa.app.entity;

import com.springboot.data.jpa.app.model.response.ItemResponse;
import org.hibernate.annotations.Type;

import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import java.util.UUID;

@Entity
@Table(name = "items")
public class ItemEntity {

    @Id
    @GeneratedValue
    @Type(type="uuid-char")
    private UUID id;

    private String itemName;

    private Long quantity;

    private Float price;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_id")
    private OrderEntity order;

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public Long getQuantity() {
        return quantity;
    }

    public void setQuantity(Long quantity) {
        this.quantity = quantity;
    }

    public Float getPrice() {
        return price;
    }

    public void setPrice(Float price) {
        this.price = price;
    }

    public OrderEntity getOrder() {
        return order;
    }

    public void setOrder(OrderEntity order) {
        this.order = order;
    }
}

```

- So that's all for creating Entities and relationships.
