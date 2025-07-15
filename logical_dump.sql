ssh -i "HomeDemoVPC.pem" ec2-user@ec2-44-247-114-120.us-west-2.compute.amazonaws.com

# pg_dump man https://www.postgresql.org/docs/current/app-pgdump.html

# Prior to using pg_dumpall, create local password file
# vi ~/.pgpass
# localhost:5432:postgres:postgres:passme326
# chmod 0600 ~/.pgpass
$ psql -h localhost -U postgres

## PG_DUMPALL is used for full logical dump of database

which pg_dumpall

$ pg_dumpall -h localhost -U postgres -W -f entire_database.sql
$ head -n 10 entire_database.sql

# Restore of single object not possible without extraction

## PG_DUMP can export in compressed mode:

$ pg_dump -h localhost -U postgres -W -Fc postgres > postgres_dump.dump

$ pg_dump -h localhost -U postgres -W -f entire_database.sql
$ head -n 10 db_backup.sql

## Restore Table Example
# must be completed in 2 steps, DDL then Data

$ psql -h localhost -U postgres
$ drop table public.users;
$ pg_restore -h localhost -U postgres --schema-only -d postgres -t users postgres_dump.dump
$ pg_restore -h localhost -U postgres --data-only -d postgres -t users postgres_dump.dump
