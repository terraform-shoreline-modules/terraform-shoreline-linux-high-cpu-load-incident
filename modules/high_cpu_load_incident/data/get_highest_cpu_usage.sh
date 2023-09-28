

#!/bin/bash



# get the process with the highest CPU usage

highest_cpu_process=$(ps aux --sort=-%cpu | awk 'NR==2{print $11}')



# get the PID of the process with the highest CPU usage

highest_cpu_pid=$(ps aux --sort=-%cpu | awk 'NR==2{print $2}')



# get the CPU usage of the process with the highest CPU usage

highest_cpu_usage=$(ps aux --sort=-%cpu | awk 'NR==2{print $3}')



echo "The process consuming the most CPU resources is $highest_cpu_process with PID $highest_cpu_pid."

echo "It is currently using $highest_cpu_usage% of the CPU."