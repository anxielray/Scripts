#!/bin/bash

# Define paths
LOG_FILE="app.log"

# Check if log file exists; create it if not.
if [ ! -f "$LOG_FILE" ]; then
    touch "$LOG_FILE"
fi

# Run the go program in background (to keep terminal free).
go run main.go & pid=$!

# Wait for some time before opening browser (adjust as needed).
sleep 5 # Allow server to start up.

# Open default browser at localhost:port.
xdg-open http://localhost:1919 || xdg-open --new-tab http://localhost:1919 # For Linux systems.

# If there was an error running the go program or opening browser:
if [ $? -ne 0 ]; then
    echo "$(date): Error occurred while running or accessing server." >> $LOG_FILE
fi

# Clean up after closing server manually (optional).
#trap 'kill $pid' EXIT # Kills process when script exits.
