# pg_backrest is a good alternative to manual standby replication (linked below)

## Create password less authentication at postgres user level
#  on both primary and replica hosts
# verify /etc/ssh/sshd_config has PasswordAuthentication = no
sudo su - postgres
ssh-keygen 
ssh-copy-id <username>@<server_ip> 
  or manually add id_rsa.pub to ~/.ssh/authorized_keys

# Review Changes in Primary postgresql.conf
listen_addresses = '*'
archive_mode = on
max_wal_senders = 5 
max_wal_size = 10GB    
wal_level = replica
hot_standby = on   
archive_command = 'rsync -a %p /opt/pg_archives/%f'
restore_command = 'rsync -a  postgres@44.247.114.120:/opt/pg_archives/%f %p' 

# Review Changes in Replica postgresql.conf
recovery_target_timeline = 'latest'




# create /opt/pg_archives with postgres:postgres permissions
# verify changes in pg_hba.conf
host    replication all   192.168.57.102/32   trust   #-- IP address of replica

# prepare replica host with new binaries and create new initdb
su postgres
initdb -D /var/lib/pgsql/data/

# create backup of primary on replica
pg_basebackup -D /var/lib/pgsql/data/ -h 44.247.114.120 -p 5432 -Xs -R -P

# Create empty standby.signal file
touch /var/lib/pgsql/data/standby.signal

# Restart databases and verify replication state on primary
systemctl start postgresql.service
primary$ select * from pg_stat_replication;
replica$ select * from pg_stat_wal_receiver ;




REF:  https://pgbackrest.org/user-guide.html#installation
      https://www.enterprisedb.com/blog/how-set-streaming-replication-keep-your-postgresql-database-performant-and-date