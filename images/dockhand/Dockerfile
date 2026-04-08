ARG DOCKHAND_VERSION=1.0.24

FROM fnsys/dockhand:v${DOCKHAND_VERSION}

ARG ENVCONSUL_VERSION=0.13.4
COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

RUN apk add --no-cache wget unzip jq curl

RUN wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip
RUN unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip -d /tmp/envconsul
RUN mv /tmp/envconsul/envconsul /usr/local/bin/
RUN rm -rf /tmp/envconsul
RUN rm -rf /home/dockhand/.wget-hsts
RUN rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip
RUN apk del wget unzip

ENTRYPOINT ["/entrypoint-wrapper.sh", "/sbin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]