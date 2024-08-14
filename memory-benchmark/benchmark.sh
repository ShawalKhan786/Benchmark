#!/bin/bash

# Default values
MEMORY_LOAD=${MEMORY_LOAD:-512M}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default memory load and duration
stress-ng --vm 1 --vm-bytes $MEMORY_LOAD --timeout ${DURATION}s

# Send the results to the coordinator
RESULT=$(stress-ng --vm 1 --vm-bytes $MEMORY_LOAD --timeout ${DURATION}s | tee /result.txt)
COORDINATOR_URL="http://coordinator:8080/upload/memory"
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
