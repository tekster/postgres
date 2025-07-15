# pbadger
# Install pgbadger
brew install pgbadger
# Verify Install
pgbadger -V
# Find and copy postgresql.log locally
# log_directory in postgresql.conf defines location
sudo cp /var/lib/pgsql/data/log/postgresql-Tue.log .
sudo chown ec2-user:ec2-user postgresql-Tue.log
scp -i ~/.ssh/HomeDemoVPC.pem ec2-user@ec2-44-247-114-120.us-west-2.compute.amazonaws.com:/home/ec2-user/postgresql-Tue.log
# run pgbadger tool on current log
pgbadger postgresql-Tue.log
# open file in browser
file:///Users/robertescamilla/Downloads/out.html



REF: https://pgbadger.darold.net/documentation.html