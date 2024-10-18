#!/bin/bash

# Default values
MEMORY_LOAD=${MEMORY_LOAD:-512M}
DURATION=${DURATION:-60}
INTERVAL=${INTERVAL:-1}  # Interval to capture memory usage (in seconds)

# Prepare to store memory usage data over time
MEMORY_USAGE_OVER_TIME=""

# Start the benchmark and capture the memory usage over time
# Run stress-ng in the background
stress-ng --vm 1 --vm-bytes $MEMORY_LOAD --timeout ${DURATION}s &

# Get the PID of the stress-ng process
STRESS_NG_PID=$!

# Capture memory usage over time
for ((i = 0; i < DURATION; i += INTERVAL)); do
    # Get the current memory usage
    CURRENT_MEMORY=$(free -m | grep Mem | awk '{print $3}')
    MEMORY_USAGE_OVER_TIME+="\nTime: ${i}s, Memory Usage: ${CURRENT_MEMORY} MB"
    sleep $INTERVAL
done

# Wait for stress-ng to finish
wait $STRESS_NG_PID

# Append the memory load, duration, and memory usage over time to the result
RESULT="Memory Load: ${MEMORY_LOAD} \nDuration: ${DURATION}s \nMemory Usage Over Time:${MEMORY_USAGE_OVER_TIME}"

# Save the result to a file (optional, for debugging or persistence)
echo "$RESULT" | tee /result.txt

# Record the timestamp before sending the result
START_TIME=$(date +%s%N)

# Send the results to the coordinator
COORDINATOR_URL="http://coordinator:8080/upload/memory"
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL

# Record the timestamp after sending the result
END_TIME=$(date +%s%N)

# Calculate the communication time in milliseconds
COMMUNICATION_TIME=$(( (END_TIME - START_TIME) / 1000000 ))

# Append the communication time to the result
RESULT+="\nCommunication Time Between Containers: ${COMMUNICATION_TIME} ms"

# Output the communication time
echo "Communication Time Between Containers: ${COMMUNICATION_TIME} ms"

# Save the result with communication time to a file (optional, for debugging or persistence)
echo "$RESULT" | tee /result_with_communication_time.txt

# Send the results with communication time to the coordinator (optional, if needed)
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
