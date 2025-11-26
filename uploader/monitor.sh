#!/bin/bash

WATCH_DIR="/data"
REMOTE_NAME="remote" # Matches the name in rclone.conf
#REMOTE_DIR="${DRIVE_FOLDER:-Scans}"

echo "Starting Scan-to-Drive Monitor..."
echo "Watching directory: $WATCH_DIR"
echo "Target: $REMOTE_NAME:$REMOTE_DIR"

# Ensure rclone config exists
if [ ! -f /root/.config/rclone/rclone.conf ]; then
    echo "ERROR: rclone.conf not found at /root/.config/rclone/rclone.conf"
    echo "Please mount your rclone.conf file."
    exit 1
fi

# Watch for new files (CLOSE_WRITE ensures file is fully written, MOVED_TO for moves)
inotifywait -m -e close_write -e moved_to --format '%f' "$WATCH_DIR" | while read FILENAME
do
    echo "Detected new file: $FILENAME"
    
    # Wait a brief moment to ensure file lock is released if needed
    sleep 2
    
    FILEPATH="$WATCH_DIR/$FILENAME"
    
    if [ -f "$FILEPATH" ]; then
        echo "Uploading $FILENAME to Google Drive..."
        
        # Move the file to Google Drive (upload and delete from local)
        rclone move "$FILEPATH" "$REMOTE_NAME" --log-level INFO
        
        if [ $? -eq 0 ]; then
            echo "Successfully uploaded and removed: $FILENAME"
        else
            echo "Failed to upload: $FILENAME"
        fi
    fi
done
