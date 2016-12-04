# DVD Rip

Easily rip a DVD to an MKV

# Running

1. Insert a DVD and run:

    ```
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

    ```
    docker run \
        --rm \
        -it \
        -v "movies:/movies" \
        bwstitt/dvd-rip:latest \
        vob-to-mkv.sh
    ```

# Todo

* [ ] get dvd title without needing --privileged or -v /dev/sr0
* [ ] udev rule to run `mount && docker run && eject` whenever a disc is inserted
