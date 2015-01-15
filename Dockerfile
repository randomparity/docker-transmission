FROM randomparity/docker-supervisor:latest

MAINTAINER David Christensen <randomparity@gmail.com>

ENV LAST_UPDATE_TRANSMISSION 2015-01-14

# We depend on the FROM container to have the relevant updates
# installed thus we don't take care of that here.

# Add the Transmission repository and install the transmission application
RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get -q update && \
    apt-get -qy install transmission-daemon

# Clean-up any unneeded files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/*

VOLUME ["/config", "/download"]

# Used by transmission daemon to set default configuration data location
ENV TRANSMISSION_HOME /config

EXPOSE 9091 51413

# Copy the supervisord configuration files into the container
COPY transmission.conf /etc/supervisor/conf.d/transmission.conf
COPY cron.conf /etc/supervisor/conf.d/cron.conf

# Copy the torrent scan script into the container and make it executable
COPY torrent-scan.sh /bin/torrent-scan.sh
RUN chmod +x /bin/torrent-scan.sh

# Copy and install the torrent scanning crontab entry
COPY torrent-crontab /root/torrent-crontab
RUN /usr/bin/crontab /root/torrent-crontab

# No need to setup a CMD directive since that was handled in the FROM image.
