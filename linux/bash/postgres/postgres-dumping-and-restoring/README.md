# Dumping and restoring PostgreSQL data

## What can you find here?
* Script for [dumping postgres data](dump-postgres-data-with-schema.sh)
  * Dumps data from a postgres instance (database) with the schema
* Script for [restoring postgres data](restore-postgres-dump-with-schema.sh)
  * Restores the data from a `.tar` file into the database
  * Drops all database objects from the database before importing the data from the dump
  * use `dump-postgres-data-with-schema.sh` (see [dumping postgres data](dump-postgres-data-with-schema.sh)) to dump data for full compatibility