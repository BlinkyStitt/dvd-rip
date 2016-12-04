# DVD Rip

**UNDER CONSTRUCTION**

Easily rip a DVD to an MKV.


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
