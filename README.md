[![GitHub stars](https://img.shields.io/github/stars/WyseNynja/dockerfile-dvd-rip.svg?style=social)](https://github.com/WyseNynja/dockerfile-dvd-rip)
[![License](https://img.shields.io/github/license/WyseNynja/dockerfile-dvd-rip.svg)](https://raw.githubusercontent.com/WyseNynja/dockerfile-dvd-rip/master/LICENSE)

# DVD Rip

**UNDER CONSTRUCTION:**

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
    apt-get install \
        libdvdcss2 \
        git-common \
        handbrake-cli \
        vobcopy
    git clone https://github.com/WyseNynja/dvd-rip.git /opt/dvd-rip
    ```

4. Create `/etc/udev/rules.d/autodvd.rules`:

    ```
    SUBSYSTEM=="block", ACTION=="change", KERNEL=="sr0", RUN+="/opt/dvd-rip/bin/udev.sh"
    ```

Now whenever you insert a disc into your DVD drive, it will automatically get saved to your disk. Automatic conversion to a useful format is in the works.


# TODO

* [ ] write vob-to-mkv.sh and have it run automatically when needed

