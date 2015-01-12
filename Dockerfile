FROM ubuntu:trusty

MAINTAINER David Christensen <randomparity@gmail.com>

# Remove error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Fetch/install latest updates and install needed tools
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common supervisor

# Add the Transmission repository and install the transmission application
RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get update && \
    apt-get install -y transmission-daemon

# Clean-up any unneeded files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

VOLUME ["/config"]
VOLUME ["/download"]

ENV TRANSMISSION_HOME /config

EXPOSE 9091
EXPOSE 51413

# Copy the supervisord configuration file into the container
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy the torrent scan script into the container and make it executable
COPY torrent-scan.sh /
RUN chmod +x /torrent-scan.sh

# Copy and install the torrent scanning crontab entry
COPY torrent-crontab /
RUN /usr/bin/crontab /torrent-crontab

# Run Supervisord in the foreground as "sysadmin"
CMD [ "/usr/bin/supervisord" ]
