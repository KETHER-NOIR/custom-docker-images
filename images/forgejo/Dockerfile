FROM codeberg.org/forgejo/forgejo:14.0.3

USER root

COPY entrypoint-wrapper.sh /usr/local/bin/entrypoint-wrapper.sh
RUN chmod +x /usr/local/bin/entrypoint-wrapper.sh
RUN apk add --no-cache py3-docutils

ENV FORGEJO__markup.rst__ENABLED="true"
ENV FORGEJO__markup.rst__FILE_EXTENSIONS=".rst"
ENV FORGEJO__markup.rst__RENDER_COMMAND="/usr/local/bin/rst-render.py"
ENV FORGEJO__markup.rst__IS_INPUT_FILE="false"
