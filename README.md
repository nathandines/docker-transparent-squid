# docker-transparent-proxy

Intended to be used as a base image for tools which need to go through a proxy server, where native proxy support is limited

## Usage

(`UPSTREAM_PROXY_OPTIONS` are [Squid cache_peer options](http://www.squid-cache.org/Doc/config/cache_peer/); e.g. `login=username:password`)

```sh
docker run --rm -ti --cap-add=NET_ADMIN --cap-add=NET_RAW \
  -e 'UPSTREAM_PROXY_HOST=<proxy_hostname>' \
  -e 'UPSTREAM_PROXY_PORT=<proxy_port>' \
  -e 'UPSTREAM_PROXY_OPTIONS=<proxy_options>' \
  nathandines/transparent-proxy:latest
```
