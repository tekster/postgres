# Install Oracle client on postgres DB server
# Assure development package is installed with postgres 
sudo apt install postgresql-server-dev-17
# Download and install the FDW extension on the local database host
git clone https://github.com/laurenz/oracle_fdw.git



CREATE EXTENSION oracle_fdw;

CREATE SERVER ora_sv FOREIGN DATA WRAPPER oracle_fdw
OPTIONS (dbserver 'target.c1qctwzslntz.us-west-2.rds.amazonaws.com:1521/orademo');

GRANT USAGE ON FOREIGN SERVER ora_sv TO postgres;

CREATE USER MAPPING FOR CURRENT_USER SERVER oradb OPTIONS (user 'admin', password 'passme326');

\deu+

CREATE FOREIGN TABLE f_ora_tbl(id int OPTIONS (key 'true'), name varchar(64), t_data timestamp) SERVER ora_sv OPTIONS (SCHEMA 'ORA_USER' , TABLE 'ORA_TBL');

# list foreign tables
\det+ 

# select content from foreign table
SELECT * FROM f_ora_tbl;


REF: https://www.oracle.com/database/technologies/instant-client/linux-x86-64-downloads.html
     https://github.com/laurenz/oracle_fdw?tab=readme-ov-file#5-installation-requirements -- Install
     https://www.postgresql.fastware.com/postgresql-insider-fdw-ora-bas
     