
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High CPU Load Incident
---

A high CPU load incident occurs when the CPU usage of a host or server exceeds a certain threshold, typically 80%. This can cause slowdowns, unresponsiveness, or even crashes in the affected system. It is critical to address this issue promptly to minimize impact on users and prevent further damage to the system.

### Parameters
```shell
export CONTAINER="PLACEHOLDER"

export INTERVAL="PLACEHOLDER"

export COUNT="PLACEHOLDER"

export COMMAND="PLACEHOLDER"
```

## Debug

### Check overall CPU usage
```shell
top
```

### Check CPU usage per process
```shell
top -c
```

### Sort processes by CPU usage
```shell
ps aux --sort=-%cpu
```

### Show CPU usage in real-time
```shell
mpstat 1
```

### Show CPU usage by container
```shell
docker stats ${CONTAINER}
```

### Check CPU usage over time
```shell
sar -u ${INTERVAL} ${COUNT}
```

### Check CPU usage by interrupt
```shell
cat /proc/interrupts
```

### Check CPU usage by system call
```shell
strace -c ${COMMAND}
```

### A process or application running on the server is consuming too much CPU resources, causing the overall load to increase.
```shell


#!/bin/bash



# get the process with the highest CPU usage

highest_cpu_process=$(ps aux --sort=-%cpu | awk 'NR==2{print $11}')



# get the PID of the process with the highest CPU usage

highest_cpu_pid=$(ps aux --sort=-%cpu | awk 'NR==2{print $2}')



# get the CPU usage of the process with the highest CPU usage

highest_cpu_usage=$(ps aux --sort=-%cpu | awk 'NR==2{print $3}')



echo "The process consuming the most CPU resources is $highest_cpu_process with PID $highest_cpu_pid."

echo "It is currently using $highest_cpu_usage% of the CPU."


```

### The server is running too many applications or services simultaneously, leading to a high overall CPU load.
```shell
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


```

## Repair

### If possible, terminate any unnecessary processes or applications to free up CPU resources.
```shell


#!/bin/bash



# Set the threshold for maximum CPU usage

MAX_CPU_LOAD=80



# Get the current CPU usage

CPU_LOAD=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2+$4}')



# Check if the CPU usage is above the threshold

if [ $CPU_LOAD -gt $MAX_CPU_LOAD ]; then

  echo "High CPU load detected. Terminating unnecessary processes..."



  # Find the top CPU consuming processes

  PROCESSES_TO_KILL=$(ps aux --sort=-%cpu | awk '{if($3>50) print $2}')



  # Terminate the processes

  for PID in $PROCESSES_TO_KILL; do

    kill -9 $PID

  done



  echo "Processes terminated."

else

  echo "CPU load is within normal range."

fi


```