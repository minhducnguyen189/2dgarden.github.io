---

tags: ["Spring", "SpringData"]

---

# Flyway Migrations
## Migrations
- With `Flyway` all changes to the database are called `migrations`. `Migrations` can be either `versioned` or `repeatable`. `Versioned migrations` come in 2 forms: `regular` and `undo`.
- [[Flyway Versioned Migrations]] have a `version`, a `description` and a `checksum`. The version must be unique. The description is purely informative for you to be able to remember what each migration does. The checksum is there to detect accidental changes. Versioned migrations are `the most common type of migration`. They are applied in order exactly once.
- Optionally their effect can be undone by supplying an [[Flyway Versioned Migrations | undo migration]]  with the same version.

- [[Flyway Repeatable Migrations]] have a `description` and a `checksum`, but no version. Instead of being run just once, they are (re-)applied every time their checksum changes.
- Within a single migration run, repeatable migrations are always applied last, after all pending versioned migrations have been executed. Repeatable migrations are applied in the order of their description.
- By default both `versioned` and `repeatable migrations` can be written either in SQL (see [[Flyway SQL-based Migrations]]) or in Java and can consist of multiple statements.

- Flyway automatically discovers migrations on the `filesystem` and on the Java `classpath`.
- To keep track of which migrations have already been applied when and by whom, Flyway adds a `schema history table` to your schema.

- [More information](https://flywaydb.org/documentation/concepts/migrations)

## See Also
- [[Flyway Versioned Migrations]]
- [[Flyway Repeatable Migrations]]
- [[Flyway SQL-based Migrations]]
- [[Database Migrations with Flyway]]

## References
- [Flywaydb.org](https://flywaydb.org/documentation/concepts/migrations)