FROM alpine:latest

# Install rclone, inotify-tools, and bash
RUN apk add --no-cache rclone inotify-tools bash

# Create working directory
WORKDIR /app

# Copy the monitor script
COPY monitor.sh /app/monitor.sh
RUN chmod +x /app/monitor.sh

# Set the entrypoint
ENTRYPOINT ["/app/monitor.sh"]
