# Beets Music Organizer Add-on

This is a custom Home Assistant add-on for **Beets**, a tool to organize and tag your music collection.

## Installation

1. Clone or download this repository to your Home Assistant instance.
2. Navigate to the **Add-on Store** in Home Assistant.
3. Click on **"Add Repository"**.
4. Enter the URL of this repository and click **Add**.
5. Install the **Beets** add-on from the store.

## Configuration

### Volumes
The following directories will be mapped to the container:

- `/mnt/data/beets/config` → `/config`
- `/mnt/data/music` → `/music`
- `/mnt/data/ingest` → `/downloads`

### Web UI
After installation, you can access Beets at the following URL:  
`http://[HOST]:8337`
