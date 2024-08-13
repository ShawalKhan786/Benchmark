#!/bin/bash

# Default memory load is 512M, for 60 seconds
MEMORY_LOAD=${MEMORY_LOAD:-512M}
DURATION=${DURATION:-60}

# Run stress-ng with the specified or default memory load and duration
stress-ng --vm 1 --vm-bytes $MEMORY_LOAD --timeout ${DURATION}s
