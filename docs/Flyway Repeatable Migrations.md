---

tags: ["Spring", "SpringData"]

---

# Flyway Repeatable Migrations
## Repeatable Migrations
- `Repeatable migrations` have a `description` and a `checksum`, but `no version`. Instead of being run just once, they are (re-)applied every time their checksum changes.

- This is very useful for managing database objects whose definition can then simply be maintained in a single file in version control. They are typically used for
	- (Re-)creating views/procedures/functions/packages/…
	- Bulk reference data reinserts

- Within a single migration run, repeatable migrations are always applied last, after all pending versioned migrations have been executed. Repeatable migrations are applied in the order of their description.

It is your responsibility to ensure the same repeatable migration can be applied multiple times. This usually involves making use of CREATE OR REPLACE clauses in your DDL statements.

Here is an example of what a repeatable migration looks like:

```sql

CREATE OR REPLACE VIEW blue_cars AS
    SELECT id, license_plate FROM cars WHERE color='blue';
		
```

## See Also
- [[Flyway Versioned Migrations]]
- [[Database Migrations with Flyway]]

## References
- [Flaywaydb.org](https://flywaydb.org/documentation/concepts/migrations)