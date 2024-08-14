#!/bin/bash

# Default values
PORT=${PORT:-5201}

# Run iperf3 in server mode
iperf3 -s -p $PORT
