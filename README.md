[![GitHub stars](https://img.shields.io/github/stars/WyseNynja/dockerfile-dvd-rip.svg?style=social)](https://github.com/WyseNynja/dockerfile-dvd-rip)
[![License](https://img.shields.io/github/license/WyseNynja/dockerfile-dvd-rip.svg)](https://raw.githubusercontent.com/WyseNynja/dockerfile-dvd-rip/master/LICENSE)

# DVD Rip

Easily rip a DVD to an MKV using [vobcopy](http://vobcopy.org/projects/c/c.shtml) ([GPL](https://www.gnu.org/licenses/gpl-3.0.en.html)), [libdvdcss2](http://www.videolan.org/developers/libdvdcss/doc/html/) ([GPL](https://www.gnu.org/licenses/gpl-3.0.en.html)), and [handbrake-cli](https://handbrake.fr) ([GPLv2](https://raw.githubusercontent.com/HandBrake/HandBrake/master/LICENSE)).

This started off as an experiment with docker and it didn't go well, so now I'm just using system packages.

From http://www.videolan.org/legal.html:

> libdvdcss is a library that can find and guess keys from a DVD in order to decrypt it.
This method is authorized by a French law decision CE 10e et 9e sous­sect., 16 juillet 2008, n° 301843 on interoperability.
> NB: In the USA, you should check out the US Copyright Office decision that allows circumvention in some cases.
> VideoLAN is NOT a US-based organization and is therefore outside US jurisdiction.


# Installation on Debian

1. Run: `apt-get install ca-certificates wget`

2. Create `/etc/apt/sources.list.d/videolan.list`

    ```
    deb http://download.videolan.org/pub/debian/stable/ /
    deb-src http://download.videolan.org/pub/debian/stable/ /
    ```

3. Run:

    ```bash
    wget -O - https://download.videolan.org/pub/debian/videolan-apt.asc | apt-key add -
    apt-get update
    apt-get install --no-install-recommends \
        at \
        git \
        handbrake-cli \
        libdvdcss2 \
        mailutils \
        vobcopy
    git clone https://github.com/WyseNynja/dvd-rip.git /opt/dvd-rip
    mkdir -p /var/log/dvd-rip
    ```

4. Create `/etc/udev/rules.d/autodvd.rules`:

    ```
    SUBSYSTEM=="block", ACTION=="change", KERNEL=="sr[0-9]*", ENV{ID_FS_LABEL}!="", RUN+="/opt/dvd-rip/bin/udev.sh /path/to/vobs /path/to/movies"
    ```

5. Run `udevadm control -R`

Now whenever you insert a disc into your DVD drive, the raw data is saved to whatever you put for `/path/to/vobs` and then the disc is ejected and you can put the next disc in.

These files are watchable, but they are large and not well supported so a conversion to the MKV format is queued. This conversion takes far longer than the copy and it is setup to only do one conversion at a time to keep your computer from being too slow. Once complete, the movie will be between 1 and 2 GB in `/path/to/movies`.


# Development

Here's a udev rule I found useful for debugging:

    SUBSYSTEM=="block", KERNEL=="sr[0-9]*", RUN+="/bin/sh -c 'echo == >> /var/log/dvd-rip/udev.env; env >>/var/log/dvd-rip/udev.env'"


# TODO

* [ ] don't run as root
* [ ] automatically cleanup vobs better when transcode complete
* [ ] configurable native language
