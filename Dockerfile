ARG DOCKER_VERSION=20.10.12-alpine3.15
FROM docker:${DOCKER_VERSION} as downloader
ARG LW_SCANNER_VERSION=0.2.4
RUN apk add --no-cache curl
RUN curl -LJo /usr/local/bin/lw-scanner https://github.com/lacework/lacework-vulnerability-scanner/releases/download/v${LW_SCANNER_VERSION}/lw-scanner-linux-$(if [ $(uname -m) == "x86_64" ]; then echo "amd64"; elif [ $(uname -m) == "aarch64" ]; then echo "arm64"; fi) && chmod +x /usr/local/bin/lw-scanner

FROM docker:${DOCKER_VERSION}
LABEL org.opencontainers.image.source https://github.com/timarenz/lw-scanner-action
# Required for parsing lw-scanner results in GitHub action https://github.com/timarenz/lw-scanner-action
RUN apk add --no-cache jq 
COPY --from=downloader /usr/local/bin/lw-scanner /usr/local/bin/lw-scanner
ENTRYPOINT ["/usr/local/bin/lw-scanner"]
