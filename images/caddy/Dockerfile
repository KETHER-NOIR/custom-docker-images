# Stage 1: Build the custom Caddy binary
FROM caddy:builder AS builder
RUN xcaddy build \
    --with github.com/caddy-dns/cloudflare

# Stage 2: Create the final image
FROM caddy:alpine
COPY --from=builder /usr/bin/caddy /usr/bin/caddy