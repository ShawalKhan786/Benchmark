#!/bin/bash

# Default values
CPU_LOAD=${CPU_LOAD:-4}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default load and duration, and capture the output
RESULT=$(stress-ng --cpu $CPU_LOAD --timeout ${DURATION}s --metrics-brief 2>&1)

# Append the duration to the result
RESULT+="Duration: ${DURATION}s"

# Save the result to a file (optional, for debugging or persistence)
echo "$RESULT" | tee /result.txt

# Record the timestamp before sending the result
START_TIME=$(date +%s%N)

# Send the results to the coordinator
COORDINATOR_URL="http://coordinator:8080/upload/cpu"
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL

# Record the timestamp after sending the result
END_TIME=$(date +%s%N)

# Calculate the communication time in milliseconds
COMMUNICATION_TIME=$(( (END_TIME - START_TIME) / 1000000 ))

# Append the communication time to the result
RESULT+=" \nCommunication Time Between Containers: ${COMMUNICATION_TIME} ms"

# Output the communication time
echo "Communication Time Between Containers: ${COMMUNICATION_TIME} ms"

# Save the result with communication time to a file (optional, for debugging or persistence)
echo "$RESULT" | tee /result_with_communication_time.txt

# Send the results with communication time to the coordinator (optional, if needed)
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
