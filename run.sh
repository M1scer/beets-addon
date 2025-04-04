#!/usr/bin/env bash
set -e

# Read configuration from environment variables provided by Home Assistant Add-On settings
INPUT_DIR="${MUSIC_INPUT_DIR:-/data/input}"
OUTPUT_DIR="${MUSIC_OUTPUT_DIR:-/data/output}"
TIMEOUT="${IMPORT_TIMEOUT:-60}"
BEETS_ARGS="${BEETS_IMPORT_ARGS:---move}"

echo "Starting inotify-based Beets import..."
echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Timeout: ${TIMEOUT} seconds of inactivity before starting the import."
echo "Beets import arguments: ${BEETS_ARGS}"

# Infinite loop that waits for file changes in the input directory
while true; do
  echo "Waiting for file changes in the input directory..."
  # Wait for the first event
  inotifywait -e create -e moved_to -q "$INPUT_DIR"
  echo "File change detected. Starting timeout period to collect additional changes..."

  # Reset timeout timer if new changes are detected within the specified TIMEOUT period
  while inotifywait -t "$TIMEOUT" -e create -e moved_to -q "$INPUT_DIR"; do
    echo "Additional file changes detected, restarting timeout..."
  done

  echo "No changes for ${TIMEOUT} seconds. Starting import..."
  beet import "$INPUT_DIR" ${BEETS_ARGS}
  echo "Import completed."
done
