# DVD Rip

Easily rip a DVD to an MKV

# Running

1. Insert a DVD and run:
```
docker run \
    --rm -it \
    --device=/dev/sr0 \
    -v "movies:/target" \
    bwstitt/dvd-rip:latest \
    dvd-to-vob.sh
```

2. Then run:
```
docker run \
    --rm -it \
    --device=/dev/sr0 \
    -v "movies:/target" \
    bwstitt/dvd-rip:latest \
    dvd-to-vob.sh
```
