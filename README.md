[![GitHub stars](https://img.shields.io/github/stars/WyseNynja/dockerfile-dvd-rip.svg?style=social)](https://github.com/WyseNynja/dockerfile-dvd-rip)
[![Docker Pulls](https://img.shields.io/docker/pulls/bwstitt/dvd-rip.svg)](https://hub.docker.com/r/bwstitt/dvd-rip/)
[![License](https://img.shields.io/github/license/WyseNynja/dockerfile-dvd-rip.svg)](https://raw.githubusercontent.com/WyseNynja/dockerfile-dvd-rip/master/LICENSE)

# DVD Rip

**UNDER CONSTRUCTION**

Easily rip a DVD to an MKV using vobcopy, libdvdcss2, and handbrake-cli.

From http://www.videolan.org/legal.html:

> libdvdcss is a library that can find and guess keys from a DVD in order to decrypt it.
This method is authorized by a French law decision CE 10e et 9e sous­sect., 16 juillet 2008, n° 301843 on interoperability.
> NB: In the USA, you should check out the US Copyright Office decision that allows circumvention in some cases.
> VideoLAN is NOT a US-based organization and is therefore outside US jurisdiction.


# Running

1. Insert a DVD and run:

    ```bash
    mount /media/cdrom0 \
    && docker run \
        --device /dev/sr0 \
        --rm \
        -it \
        -v "/media/cdrom0:/mnt" \
        -v "movies:/movies" \
        bwstitt/dvd-rip:latest \
        dvd-to-vob.sh \
    && eject /media/cdrom0
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


# Todo

* [ ] udev rule to run the commands whenever a disc is inserted
* [ ] set DVDCSS_CACHE (http://www.videolan.org/developers/libdvdcss/doc/html/)
