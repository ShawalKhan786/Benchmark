#!/bin/bash

# Default values
CPU_LOAD=${CPU_LOAD:-4}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default load and duration, and capture the output
RESULT=$(stress-ng --cpu $CPU_LOAD --timeout ${DURATION}s --metrics-brief 2>&1)

# Append the duration to the result
RESULT+="\nDuration: ${DURATION}s"

# Save the result to a file (optional, for debugging or persistence)
echo "$RESULT" | tee /result.txt

# Send the results to the coordinator
COORDINATOR_URL="http://coordinator:8080/upload/cpu"
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
