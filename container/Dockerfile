FROM alpine

RUN apk add --no-cache bash curl iproute2 keepalived tini strace iputils nano

RUN mkdir -p /tmp/hcloud && \
    cd /tmp/hcloud && \
    curl -L -s -o hcloud-linux-amd64.tar.gz https://github.com/hetznercloud/cli/releases/download/v1.31.1/hcloud-linux-amd64.tar.gz && \
    tar -zxvf hcloud-linux-amd64.tar.gz && \
    chmod +x hcloud && \
    cp -a hcloud /usr/local/bin/hcloud && \
    rm -rf /tmp/hcloud

RUN curl -L -s -o /usr/local/bin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    chmod +x /usr/local/bin/kubectl

WORKDIR /root

COPY --from=ghcr.io/matti/tailer /tailer /usr/local/bin

COPY layers/ /

ENTRYPOINT ["/sbin/tini", "--", "/keepalived.sh"]
