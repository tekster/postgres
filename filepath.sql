\echo $PGDATA is the base
\echo base/ is the subdir within $base
\echo database_oid/ each database has object id
\echo filenode_id - individual filenode number
\echo non-default tablespace changes this to
\echo pg_tblspc/tablespace_oid/tablespace_version_subdir/database_oid/filenode_id

SHOW data_directory;

create table if not exists disco as select current_timestamp;

SELECT pg_relation_filepath('disco');
