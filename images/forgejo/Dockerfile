FROM codeberg.org/forgejo/forgejo:14.0.3

ARG INSTALL_RST=false
ARG INSTALL_ENVCONSUL=false
ARG ENVCONSULE_VERSION=0.13.4

USER root

RUN --mount=type=bind,source=./rst-render.py,target=/tmp/rst-render.py \
    if [ "$INSTALL_RST" = "true" ]; then \
        cp /tmp/rst-render.py /usr/local/bin/rst-render.py && \
        chmod +x /usr/local/bin/rst-render.py && \
        apk add --no-cache py3-docutils; \
    fi

RUN if [ "$INSTALL_ENVCONSUL" = "true" ]; then \
        apk add --no-cache wget unzip jq && \
        wget https://releases.hashicorp.com/envconsul/${ENVCONSULE_VERSION}/envconsul_${ENVCONSULE_VERSION}_linux_amd64.zip && \
        unzip envconsul_${ENVCONSULE_VERSION}_linux_amd64.zip && \
        mv envconsul /usr/local/bin/ && \
        rm LICENSE.txt && \
        rm envconsul_${ENVCONSULE_VERSION}_linux_amd64.zip; \
    fi

COPY entrypoint-wrapper.sh /usr/local/bin/entrypoint-wrapper.sh
RUN chmod +x /usr/local/bin/entrypoint-wrapper.sh

# Default Forgejo entrypoint and command
ENTRYPOINT ["/usr/local/bin/entrypoint-wrapper.sh"]
CMD ["/usr/bin/entrypoint", "/bin/s6-svscan", "/etc/s6"] 