\echo create automated partitioned tables
\echo requires CREATE EXTENSION pg_partman
\echo and CREATE EXTENSION pg_cron
# https://github.com/pgpartman/pg_partman
# https://www.percona.com/blog/postgresql-partitioning-made-easy-using-pg_partman-timebased/
# https://neon.com/docs/extensions/pg_partman

# config-file = /etc/postgresql/17/main/postgresql.conf
# shared_preload_libraries = 'pg_partman_bgw'

cd /home/rescamil/Source
git clone https://github.com/pgpartman/pg_partman
cd pg_partman
make install
/usr/lib/postgresql/17/bin/postgres --config-file=/etc/postgresql/17/main/postgresql.conf
$ \dx
$ CREATE EXTENSION pg_partman;
$ \dx

CREATE TABLE user_activities (
    activity_id serial,
    activity_time TIMESTAMPTZ NOT NULL,
    activity_type TEXT NOT NULL,
    content_id INT NOT NULL,
    user_id INT NOT NULL
)
PARTITION BY RANGE (activity_time);

# create partition for each week of activity
SELECT create_parent('public.user_activities', 'activity_time', '1 week');

SELECT pg_relation_filepath('user_activities');
SELECT pg_relation_filepath('user_activities_default');
SELECT pg_relation_filepath('user_activities_p20250730');

insert into user_activities (activity_time, activity_type, content_id, user_id) values (current_timestamp, 'quick brown fox', 1, 1);
select count(1) from user_activities_p20250709;


## detach partitions based on bgw 
UPDATE part_config
SET retention = '4 weeks', retention_keep_table = true
WHERE parent_table = 'public.user_activities';

$ DROP EXTENSION pg_partman;