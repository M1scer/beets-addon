FROM python:3.9-alpine

# Install Bash and required packages for Beets and inotify-tools
RUN apk add --no-cache bash build-base libffi-dev openssl-dev inotify-tools \
    && pip install --no-cache-dir beets pillow libsndfile

# Create directories that will be mounted by Home Assistant
RUN mkdir -p /data/input /data/output

# Copy the startup script into the image and make it executable
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Define the entry point for the container
CMD ["/run.sh"]
