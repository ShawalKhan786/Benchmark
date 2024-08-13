#!/bin/bash

# Default CPU load is 4 cores, for 60 seconds
CPU_LOAD=${CPU_LOAD:-4}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default load and duration
stress-ng --cpu $CPU_LOAD --timeout ${DURATION}s
