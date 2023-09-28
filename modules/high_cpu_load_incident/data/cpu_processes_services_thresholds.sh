bash

#!/bin/bash



# Check current CPU usage

cpu_usage=$(top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}')



# Check number of running processes

num_processes=$(ps -e | wc -l)



# Check number of running services

num_services=$(systemctl list-units --type=service --state=running | wc -l)



# Set threshold values for CPU usage, number of processes, and number of services

cpu_threshold=80

process_threshold=500

service_threshold=50



# Check if CPU usage is above threshold

if [ $(echo "$cpu_usage > $cpu_threshold" | bc) -ne 0 ]; then

  echo "High CPU usage detected. Current usage: $cpu_usage%"

fi



# Check if number of processes is above threshold

if [ $num_processes -gt $process_threshold ]; then

  echo "Too many processes running. Current count: $num_processes"

fi



# Check if number of services is above threshold

if [ $num_services -gt $service_threshold ]; then

  echo "Too many services running. Current count: $num_services"

fi