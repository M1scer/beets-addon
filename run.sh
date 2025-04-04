#!/usr/bin/env bash
echo "----------------------------------------------------------------"
set -euo pipefail

# Graceful shutdown bei SIGINT/SIGTERM
trap 'echo "Shutting down..."; exit 0' SIGINT SIGTERM

# Verzeichnisse festlegen
INPUT_DIR="${MUSIC_INPUT_DIR:-/data/input}"
OUTPUT_DIR="${MUSIC_OUTPUT_DIR:-/data/output}"
CONFIG_DIR="/data/beets"
CONFIG_FILE="${CONFIG_DIR}/config.yaml"

TIMEOUT="${IMPORT_TIMEOUT:-60}"


echo "DEBUG: CONFIG_MUSIC_INPUT_DIR=${CONFIG_MUSIC_INPUT_DIR}"
echo "DEBUG: CONFIG_MUSIC_OUTPUT_DIR=${CONFIG_MUSIC_OUTPUT_DIR}"
echo "DEBUG: CONFIG_IMPORT_TIMEOUT=${CONFIG_IMPORT_TIMEOUT}"


echo "DEBUG: MUSIC_INPUT_DIR=${MUSIC_INPUT_DIR}"
echo "DEBUG: MUSIC_OUTPUT_DIR=${MUSIC_OUTPUT_DIR}"
echo "DEBUG: IMPORT_TIMEOUT=${IMPORT_TIMEOUT}"



# Ersetze den Platzhalter in der Beets-Config
sed -i "s|\${MUSIC_OUTPUT_DIR}|${OUTPUT_DIR}|g" /default_config/config.yaml

# Erstelle benötigte Verzeichnisse, falls sie noch nicht existieren
mkdir -p "$INPUT_DIR" "$OUTPUT_DIR" "$CONFIG_DIR"

# Initialisiere die Konfigurationsdatei, falls nicht vorhanden
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Keine Beets-Konfiguration gefunden in ${CONFIG_FILE}. Kopiere Standardkonfiguration..."
    cp /default_config/config.yaml "$CONFIG_FILE"
fi

echo "Starting inotify-based Beets import..."
echo "Input directory: $INPUT_DIR"
echo "Output directory: $OUTPUT_DIR"
echo "Beets configuration: $CONFIG_FILE"
echo "Timeout: ${TIMEOUT} seconds of inactivity before starting the import."

# Hauptschleife: Überwachung und Import
while true; do
  echo "Waiting for file changes in the input directory..."
  inotifywait -e create -e moved_to -q "$INPUT_DIR"

  echo "File change detected. Starting timeout period to collect additional changes..."
  while inotifywait -t "$TIMEOUT" -e create -e moved_to -q "$INPUT_DIR"; do
    echo "Additional file changes detected, restarting timeout..."
  done

  echo "No changes for ${TIMEOUT} seconds. Starting import..."
  if ! beet --config "$CONFIG_FILE" import "$INPUT_DIR"; then
      echo "Beet import failed. Continuing to watch for changes..."
  else
      echo "Import completed successfully."
  fi
done
