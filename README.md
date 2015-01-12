docker-transmission
===================

Transmission daemon running in a container. The default paths have been altered to:

 * /config
 * /download

`transmission-daemon` runs as `root` to avoid permission issues when accessing the NAS running under the normal `debian-transmission` user account.  The HTTP RPC interface is listening on TCP port `9091` and the BitTorrent transfer port is listening on TCP & UDP port `51413`. The HTTP RPC interface is configured without authentication and allows connections from all private IP ranges:

 * `127.0.0.0/8`
 * `10.0.0.0/8`
 * `192.168.0.0/16`
 * `169.254.0.0/16`
 * `172.16.0.0/22`

Assumptions
-----------

I use a NAS with a "download" share with the following structure:

  Download                    - Completed downloads
  Download\Torrents           - Watch directory for .torrent files
  Download\Torrents\Working   - Working directory where "in progress" files are located

All Docker configuration files are mounted from `/etc/docker/<container name>`.

Quick-start
-----------

    sudo docker run -d --restart always -h transmission --name transmission -v /mnt/download:/download -v /etc/docker/transmission:/config -v /etc/localtime:/etc/localtime:ro -p 9091:9091 -p 51413:51413 -p 51413:51413/udp randomparity/docker-transmission


Then open http://<host IP>:9091 in a browser to access the Transmissioni web UI.

Details
-------

Since I use a NAS I've run into an issue when adding a .torrent file to the "watch" directory where Transmission refuses to see that the file has been added.  To work around this I've included a script which manually scans the "watch" directory every minute and uses the Transmission CLI add the torrent to the download queue.
