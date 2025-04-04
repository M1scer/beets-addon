FROM python:3.9-alpine

# Installiere Bash, benötigte Pakete, curl und jq
RUN apk add --no-cache bash build-base libffi-dev openssl-dev inotify-tools libsndfile curl jq tar && \
    pip install --no-cache-dir beets pillow && \
    # Installiere bashio
    echo "Installing bashio..." && \
    curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/v0.16.3.tar.gz" && \
    # Überprüfe, ob der Download erfolgreich war
    if [ ! -f /tmp/bashio.tar.gz ]; then echo "bashio download failed"; exit 1; fi && \
    mkdir /tmp/bashio && \
    tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio && \
    # Bereinige unnötige Dateien ohne curl, jq und tar zu löschen
    rm -f -r /tmp/*

# Kopiere den Ordner mit der Standard-Konfiguration ins Image
COPY default_config/config.yaml /default_config/config.yaml

# Erstelle persistente Verzeichnisse (diese werden später von Home Assistant gemountet)
RUN mkdir -p /data/input /data/output /data/beets

# Kopiere das Startskript in das Image und mache es ausführbar
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Definiere den Entry Point für den Container
CMD ["/run.sh"]
