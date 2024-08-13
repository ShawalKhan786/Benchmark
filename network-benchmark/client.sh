#!/bin/bash

# Server IP and test duration
SERVER_IP=${SERVER_IP:-"127.0.0.1"}
DURATION=${DURATION:-60}

# Run iperf3 in client mode to the specified server IP
iperf3 -c $SERVER_IP -t $DURATION
