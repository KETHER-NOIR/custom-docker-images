ARG AUTHENTIK_VERSION=2026.2.2

FROM authentik/server:${AUTHENTIK_VERSION}

ARG ENVCONSUL_VERSION=0.13.4

USER root

COPY entrypoint-wrapper.sh /entrypoint-wrapper.sh
RUN chmod +x /entrypoint-wrapper.sh

RUN apt-get update && apt-get install -y wget unzip jq curl && rm -rf /var/lib/apt/lists/*

RUN wget https://releases.hashicorp.com/envconsul/${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip
RUN unzip envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip -d /tmp/envconsul
RUN mv /tmp/envconsul/envconsul /usr/local/bin/
RUN rm -rf /tmp/envconsul
RUN rm -rf /home/dockhand/.wget-hsts
RUN rm envconsul_${ENVCONSUL_VERSION}_linux_amd64.zip
RUN apt-get purge -y wget unzip && apt-get autoremove -y

USER 1000

ENTRYPOINT ["/entrypoint-wrapper.sh", "dumb-init", "--", "ak"]