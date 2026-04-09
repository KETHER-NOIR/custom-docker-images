ARG VAULTWARDEN_VERSION=1.35.4

FROM vaultwarden/server:${VAULTWARDEN_VERSIOM}-alpine

ARG ENVCONSUL_VERSION=0.13.4

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

RUN apk add -no-cache wget unzip jq curl && \
    wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip -d /tmp/envconsul && \
    mv /tmp/envconsul/envconsul /usr/local/bin/ && \
    rm -rf /tmp/envconsul && \
    rm -rf /home/dockhand/.wget-hsts && \
    rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    apk del wget unzip

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/start.sh"]