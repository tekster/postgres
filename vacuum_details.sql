## Autovacuum
#  Configured by entries in postgres.Configured

autovacuum = on
track_counts = on  # enables stats collection, on by default

log_autovacuum_min_duration = 600000  # enabled, 10min default
# logs activity over this ms value to be sent to output.log

## Parameters to control vacuum
autovacuum_vacuum_scale_factor = 0.2
autovacuum_vacuum_threshold = 50
autovacuum_analyze_scale_factor = 0.1
autovacuum_analyze_threshold = 50
maintenance_work_mem = 65536 # default 64MB 
autovacuum_work_mem = -1 # vacuum uses maint_work_mem by default

# query showing table row activity
SELECT n_tup_ins as "inserts",n_tup_upd as "updates",n_tup_del as "deletes", n_live_tup as "live_tuples", n_dead_tup as "dead_tuples"
FROM pg_stat_user_tables
WHERE schemaname = 'scott' and relname = 'employee';

# can also be set per table
ALTER TABLE scott.employee SET (autovacuum_vacuum_scale_factor = 0, autovacuum_vacuum_threshold = 100);
# above sets autovacuum to run if >100 records deleted

## controlling vacuum activity

autovacuum_max_workers = 3 # default
autovacuum_vacuum_cost_limit  = -1  #
autovacuum_vacuum_cost_delay = 2 # ms 


ref: https://www.percona.com/blog/tuning-autovacuum-in-postgresql-and-autovacuum-internals/
     https://postgresqlco.nf/doc/en/param/maintenance_work_mem/