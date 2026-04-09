ARG DOCKHAND_VERSION=1.0.24

FROM fnsys/dockhand:v${DOCKHAND_VERSION}

ARG ENVCONSUL_VERSION=0.13.4
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

RUN apk add --no-cache wget unzip jq curl

RUN wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip -d /tmp/envconsul && \
    mv /tmp/envconsul/envconsul /usr/local/bin/ && \
    rm -rf /tmp/envconsul && \
    rm -rf /home/dockhand/.wget-hsts && \
    rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    apk del wget unzip

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/sbin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]