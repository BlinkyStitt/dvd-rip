FROM bwstitt/library-debian:jessie

RUN docker-apt-install ca-certificates wget

RUN mkdir /movies
VOLUME /movies
WORKDIR /movies

COPY src/videolan.list /etc/apt/sources.list.d/
RUN wget -O - https://download.videolan.org/pub/debian/videolan-apt.asc | apt-key add - \
 && docker-apt-install \
    libdvdcss2 \
    handbrake-cli \
    vobcopy

COPY bin/* /usr/local/bin/
