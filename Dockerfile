FROM debian:jessie
MAINTAINER Carles Amigó, fr3nd@fr3nd.net

RUN apt-get update && apt-get install -y \
      asciidoc \
      build-essential \
      git \
      libgcrypt20-dev \
      libglib2.0-dev \
      libgnutls28-dev \
      xsltproc \
      xmlto && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV BITLBEE_VERSION 3.2.2-1

WORKDIR /usr/src
RUN git clone https://github.com/bitlbee/bitlbee.git
WORKDIR /usr/src/bitlbee
RUN git checkout $BITLBEE_VERSION
RUN ./configure \
      --debug=0 \
      --ssl=gnutls \
      --prefix=/usr \
      --etcdir=/etc/bitlbee \
      --purple=1
RUN make
# Docs fail to build. We need to force them
RUN (cd doc && make -C user-guide)
RUN make install
RUN make install-etc

RUN useradd -d /var/lib/bitlbee --no-create-home --shell /usr/sbin/nologin bitlbee

COPY bitlbee.conf /etc/bitlbee/bitlbee.conf
RUN mkdir -p /var/lib/bitlbee/ /var/run/bitlbee
RUN chown -R bitlbee /var/lib/bitlbee/ /var/run/bitlbee

EXPOSE 6667
VOLUME /var/lib/bitlbee

WORKDIR /
ENTRYPOINT [ "/usr/sbin/bitlbee" ]
