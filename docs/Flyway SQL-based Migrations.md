---

tags: ["Spring", "SpringData"]

---

# Flyway SQL-based Migrations
## SQL-based Migrations
- As we read in the section [[Flyway Migrations]], `Migrations` can be written in SQL (PL/SQL, T-SQL, ... is supported) so `Migrations` (Versioned Migration, Undo Migration and Repeatable Migration) are most commonly written in `SQL`. This makes it easy to get started and leverage any existing scripts, tools and skills. It gives you access to the full set of capabilities of your database and eliminates the need to understand any intermediate translation layer.
- SQL-based migrations are typically used for
	- DDL changes (CREATE/ALTER/DROP statements for TABLES,VIEWS,TRIGGERS,SEQUENCES,…)
	- Simple reference data changes (CRUD in reference data tables)
	- Simple bulk data changes (CRUD in regular data tables)

- So to Flyway know which type of `Migrations` (Versioned Migration, Undo Migration and Repeatable Migration) that you are going to use and the SQL files that you created are used for Flyway. So Flyway has naming pattern as below:

### Naming For Regular Versioned Migration
- So to Flyway know that you are using `Regular Versioned Migration`. You have to using the pattern as: `V + (version) + __ + (description) + .sql` . For example

```

V2__Add_new_table.sql

```

- Prefix: `V` for `Versioned Migration` (configurable)
- Version: `Version` with dots or underscores separate as many parts as you like. You can check [[Flyway Versioned Migrations]] for more details.
- Separator: `__` (two underscores) (configurable)
- `Description`: Underscores or spaces separate the words
- Suffix: `.sql` (configurable)
- See [[Flyway Regular Versioned Migration Example]] for more details.

### Naming For Undo Migration
- So to Flyway know that you are using `Undo Migration`. You have to using the pattern as: `U + (version) + __ + (description) + .sql` . For example

```

U2__Add_new_table.sql

```

- Prefix: `U` for `Undo Migration` (configurable)
- Version: `Version` with dots or underscores separate as many parts as you like. You can check [[Flyway Versioned Migrations]] for more details.
- Separator: `__` (two underscores) (configurable)
- `Description`: Underscores or spaces separate the words
- Suffix: `.sql` (configurable)

### Repeatable Migration
- So to Flyway know that you are using `Undo Migration`. You have to using the pattern as: `R + __ + (description) + .sql` . For example

```

R__Add_new_table.sql

```

- Prefix: `R` for `Repeatable Migration` (configurable)
- Separator: `__` (two underscores) (configurable)
- `Description`: Underscores or spaces separate the words
- Suffix: `.sql` (configurable)

## See Also
- [[Flyway Regular Versioned Migration Example]]
- [[Flyway Versioned Migrations]]