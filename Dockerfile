FROM ubuntu:20.04
LABEL org.opencontainers.image.source https://github.com/timarenz/lw-scanner-action
RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-transport-https ca-certificates curl gnupg lsb-release jq \
    && rm -rf /var/lib/apt/lists/*
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
RUN apt-get update && apt-get install -y --no-install-recommends docker-ce-cli && rm -rf /var/lib/apt/lists/*
RUN curl -LJo /usr/local/bin/lw-scanner https://github.com/lacework/lacework-vulnerability-scanner/releases/download/v0.2.0/lw-scanner-linux-$(dpkg --print-architecture) && chmod +x /usr/local/bin/lw-scanner
ENTRYPOINT ["/usr/local/bin/lw-scanner"]
