## Tuning OS Kernel Parameters
#  avoiding key errors such as:

   FATAL: could not create shared memory segment
   FATAL: semget: No space left on device
   FATAL: could not fork new process
   
# Check Shared Memory Maximum Size (single shared memory segment)
# must be at least as large as shared_buffers
sudo sysctl -a | grep -i shmmax

# Check Shared Memory Minimum Size
sudo sysctl -a | grep -i shmmin

# Check Shared Memory Allocation Limit
# combined size of all shared memory segments
sudo sysctl -a | grep -i shmall

# Check Semaphore Set Count Limit
# defines the maximum number of semaphore sets
sudo sysctl -a | grep -i semmni

# Check Total Semaphores Available
# total number of semaphores
sudo sysctl -a | grep -i semmns

# Set shmmax to 16 GB:
sudo sysctl -w kernel.shmmax=17179869184

# set shmall with 4k OS page size
# 16 × 1024 × 1024 × 1024 = 17,179,869,184
sudo sysctl -w kernel.shmall=4194304

# Confirm or set shmmin to 1 (default)
sudo sysctl -w kernel.shmmin=1

# update /etc/sysctl.conf to make changes permanent
kernel.shmmax=17179869184
kernel.shmall=4194304
kernel.shmmin=1

# reload kernel Parameters
sudo sysctl -p

# set semaphore values
sudo sysctl -w kernel.sem="250 32000 100 128"
# update /etc/sysctl.conf to persist changes
kernel.sem=250 32000 100 128

# check ULimit values
ulimit -a

# adjust ulimit (open file limit) larger
ulimit -n 100000

# update default ulimit for postgres user
# in /etc/security/limits.conf
postgres soft nofile 100000
postgres hard nofile 100000


ref: https://medium.com/@jramcloud1/postgresql-17-kernel-tuning-guide-managing-system-parameters-for-optimal-performance-fe097de1dcdb