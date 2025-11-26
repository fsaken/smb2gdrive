# smb2drive

**Author**: Gustavo Maceu
**License**: MIT

This application acts as a simple file server (SMB) to receive scans from a printer and automatically uploads them to Google Drive (Personal or Shared).

## Prerequisites

- Docker and Docker Compose installed on your Linux host.
- A Google account.

## Setup Instructions

### 1. Configure Google Drive Access (Rclone)

You need to generate an `rclone.conf` file with your Google Drive credentials.

1.  **Install rclone** on your local machine (or use a temporary container).
    - Linux: `sudo apt install rclone`
    - Windows: Download from rclone.org
2.  Run `rclone config` in your terminal.
3.  Create a new remote:
    - **Name**: `remote` (This is important, the script expects this name).
    - **Type**: `drive`.
    - Follow the prompts to authenticate with your Google account.
    - **Important for Shared Drives**: When asked if you want to configure this as a Shared Drive (Team Drive), answer **y** (yes) and select the specific Shared Drive you want to use.
4.  Once finished, locate your `rclone.conf` file.
    - Linux: `~/.config/rclone/rclone.conf`
    - Windows: `%APPDATA%/rclone/rclone.conf`
5.  Copy this file to the `config` directory in this project:
    ```bash
    mkdir -p config
    cp /path/to/your/rclone.conf ./config/rclone.conf
    ```

### 2. Start the Application

Run the following command to build and start the services:

```bash
docker-compose up -d --build
```

### 3. Configure Your Printer

1.  Access your printer's web interface or settings.
2.  Set up a new "Scan to Network" or "SMB" destination.
3.  **Host/IP**: The IP address of your Linux host.
4.  **Share Name**: `scans`
5.  **Path**: (Leave empty or use `/`)
6.  **Username**: `guest` (or leave empty if allowed)
7.  **Password**: (Leave empty)

### 4. Verify

1.  Scan a document from your printer.
2.  Check the logs to see the upload progress:
    ```bash
    docker-compose logs -f uploader
    ```
3.  Verify the file appears in your Google Drive in the `Scans` folder.

## Troubleshooting

- **Connection Refused**: Ensure port 445 is not blocked by a firewall on your Linux host.
- **Permission Denied**: The Samba share is configured as public/guest, but some printers require a valid username. You can try using any username/password.
- **File not uploading**: Check the `uploader` logs for rclone errors. Ensure the remote name in `rclone.conf` is `remote`.
