ARG TUBEARCHIVIST_VERSION=v0.5.10

FROM bbilly1/tubearchivist:${TUBEARCHIVIST_VERSION}

ARG ENVCONSUL_VERSION=0.13.4

RUN apt-get update && \
    apt-get install -y wget unzip jq curl && \
    wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip -d /tmp/envconsul && \
    mv /tmp/envconsul/envconsul /usr/local/bin/ && \
    rm -rf /tmp/envconsul && \
    rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip && \
    apt-get remove -y wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

ENTRYPOINT ["/entrypoint-wrapper.sh"]
CMD ["/bin/tini", "--", "./run.sh"]
