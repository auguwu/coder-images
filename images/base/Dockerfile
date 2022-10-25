# 💐💚 coder-images: Optimized, and easy Docker images and Coder templates to use in your everyday work!
# Copyright (c) 2022 Noel <cutie@floofy.dev>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

FROM ubuntu:jammy

# For now, this will be `noel` as the user. You can extend this to be whatever you like.
ENV USERNAME=noel \
  USER_UID=1000 \
  USER_GID=1000

# Install needed packages
RUN DEBIAN_FRONTEND=noninteractive apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y sudo git curl neofetch git-lfs ca-certificates unzip zip bash

# Setup the user environment
RUN groupadd -g ${USER_GID} ${USERNAME} && \
  useradd -rm -d /home/${USERNAME} -s /bin/bash -g ${USERNAME} -u ${USER_UID} ${USERNAME} && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chown ${USER_UID}:${USER_GID} /home/${USERNAME}

# Configure git-lfs
RUN git lfs install --system

# stuff here
ENV GITHUB_CLI_VERSION="2.18.1"
ENV CODER_CLI_VERSION="0.11.0"
ENV TERRAFORM_VERSION="1.3.3"

# Get current architecture and download software here
# also this looks like shit, i know!
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "${arch}" in \
    aarch64|arm64) \
      ARCH="arm64" \
      GH_DOWNLOAD_URL="https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_arm64.tar.gz" \
      CD_DOWNLOAD_URL="https://github.com/coder/coder/releases/download/v${CODER_CLI_VERSION}/coder_${CODER_CLI_VERSION}_linux_arm64.tar.gz" \
      TF_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_arm64.zip" \
      ;;           \
    x86_64|amd64)  \
      ARCH="amd64" \
      GH_DOWNLOAD_URL="https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz" \
      CD_DOWNLOAD_URL="https://github.com/coder/coder/releases/download/v${CODER_CLI_VERSION}/coder_${CODER_CLI_VERSION}_linux_amd64.tar.gz" \
      TF_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
      ;;           \
    *)             \
      echo "Unsupported architecture [${arch}]" \
      exit 1       \
      ;;           \
  esac;            \
  mkdir -p /opt/coder/cli;             \
  mkdir -p /opt/github/cli;            \
  mkdir -p /opt/hashicorp/terraform;            \
  curl -L -o /tmp/gh.tar.gz ${GH_DOWNLOAD_URL}; \
  tar -xf /tmp/gh.tar.gz -C /opt/github/cli;    \
  curl -L -o /tmp/coder.tar.gz ${CD_DOWNLOAD_URL}; \
  tar -xf /tmp/coder.tar.gz -C /opt/coder/cli;    \
  curl -L -o /tmp/terraform.zip ${TF_DOWNLOAD_URL}; \
  unzip -qd /opt/hashicorp/terraform /tmp/terraform.zip; \
  mkdir /opt/github/_cli; \
  cp -r /opt/github/cli/gh_${GITHUB_CLI_VERSION}_linux_${ARCH} /opt/github/_cli;

# Do some cleanup for the GitHub CLI path
RUN set -eux; \
  ls /opt/github; \
  cp /opt/github/_cli/**/LICENSE /opt/github/cli/LICENSE; \
  cp -R /opt/github/_cli/**/bin /opt/github/cli/bin; \
  cp -R /opt/github/_cli/**/share /opt/github/cli/share; \
  rm -rf /opt/github/_cli;

# Cleanup temporary distributions
RUN rm /tmp/*.tar.gz /tmp/*.zip

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Set paths to coder, gh, and terraform
RUN echo "export PATH=\"\$PATH:/opt/coder/cli\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/hashicorp/terraform\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/github/cli/bin\"" >> /home/${USERNAME}/.bashrc
