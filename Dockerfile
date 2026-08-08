FROM ubuntu:24.04

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl && \
    rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --user-group --system mattermost

COPY server/dist/mattermost-team-linux-amd64.tar.gz /tmp/

RUN tar -xzf /tmp/mattermost-team-linux-amd64.tar.gz -C /opt/ && \
    rm /tmp/mattermost-team-linux-amd64.tar.gz

RUN mkdir -p /mattermost/data /mattermost/logs /mattermost/config /mattermost/plugins /mattermost/client/plugins && \
    cp -r /opt/mattermost/config/* /mattermost/config/ 2>/dev/null || true && \
    cp -r /opt/mattermost/client /mattermost/ 2>/dev/null || true && \
    cp -r /opt/mattermost/bin /mattermost/ 2>/dev/null || true && \
    cp -r /opt/mattermost/fonts /mattermost/ 2>/dev/null || true && \
    cp -r /opt/mattermost/i18n /mattermost/ 2>/dev/null || true && \
    cp -r /opt/mattermost/templates /mattermost/ 2>/dev/null || true && \
    chown -R mattermost:mattermost /mattermost /opt/mattermost && \
    chmod -R g+w /mattermost

EXPOSE 8065

USER mattermost
WORKDIR /mattermost
ENTRYPOINT ["/mattermost/bin/mattermost"]
