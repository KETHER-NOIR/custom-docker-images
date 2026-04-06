ARG TAILSCALE_VERSION=1.94.2

FROM dhi.io/tailscale:${TAILSCALE_VERSION}-dev AS builder

ARG ENVCONSUL_VERSION=0.13.4
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

# Install all tools in the builder (which has apt-get)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Download and extract envconsul in the builder stage
RUN wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip \
    && unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip \
    && mv envconsul /usr/local/bin/

FROM dhi.io/tailscale:${TAILSCALE_VERSION}

# Copy the required runtime binaries from the builder
# Since the hardened image lacks a package manager (apt-get),
# we copy them directly from the builder stage.
COPY --from=builder /usr/bin/curl /usr/bin/curl
COPY --from=builder /usr/bin/jq /usr/bin/jq
COPY --from=builder /usr/local/bin/envconsul /usr/local/bin/envconsul
COPY --from=builder /entrypoint-wrapper.sh /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]