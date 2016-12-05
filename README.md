[![GitHub stars](https://img.shields.io/github/stars/WyseNynja/dockerfile-dvd-rip.svg?style=social)](https://github.com/WyseNynja/dockerfile-dvd-rip)
[![Docker Pulls](https://img.shields.io/docker/pulls/bwstitt/dvd-rip.svg)](https://hub.docker.com/r/bwstitt/dvd-rip/)
[![License](https://img.shields.io/github/license/WyseNynja/dockerfile-dvd-rip.svg)](https://raw.githubusercontent.com/WyseNynja/dockerfile-dvd-rip/master/LICENSE)

# DVD Rip

**UNDER CONSTRUCTION**

Easily rip a DVD to an MKV using [vobcopy](http://vobcopy.org/projects/c/c.shtml) ([GPL](https://www.gnu.org/licenses/gpl-3.0.en.html)), [libdvdcss2](http://www.videolan.org/developers/libdvdcss/doc/html/) ([GPL](https://www.gnu.org/licenses/gpl-3.0.en.html)), and [handbrake-cli](https://handbrake.fr) ([GPLv2](https://raw.githubusercontent.com/HandBrake/HandBrake/master/LICENSE)).

From http://www.videolan.org/legal.html:

> libdvdcss is a library that can find and guess keys from a DVD in order to decrypt it.
This method is authorized by a French law decision CE 10e et 9e sous­sect., 16 juillet 2008, n° 301843 on interoperability.
> NB: In the USA, you should check out the US Copyright Office decision that allows circumvention in some cases.
> VideoLAN is NOT a US-based organization and is therefore outside US jurisdiction.


# Running Manually

1. Insert a DVD and run:

    ```bash
    mount /dev/sr0 \
    && docker run \
        --device /dev/sr0 \
        --rm \
        -it \
        -v "/media/cdrom0:/media/cdrom0" \
        -v "movies:/movies" \
        bwstitt/dvd-rip:latest \
        dvd-to-vob.sh /media/cdrom0 /movies \
    && eject /dev/sr0
    ```

2. Then run:

    ```bash
    docker run \
        --rm \
        -it \
        -v "movies:/movies" \
        bwstitt/dvd-rip:latest \
        vob-to-mkv.sh
    ```

3. Now you have an mkv in a named volume. Move it:

    ```bash
    mv /var/lib/docker/volumes/movies/_data/*.mkv /mnt/media/movies/
    ```


# Running Automatically

1. Create `/usr/local/bin/autodvd` and `chmod 755 /usr/local/bin/autodvd`:

    ```bash
    #!/bin/bash
    # mount, rip, and eject a DVD

    set -eo pipefail
    {
      mount -o ro "$DEVNAME"

      MNT_D=$(df "$DEVNAME" | tail -1 | awk '{ printf $6 }')
      [ -z "$MNT_D" ] && exit 1

      docker run \
        --device "$DEVNAME" \
        --rm \
        -it \
        --env "ID_FS_LABEL=$ID_FS_LABEL" \
        --env "ID_FS_UUID=$ID_FS_UUID" \
        -v "$MNT_D:$MNT_D" \
        -v "movies:/movies" \
        bwstitt/dvd-rip:latest \
        dvd-to-vob.sh "$MNT_D"

      eject "$DEVNAME"
    } &>> "/var/log/autodvd.log" &
    ```

2. Create `/etc/udev/rules.d/autodvd.rules`

    ```bash
    ACTION=="add", KERNEL=="sr[0-9]*", ENV{ID_CDROM_DVD}=="1", ENV{ID_CDROM_MEDIA_STATE}=="complete", ENV{ID_FS_TYPE}=="udf", RUN+="/usr/local/bin/autodvd"
    ACTION=="add", KERNEL=="sr[0-9]*", ENV{ID_CDROM_DVD}=="1", ENV{ID_CDROM_MEDIA_STATE}=="complete", ENV{ID_FS_TYPE}=="iso9660", RUN+="/usr/local/bin/autodvd"
    ```

3. Do something to automatically convert the vobs to mkvs and then copy them to my NAS

4. Create a cronjob to run `docker pull bwstitt/dvd-rip:latest`


# TODO

* [ ] include the autodvd script and udev rules inside the container for easy installation

