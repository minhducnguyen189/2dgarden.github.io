---

tags: ["Spring", "SpringData"]

---

# Flyway Versioned Migrations
## Regular Versioned Migrations
- The most common type of migration is a `versioned migration`. Each versioned migration has a `version`, a `description` and a `checksum`. The version must be unique. The description is purely informative for you to be able to remember what each migration does. The checksum is there to detect accidental changes. Versioned migrations are applied in order exactly once.
- Versioned migrations are typically used for:
	-   Creating/altering/dropping tables/indexes/foreign keys/enums/UDTs/…
	-   Reference data updates
	-   User data corrections

- See the example below:

```sql

CREATE TABLE car (
    id INT NOT NULL PRIMARY KEY,
    license_plate VARCHAR NOT NULL,
    color VARCHAR NOT NULL
);

ALTER TABLE owner ADD driver_license_id VARCHAR;

INSERT INTO brand (name) VALUES ('DeLorean');

```
- As you can see for versioned migrations, we will use SQL commands as `CREATE`, `ALTER` and `INSERT`. 
- Each versioned migration must be assigned a `unique version`. Any version is valid as long as it conforms to the usual dotted notation. For most cases a simple increasing integer should be all you need. However Flyway is quite flexible and all these versions are valid versioned migration versions:

```text
1
001
5.2
1.2.3.4.5.6.7.8.9
205.68
20130115113556
2013.1.15.11.35.56
2013.01.15.11.35.56

```

- Versioned migrations are applied in the order of their versions. Versions are sorted numerically as you would normally expect.
- See [[Flyway Regular Versioned Migration Example]]

## Undo Migrations
- `Undo migrations` are the opposite of `regular versioned migrations`. An undo migration is responsible for undoing the effects of the versioned migration with the same version. Undo migrations are optional and not required to run regular versioned migrations.

For the example above, this is how the undo migration would look like:

```sql

DELETE FROM brand WHERE name='DeLorean';

ALTER TABLE owner DROP driver_license_id;

DROP TABLE car;

```

> it's important to note that **Flyway Undo is a commercial feature of Flyway and isn't available in the Community Edition.** Therefore, we'll need either the Pro Edition or Enterprise Edition in order to use this feature.

## See Also
- [[Flyway Regular Versioned Migration Example]]
- [[Flyway Migrations]]

## References
- [Flaywaydb.org](https://flywaydb.org/documentation/concepts/migrations)