# Beets Music Organizer Home Assistant Add-On

This add-on uses [beets](https://beets.io) to organize music files and enrich their metadata.

## Installation

1. Upload this repository to GitHub.
2. In Home Assistant, add the repository URL under *Supervisor → Add-On Store → Add-on Repository*.
3. Install the add-on from the Home Assistant Add-On Store.
4. In the add-on settings, configure the following options:
   - `music_input_dir`: Path to the directory where music files are stored.
   - `music_output_dir`: Path to the directory where files will be moved and sorted.
   - `import_timeout`: Time in seconds to wait for additional file changes before triggering the import.
   - `beets_import_args`: Additional arguments to pass to the beets import command (e.g., "--move").
5. Start the add-on.

## How It Works

Upon starting, the add-on:
- Waits for file changes in the configured input directory using `inotifywait`.
- Starts a timeout period (default: 60 seconds) to collect additional changes.
- Once no changes are detected within the timeout period, it triggers beets to import, enrich metadata, and move the files using the configured import arguments.
- Files are organized based on the beets configuration (e.g., sorted by artist).

## Customization

To customize further (e.g., additional beets options, plugins, or functionality), adjust the commands in `run.sh`.
