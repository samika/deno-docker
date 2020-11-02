FROM debian:10.4-slim

ARG VERSION=1.5.1
ARG SHA256SUM=d0cc628cede22a9e318c558cb586b0cb99891ac850b8fe43b279e03469e427a5

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
