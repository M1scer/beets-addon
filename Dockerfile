FROM python:3.9-alpine

# Installiere Bash und benötigte Pakete (inklusive libsndfile via apk)
RUN apk add --no-cache bash build-base libffi-dev openssl-dev inotify-tools libsndfile && \
    pip install --no-cache-dir beets pillow && \

    # Installiere bashio
    curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" && \
    mkdir /tmp/bashio && \
    tar zxvf /tmp/bashio.tar.gz --strip 1 -C /tmp/bashio && \
    mv /tmp/bashio/lib /usr/lib/bashio && \
    ln -s /usr/lib/bashio/bashio /usr/bin/bashio && \
    # Bereinige unnötige Dateien
    apk del --no-cache --purge curl tar && \
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
