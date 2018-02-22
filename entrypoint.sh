#!/bin/sh

set -euo pipefail

SQUID_CONF="${SQUID_CONF-/etc/squid/squid.conf}"

if [ "${UPSTREAM_PROXY_HOST+x}" = 'x' ]; then
  sed -i \
    -e "s/{{ proxy_host }}/${UPSTREAM_PROXY_HOST}/" \
    -e "s/{{ proxy_port }}/${UPSTREAM_PROXY_PORT}/" \
    -e "s/{{ proxy_options }}/${UPSTREAM_PROXY_OPTIONS-}/" \
    "$SQUID_CONF"
  echo 'never_direct allow all' >> "$SQUID_CONF"
else
  sed -i '/{{ proxy_host }}/d' "$SQUID_CONF"
fi

SSL_PATH="${SSL_PATH-/etc/squid/ssl}"

mkdir -p "$SSL_PATH"
openssl req -new -newkey rsa:4096 -sha256 -days 365 -nodes -x509 \
  -keyout "${SSL_PATH}/CA.pem" \
  -out "${SSL_PATH}/CA.pem" \
  -subj "/C=XX/ST=John Smith/L=Atlantis/O=Foo/OU=Bar/CN=localhost"

iptables -t nat -A OUTPUT -m owner ! --uid-owner squid -p tcp --dport 80 -j REDIRECT --to-port 3129
iptables -t nat -A OUTPUT -m owner ! --uid-owner squid -p tcp --dport 443 -j REDIRECT --to-port 3130

squid

"$@"
