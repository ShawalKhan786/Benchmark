#!/bin/bash

# Default values
SERVER_IP=${SERVER_IP:-"network-server"}
DURATION=${DURATION:-60}
BANDWIDTH=${BANDWIDTH:-150M}
COORDINATOR_URL="http://coordinator:8080/upload/network"

# Check for required commands
for cmd in ping iperf3 curl; do
    if ! command -v $cmd &> /dev/null; then
        echo "Error: $cmd is not installed."
        exit 1
    fi
done

# Measure latency using ping
PING_OUTPUT=$(ping -c 1 $SERVER_IP 2>/dev/null)
echo "Ping output: $PING_OUTPUT"  # Debug output
if [ $? -eq 0 ]; then
    LATENCY=$(echo "$PING_OUTPUT" | grep 'time=' | awk -F 'time=' '{print $2}' | awk '{print $1}' | sed 's/ms//')
else
    LATENCY="Ping failed"
fi
echo "Extracted latency: $LATENCY"  # Debug output

# Run iperf3 in client mode and capture output
IPERF_RESULT=$(iperf3 -c $SERVER_IP -t $DURATION -b $BANDWIDTH 2>&1)
IPERF_EXIT_CODE=$?

# Format the iperf3 result
if [ $IPERF_EXIT_CODE -ne 0 ]; then
    IPERF_RESULT="iperf3 failed with exit code $IPERF_EXIT_CODE. Output:\n$IPERF_RESULT"
fi

# Combine latency and iperf3 result
RESULT="Latency: ${LATENCY} ms\niperf3 Results:\n$IPERF_RESULT\nDuration: ${DURATION}s"

# Retry loop for sending results to the coordinator
for i in {1..5}; do
    echo "Attempt $i to send results to the coordinator..."
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" -X POST -H "Content-Type: text/plain" --data-binary "$RESULT" $COORDINATOR_URL)
    if [ "$RESPONSE" -eq 200 ]; then
        echo "Successfully sent results to coordinator."
        break
    else
        echo "Failed to send results. HTTP status code: $RESPONSE. Retrying in 5 seconds..."
        sleep 5
    fi
done
