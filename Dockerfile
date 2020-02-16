FROM debian:stretch-slim
LABEL maintainer="Stephen Price <stephen@stp5.net>"

ENV NEXTDNS_VERSION=1.4.32 \
    NEXTDNS_SHA256=b55b86f8b9a7e7275ef2d8fec64cfda24e80e91269a9ca3d5890598d28f49af0

ENV NEXTDNS_ARGUMENTS="-listen :53 -report-client-info -log-queries"
ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apt-get update \
  && apt-get install -y curl libcap2-bin

RUN mkdir /tmp/nextdns \
    && curl -fsSL https://github.com/nextdns/nextdns/releases/download/v${NEXTDNS_VERSION}/nextdns_${NEXTDNS_VERSION}_linux_amd64.tar.gz -o /tmp/nextdns/nextdns.tar.gz \
    && cd /tmp/nextdns \
    && echo "${NEXTDNS_SHA256} *nextdns.tar.gz" | sha256sum -c - \
    && tar zxf nextdns.tar.gz \
    && addgroup --gid ${GID} nextdns \
    && adduser --system --uid ${UID} --gid ${GID} --home /nextdns nextdns \
    && mv ./nextdns /nextdns/nextdns \
    && chown nextdns.nextdns /nextdns/nextdns \
    && setcap 'cap_net_bind_service=+ep' /nextdns/nextdns \
    && cd / \
    && rm -rf /tmp/nextdns \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 53/tcp 53/udp

USER nextdns

ADD ./run.sh /nextdns/run.sh

WORKDIR /nextdns
CMD ["./run.sh"]
