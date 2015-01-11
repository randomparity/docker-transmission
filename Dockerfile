FROM ubuntu:trusty

MAINTAINER David Christensen <randomparity@gmail.com>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common 

RUN add-apt-repository -y ppa:transmissionbt/ppa && \
    apt-get update && \
    apt-get install -y transmission-daemon

VOLUME ["/config"]
VOLUME ["/download"]

ENV TRANSMISSION_HOME /config

EXPOSE 9091
EXPOSE 12345

USER sysadmin

CMD [ "--allowed", "127.*,10.*,192.168.*,172.16.*,172.17.*,172.18.*,172.19.*,172.20.*,172.21.*,172.22.*,172.23.*,172.24.*,172.25.*,172.26.*,172.27.*,172.28.*,172.29.*,172.30.*,172.31.*,169.254.*", "--watch-dir", "/download/Watch", "--encryption-preferred", "--foreground", "--config-dir", "/config", "--incomplete-dir", "/download/Working", "--dht", "--no-auth", "--download-dir", "/download/Complete" ]
ENTRYPOINT ["/usr/bin/transmission-daemon"]
