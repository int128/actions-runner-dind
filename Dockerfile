FROM ubuntu:22.04 as build

# based on https://github.com/actions/runner/blob/v2.304.0/images/Dockerfile
ARG TARGETARCH
ARG RUNNER_VERSION
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.3.2
ARG DOCKER_VERSION=20.10.23

RUN apt update -y && apt install curl unzip -y

WORKDIR /actions-runner
RUN RUNNER_ARCH="x64" \
    && if [ "$TARGETARCH" = "arm64" ]; then RUNNER_ARCH=arm64 ; fi \
    && curl -f -L -o runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${RUNNER_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm runner.tar.gz

RUN curl -f -L -o runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm runner-container-hooks.zip

RUN DOCKER_ARCH=x86_64 \
    && if [ "$RUNNER_ARCH" = "arm64" ]; then DOCKER_ARCH=aarch64 ; fi \
    && curl -fLo docker.tgz https://download.docker.com/linux/static/stable/${DOCKER_ARCH}/docker-${DOCKER_VERSION}.tgz \
    && tar zxvf docker.tgz \
    && rm -rf docker.tgz

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        # based on https://github.com/actions/actions-runner-controller/blob/aac811f210782d1a35e33ffcfe12db69ebe8e447/runner/actions-runner.ubuntu-22.04.dockerfile
        sudo \
        build-essential \
        git \
        # dockerd dependencies
        tini \
        iptables

# keep /var/lib/apt/lists to reduce time of apt-get update in a job

RUN adduser --disabled-password --gecos "" --uid 1001 runner \
    && groupadd docker --gid 123 \
    && usermod -aG sudo runner \
    && usermod -aG docker runner \
    && echo "%sudo   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

WORKDIR /home/runner

COPY --chown=runner:docker --from=build /actions-runner .

RUN install -o root -g root -m 755 docker/* /usr/bin/ && rm -rf docker

COPY entrypoint.sh /

USER runner

ENV ImageOS=ubuntu22

ENTRYPOINT ["/usr/bin/tini", "--", "/entrypoint.sh"]
CMD ["/home/runner/run.sh"]
