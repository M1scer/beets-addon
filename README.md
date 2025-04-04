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

- `/mnt/data/addons/config/beets` → `/config`
- `/mnt/data/media` → `/music`

### Web UI
After installation, you can access Beets at the following URL:  
`http://[HOST]:8337`

Replace `[HOST]` with the actual IP address or domain name of your Home Assistant instance. This gives you the URL to access Beets' Web UI, e.g., `http://192.168.1.100:8337`.
