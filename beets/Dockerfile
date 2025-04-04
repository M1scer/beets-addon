FROM python:3.9-alpine

# Install required packages for building, beets and inotify-tools
RUN apk add --no-cache build-base libffi-dev openssl-dev inotify-tools

# Install beets
RUN pip install --no-cache-dir beets

# Create directories that will be mounted by Home Assistant
RUN mkdir -p /data/input /data/output

# Copy the startup script into the image
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
