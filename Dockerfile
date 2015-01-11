FROM ubuntu:trusty

MAINTAINER David Christensen <randomparity@gmail.com>

# Remove error messages like "debconf: unable to initialize frontend: Dialog":
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Fetch/install latest updates and install "add-apt-repository"
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common 

# Add the Transmission repository and install the application
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

USER sysadmin

# Run Transmission in the foreground, as "sysadmin", with the following defaults
CMD [ "--allowed", "127.*,10.*,192.168.*,172.16.*,172.17.*,172.18.*,172.19.*,172.20.*,172.21.*,172.22.*,172.23.*,172.24.*,172.25.*,172.26.*,172.27.*,172.28.*,172.29.*,172.30.*,172.31.*,169.254.*", "-c", "/download/Watch", "--encryption-preferred", "--foreground", "--config-dir", "/config", "--incomplete-dir", "/download/Working", "--dht", "--no-auth", "--download-dir", "/download/Complete" ]
ENTRYPOINT ["/usr/bin/transmission-daemon"]
