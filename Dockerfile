FROM ghcr.io/int128/actions-runner:2.304.0

RUN DEBIAN_FRONTEND=noninteractive && \
    sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        build-essential \
        git \
        tini \
        iptables

# keep /var/lib/apt/lists to reduce time of apt-get update in a job

COPY entrypoint.sh /

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
