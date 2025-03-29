#!/bin/bash

# Function to display usage information
usage() {
  echo "Usage: $0 <filename_extension>"
  echo "filename_extension should be one of: go, py, js"
  exit 1
}

# Check if exactly one argument is provided
if [ "$#" -ne 1 ]; then
  usage
fi

# Set the file extension and validate it
EXT=$1
case $EXT in
  go)
    FILE="log.go"
    ;;
  py)
    FILE="log.py"
    ;;
  js)
    FILE="log.js"
    ;;
  *)
    usage
    ;;
esac

# Create the APP_LOGS directory if it doesn't exist
mkdir -p APP_LOGS

# Create the log file within the APP_LOGS directory
touch "APP_LOGS/$FILE"

# Function to generate Go logging code
generate_go_log() {
  cat <<EOF > "APP_LOGS/$FILE"
package main

import (
  "log"
  "os"
)

var logger *log.Logger

func init() {
  file, err := os.OpenFile("app.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
  if err != nil {
    log.Fatal(err)
  }
  logger = log.New(file, "", log.LstdFlags)
}

func logError(functionName string, err error) {
  logger.Printf("[ERROR] |%s| ----> %v", functionName, err)
}

func logSuccess(message string) {
  logger.Printf("[SUCCESS] ----> %s", message)
}
EOF
}

# Function to generate Python logging code
generate_py_log() {
  cat <<EOF > "APP_LOGS/$FILE"
import logging

logging.basicConfig(filename='app.log', level=logging.DEBUG,
                    format='%(asctime)s - %(levelname)s - %(message)s')

def log_error(function_name, error):
    logging.error(f'[ERROR] |{function_name}| ----> {error}')

def log_success(message):
    logging.info(f'[SUCCESS] ----> {message}')
EOF
}

# Function to generate JavaScript logging code
generate_js_log() {
  cat <<EOF > "APP_LOGS/$FILE"
const fs = require('fs');

const logStream = fs.createWriteStream('app.log', { flags: 'a' });

function logError(functionName, error) {
  logStream.write(\`[ERROR] |${functionName}| ----> \${error}\n\`);
}

function logSuccess(message) {
  logStream.write(\`[SUCCESS] ----> \${message}\n\`);
}

module.exports = { logError, logSuccess };
EOF
}

# Generate the appropriate log file based on the extension
case $EXT in
  go)
    generate_go_log
    ;;
  py)
    generate_py_log
    ;;
  js)
    generate_js_log
    ;;
esac

# Display instructions for using the generated log file
echo "The log file 'APP_LOGS/$FILE' has been created."
case $EXT in
  go)
    echo "To use the logger in your Go functions:"
    echo "1. Import the log package and the generated logger file."
    echo "2. Initialize the logger by calling the init() function."
    echo "3. Use logError(functionName, error) to log errors."
    echo "4. Use logSuccess(message) to log success messages."
    ;;
  py)
    echo "To use the logger in your Python functions:"
    echo "1. Import the logging module and the generated logger functions."
    echo "2. Call log_error(function_name, error) to log errors."
    echo "3. Call log_success(message) to log success messages."
    ;;
  js)
    echo "To use the logger in your JavaScript functions:"
    echo "1. Require the generated logger module."
    echo "2. Use logError(functionName, error) to log errors."
    echo "3. Use logSuccess(message) to log success messages."
    ;;
esac
