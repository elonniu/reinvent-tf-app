#!/bin/bash

# Function to start sam local
start_sam() {
    sam local start-api --hook-name terraform &
    SAM_PID=$!
}

# Function to stop sam local
stop_sam() {
    if [ ! -z "$SAM_PID" ]; then
        kill $SAM_PID
        wait $SAM_PID 2>/dev/null
        SAM_PID=""
    fi
}

# Trap SIGINT and SIGTERM to stop sam local before exiting
trap stop_sam SIGINT SIGTERM

# Start sam local initially
start_sam

# Find all relevant files. Adjust the find command to suit your needs.
# This will include all files in the current directory and its subdirectories.
find . -type f | entr -d -p sh -c 'stop_sam; start_sam'

# Stop sam local when the script exits
stop_sam
