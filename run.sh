#!/usr/bin/env bash
set -euo pipefail

# Graceful shutdown bei SIGINT/SIGTERM
trap 'echo "Shutting down..."; exit 0' SIGINT SIGTERM

# Konfiguration: Umgebungsvariablen lesen, oder Default-Werte nutzen
INPUT_DIR="${MUSIC_INPUT_DIR:-/media/input}"
OUTPUT_DIR="${MUSIC_OUTPUT_DIR:-/media/output}"
TIMEOUT="${IMPORT_TIMEOUT:-60}"
BEETS_ARGS="${BEETS_IMPORT_ARGS:---move}"

# Sicherstellen, dass die benötigten Verzeichnisse existieren
mkdir -p "$INPUT_DIR" "$OUTPUT_DIR"

echo "Starting inotify-based Beets import..."
echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Timeout: ${TIMEOUT} seconds of inactivity before starting the import."
echo "Beets import arguments: ${BEETS_ARGS}"

# Hauptschleife: Überwachung und Import
while true; do
  echo "Waiting for file changes in the input directory..."
  # Warte auf das erste Ereignis
  inotifywait -e create -e moved_to -q "$INPUT_DIR"

  echo "File change detected. Starting timeout period to collect additional changes..."
  # Solange innerhalb des TIMEOUT-Intervalls weitere Änderungen eintreten, wird der Timer zurückgesetzt
  while inotifywait -t "$TIMEOUT" -e create -e moved_to -q "$INPUT_DIR"; do
    echo "Additional file changes detected, restarting timeout..."
  done

  echo "No changes for ${TIMEOUT} seconds. Starting import..."
  # Führe den Import aus und behandle eventuelle Fehler, ohne die Überwachung zu beenden
  if ! beet import "$INPUT_DIR" ${BEETS_ARGS}; then
      echo "Beet import failed. Continuing to watch for changes..."
  else
      echo "Import completed successfully."
  fi
done
