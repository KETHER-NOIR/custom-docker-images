ARG TAILSCALE_VERSION=1.94.2

FROM dhi.io/tailscale:${TAILSCALE_VERSION}-dev

ARG ENVCONSUL_VERSION=0.13.4
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

# Install all tools in the builder (which has apt-get)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    unzip \
    curl \
    jq

# Download and extract envconsul in the builder stage
RUN wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip \
    && unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip \
    && mv envconsul /usr/local/bin/ \
    && rm LICENSE.txt \
    && rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip \
    && apt-get remove -y wget unzip \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/entrypoint-wrapper.sh"]