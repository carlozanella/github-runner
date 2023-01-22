# base
FROM ubuntu

# set the github runner version
COPY start.sh start.sh

# update the base packages and add a non-sudo user
RUN chmod +x start.sh \
    && apt-get update -y && apt-get upgrade -y && useradd -m docker \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    curl jq build-essential libssl-dev libffi-dev python3 python3-venv python3-dev python3-pip tzdata

RUN cd /home/docker && mkdir actions-runner && cd actions-runner \
    && RUNNER_VERSION=$(curl https://api.github.com/repos/actions/runner/releases/latest | jq -r '.tag_name' | cut -c2-) \
    && curl -O -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && chown -R docker ~docker && /home/docker/actions-runner/bin/installdependencies.sh

# since the config and run script for actions are not allowed to be run by root,
# set the user to "docker" so all subsequent commands are run as the docker user
USER docker

# set the entrypoint to the start.sh script
ENTRYPOINT ["./start.sh"]
