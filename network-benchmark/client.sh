#!/bin/bash

# Default values
SERVER_IP=${SERVER_IP:-"network-server"}
DURATION=${DURATION:-60}
COORDINATOR_URL="http://coordinator:8080/upload/network"

# Run iperf3 in client mode
RESULT=$(iperf3 -c $SERVER_IP -t $DURATION)

# Retry loop for sending results to the coordinator
for i in {1..5}; do
    echo "Attempt $i to send results to the coordinator..."
    curl -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL
    if [ $? -eq 0 ]; then
        echo "Successfully sent results to coordinator."
        break
    else
        echo "Failed to send results. Retrying in 5 seconds..."
        sleep 5
    fi
done
