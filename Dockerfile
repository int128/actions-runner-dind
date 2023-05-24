FROM ghcr.io/actions/actions-runner:2.304.0

RUN sudo apt-get update && \
    sudo apt-get install -y build-essential

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
