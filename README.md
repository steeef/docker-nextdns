# nextdns client Docker image

## Description

Installs nextdns client in a Debian Slim Docker image:
https://github.com/nextdns/nextdns

## Configuration

You can set a few variables depending on your needs:

* `NEXTDNS_ID=ff0000`: Set to the ID of your NextDNS configuration
* `NEXTDNS_ARGUMENTS`: set to the arguments for the `run` command.

## Running

This container will listen on 53 tcp and udp. Most likely you want to bind it
to a local port:

```
docker run -p 53:53/tcp -p 53:53/udp
  -e NEXTDNS_ID=000000 \
  --name nextdns \
  steeef/nextdns
```

NOTE: this image does not include a DNS server with anything like caching. For
that you should link this to an instance of `dnsmasq` or `unbound`.
