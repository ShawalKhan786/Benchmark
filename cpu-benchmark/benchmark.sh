#!/bin/bash

# Default values
CPU_LOAD=${CPU_LOAD:-4}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default load and duration
stress-ng --cpu $CPU_LOAD --timeout ${DURATION}s

# Send the results to the coordinator
RESULT=$(stress-ng --cpu $CPU_LOAD --timeout ${DURATION}s | tee /result.txt)
COORDINATOR_URL="http://coordinator:8080/upload/cpu"
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
