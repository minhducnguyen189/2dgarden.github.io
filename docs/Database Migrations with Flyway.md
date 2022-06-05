---

tags: ["Spring", "SpringData"]

---

# Database Migrations with Flyway
## What Is The FlyWay?
- `Flyway` is an open-source database migration tool. It strongly favors simplicity and convention over configuration.
- `Migrations` can be written in SQL (PL/SQL, T-SQL, ... is supported) or in Java for advanced data transformations.
- [More Information](https://flywaydb.org/documentation/)
- With `Flyway` all changes to the database are called **migrations**. Migrations can be either `versioned` or `repeatable`. Versioned migrations come in 2 forms: regular and undo.

## Why Flyway?
- So, why do we need to use flyway? let's image that you are developing an application on DEV environment, then you need to deploy your application on TEST environment. On DEV environment you know that your application with version 1.0 will work perfectly and ready for testing. However, on DEV you are testing your application with version 2.0 and the table structures in the database of this version is quite different with the version 1.0. So you have to find a way to prepare the correct table structures of version 1.0 for the TEST environment.
	- You have to trace back the source code or recheck the US to find what is the correct table structures when you worked with version 1.0.
	- When you have the correct tables structures, you have to go to TEST database and use SQL scripts to initialize tables.
	- If you don't note what did you do so in future you can forget or other teammates or other new member will not know  what SQL scripts of table structures that you applied into TEST database, version 1.0 or 1.1 or 1.2..etc?
	- It is hard for you to maintain table structures of database following versions of your application.
	- If you checkout another version of your source code and you do some test and got errors. You will usually received the question like this: What state is the database in this machine?
	
- So Database Migrations with Flyway will be a great way to control your database. With flyway, you can:
	- Recreate a database from scratch.
	- Make it clear at all times what state a database is in.
	- Migrate in a deterministic way from your current version of the database to a newer one.


## Flyway In Details
- [[Flyway Migrations]]
	- [[Flyway Versioned Migrations]]
		- [[Flyway Regular Versioned Migration Example]]
	- [[Flyway Repeatable Migrations]]
	- [[Flyway SQL-based Migrations]]

## References
- [Flaywaydb.org](https://flywaydb.org/documentation/concepts/migrations)
