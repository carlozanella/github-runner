# base
FROM ubuntu
COPY --from=docker:20.10 /usr/local/bin/docker /usr/local/bin/

# set the github runner version
COPY start.sh start.sh

ENV RUNNER_ALLOW_RUNASROOT=true

# update the base packages and add a non-sudo user
RUN chmod +x start.sh \
    && apt-get update -y && apt-get upgrade -y\
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip tzdata

RUN cd /root && mkdir actions-runner && cd actions-runner \
    && RUNNER_VERSION=$(curl https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | cut -c2-) \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && /root/actions-runner/bin/installdependencies.sh


# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
