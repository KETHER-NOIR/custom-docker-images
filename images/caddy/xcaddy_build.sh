#!/bin/sh
set -e

FLAGS=""

if [ "$INSTALL_CLOUDFLARE" = "true" ]; then FLAGS="$FLAGS --with github.com/caddy-dns/cloudflare"; fi
if [ "$INSTALL_REPLACE_RESPONSE" = "true" ]; then FLAGS="$FLAGS --with github.com/caddyserver/replace-response"; fi

if [ -z "$FLAGS" ]; then exit 1; fi

xcaddy build $FLAGS