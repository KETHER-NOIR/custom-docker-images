ARG GRAFANA_VERSION=13.1.0-24320339380

FROM grafana/grafana:${GRAFANA_VERSION}

ARG ENVCONSUL_VERSION=0.13.4

USER root

RUN apk add --no-cache wget unzip jq curl && \
    wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip -d /tmp/envconsul && \
    mv /tmp/envconsul/envconsul /usr/local/bin/ && \
    rm -rf /tmp/envconsul && \
    rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    apk del wget unzip

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

USER grafana

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/run.sh"]
