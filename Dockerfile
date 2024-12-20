FROM debian:bookworm-slim as build

ENV NEXTDNS_VERSION=1.44.0 \
    NEXTDNS_SHA256=ba4a2ef22bff8181ea843b32b132500c09012a0a0b5d04a23f2458b4be85eb68

RUN apt-get update \
  && apt-get install -y curl libcap2-bin \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir /tmp/nextdns

WORKDIR /tmp/nextdns

RUN curl -fsSL https://github.com/nextdns/nextdns/releases/download/v${NEXTDNS_VERSION}/nextdns_${NEXTDNS_VERSION}_linux_amd64.tar.gz -o nextdns.tar.gz \
    && echo "${NEXTDNS_SHA256} *nextdns.tar.gz" | sha256sum -c - \
    && tar zxf nextdns.tar.gz \
    && setcap 'cap_net_bind_service=+ep' nextdns

FROM debian:bookworm-slim
LABEL maintainer="Stephen Price <stephen@stp5.net>"

ENV NEXTDNS_ARGUMENTS="-listen :53 -report-client-info -log-queries"
ENV UID 1000
ENV GID 1000

RUN addgroup --gid ${GID} nextdns \
    && adduser --system --uid ${UID} --gid ${GID} --home /nextdns nextdns

COPY --from=build --chown=nextdns:nextdns /tmp/nextdns/nextdns /nextdns/nextdns
COPY --chown=nextdns:nextdns ./run.sh /nextdns/run.sh

EXPOSE 53/tcp 53/udp

USER nextdns

WORKDIR /nextdns

CMD ["./run.sh"]
