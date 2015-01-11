docker-transmission
===================

Transmission daemon running in a container. The default paths have been altered to:

 * /config
 * /download

`transmission-daemon` runs as `root`, with the HTTP RPC interface listening on TCP port `9091`, and the BitTorrent transfer port listening on TCP & UDP `51413`. The HTTP RPC interface is configured to not use authentication, and allows connections from all private IP ranges:

 * `127.0.0.0/8`
 * `10.0.0.0/8`
 * `192.168.0.0/16`
 * `169.254.0.0/16`
 * `172.16.0.0/22`

Assumptions
-----------

I use a NAS with a "download" share with the following structure:

  Download
  Download\Torrents
  DOwnload\Torrents\Complete  - Completed downloads
  Donwload\Torrents\Watch     - Watch directory for .torrent files
  Download\Torrents\Working   - Working directory where "in progress" files are located

I want to run Transmission as the same user, "sysadmin" in my case, used to mount the NAS share to enforce some level of security.

Quick-start
-----------

    docker run -d -v /<NAS mount point>:/download -v /etc/docker/transmission:/config -v /etc/passwd:/etc/passwd:ro --user sysadmin --port 9091:9091 --port 51413:51413 --port 51413:51413/udp -h transmission --name transmission randomparity/docker-transmission

Then open http://docker_host:9091/transmission/web/ in a browser.
