#!/bin/bash

# Default values
MEMORY_LOAD=${MEMORY_LOAD:-512M}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default memory load and duration, and capture the output
RESULT=$(stress-ng --vm 1 --vm-bytes $MEMORY_LOAD --timeout ${DURATION}s 2>&1)
# Append the duration to the result
RESULT+="\nMemory Load: ${MEMORY_LOAD} \nDuration: ${DURATION}s"
# Save the result to a file (optional, for debugging)
echo "$RESULT" | tee /result.txt

# Send the results to the coordinator
COORDINATOR_URL="http://coordinator:8080/upload/memory"
curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
