FROM debian:10.4-slim

ARG VERSION=1.6.0
ARG SHA256SUM=ad07e331515c3299079cf4f8bca9a5fe9931c992468ca65cdc7d0ff3b4996237

RUN apt-get update && apt-get -y install unzip curl && \
    curl https://github.com/denoland/deno/releases/download/v${VERSION}/deno-x86_64-unknown-linux-gnu.zip -L --output /tmp/deno-x86_64-unknown-linux-gnu.zip && \
    cd /tmp && \
    echo "${SHA256SUM}  /tmp/deno-x86_64-unknown-linux-gnu.zip" |sha256sum -c && \
    unzip /tmp/deno-x86_64-unknown-linux-gnu.zip && \
    mv deno /usr/sbin && \
    rm -rf /tmp/deno-x86_64-unknown-linux-gnu.zip && \
    adduser --disabled-password --system --uid 1000 deno && \
    apt-get -y remove unzip curl && apt-get clean all

USER 1000

ENTRYPOINT ["/usr/sbin/deno"]
