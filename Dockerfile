FROM ghcr.io/actions/actions-runner:2.304.0

RUN sudo apt-get update && \
    sudo apt-get install -y --no-install-recommends \
        build-essential \
        tini \
        iptables

COPY entrypoint.sh /

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
