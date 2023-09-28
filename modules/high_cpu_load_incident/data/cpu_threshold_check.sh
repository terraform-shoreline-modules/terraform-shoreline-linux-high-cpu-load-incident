

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