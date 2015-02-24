FROM debian:jessie
MAINTAINER Carles Amigó, fr3nd@fr3nd.net

RUN apt-get update && apt-get install -y \
      build-essential \
      git \
      libgcrypt20-dev \
      libglib2.0-dev \
      libgnutls28-dev

ENV BITLBEE_VERSION 3.2.2-1

WORKDIR /usr/src
RUN git clone https://github.com/bitlbee/bitlbee.git
WORKDIR /usr/src/bitlbee
RUN git checkout $BITLBEE_VERSION
RUN ./configure --help
RUN ./configure \
      --debug=0 \
      --ssl=gnutls \
      --prefix=/usr \
      --etcdir=/etc/bitlbee
RUN make
# make install fails to see docs were not creating
RUN touch doc/user-guide/help.txt
RUN make install
RUN make install-etc
RUN mkdir -p /var/lib/bitlbee/
