FROM debian:stretch-slim
LABEL maintainer="Stephen Price <stephen@stp5.net>"

ENV UID 1000
ENV GID 1000
ENV TIMEZONE UTC

RUN apt-get update \
  && apt-get install -y curl libcap2-bin apt-transport-https

RUN curl -fsSL https://nextdns.io/repo.gpg | apt-key add - \
    && echo "deb https://nextdns.io/repo/deb stable main" > /etc/apt/sources.list.d/nextdns.list \
    && apt-get update \
    && apt-get -y install nextdns \
    && addgroup --gid ${GID} nextdns \
    && adduser --system --uid ${UID} --gid ${GID} nextdns \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 53/tcp 53/udp

USER nextdns

ADD ./run.sh /home/nextdns/run.sh

WORKDIR /home/nextdns
CMD ["./run.sh"]
