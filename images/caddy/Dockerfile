ARG CADDY_VERSION=2.11.2

FROM caddy:${CADDY_VERSION}-builder AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

FROM caddy:${CADDY_VERSION}-alpine

ARG ENVCONSUL_VERSION=0.13.4
ARG INSTALL_ENVCONSUL=false

COPY --from=builder /usr/bin/caddy /usr/bin/caddy

RUN if [ "$INSTALL_ENVCONSUL" = "true" ]; then \
    apk add --no-cache wget unzip jq curl && \
    wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    mv envconsul /usr/local/bin/ && \
    rm LICENSE.txt && \
    rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip; \
    fi

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter caddyfile"]