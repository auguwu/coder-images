# 💐💚 coder-images: Optimized, and easy Docker images and Coder templates to use in your everyday work!
# Copyright (c) 2022-2023 Noel Towa <cutie@floofy.dev>
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

FROM ubuntu:lunar

# For now, this will be `noel` as the user. You can extend this to be whatever you like.
ENV USERNAME=noel \
  USER_UID=1001 \
  USER_GID=1001

ENV DEBIAN_FRONTEND=noninteractive

# Install needed packages
RUN apt update && \
  apt upgrade -y && \
  apt install -y sudo git curl neofetch git-lfs ca-certificates \
                unzip zip bash vim nano python3 python3-pip libarchive-tools gnupg lsb-release pkg-config \
                libssl-dev tree htop jq zsh ripgrep exa bat protobuf-compiler xz-utils

RUN groupadd -g ${USER_GID} ${USERNAME} && \
  useradd -rm -d /home/${USERNAME} -s /bin/bash -g ${USERNAME} -u ${USER_UID} ${USERNAME} && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chown ${USER_UID}:${USER_GID} /home/${USERNAME}

RUN git lfs install --system
RUN mkdir -p /etc/apt/keyrings && \
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update && apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
RUN usermod -aG docker ${USERNAME}

ENV BAZEL_BUILDTOOLS_VERSION="6.3.2"
ENV GITHUB_CLI_VERSION="2.32.0"
ENV CODER_CLI_VERSION="2.1.0"
ENV TERRAFORM_VERSION="1.5.5"
ENV BAZELISK_VERSION="1.18.0"
ENV KUBECTL_VERSION="1.28.0"
ENV HELM_VERSION="3.12.3"

RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "${arch}" in \
    aarch64|arm64) \
      BAZEL_UNUSED_DEPS_DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILDTOOLS_VERSION}/unused_deps-linux-arm64"; \
      BAZEL_BUILDIFIER_DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILDTOOLS_VERSION}/buildifier-linux-arm64"; \
      BAZEL_BUILDOZER_DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILDTOOLS_VERSION}/buildozer-linux-arm64"; \
      GITHUB_CLI_DOWNLOAD_URL="https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_arm64.tar.gz"; \
      TERRAFORM_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_arm64.zip"; \
      BAZELISK_DOWNLOAD_URL="https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-arm64"; \
      KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/arm64/kubectl"; \
      CODER_DOWNLOAD_URL="https://github.com/coder/coder/releases/download/v${CODER_CLI_VERSION}/coder_${CODER_CLI_VERSION}_linux_arm64.tar.gz"; \
      HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-arm64.tar.gz"; \
      ;; \
    amd64|x86_64) \
      BAZEL_UNUSED_DEPS_DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILDTOOLS_VERSION}/unused_deps-linux-amd64"; \
      BAZEL_BUILDIFIER_DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILDTOOLS_VERSION}/buildifier-linux-amd64"; \
      BAZEL_BUILDOZER_DOWNLOAD_URL="https://github.com/bazelbuild/buildtools/releases/download/v${BAZEL_BUILDTOOLS_VERSION}/buildozer-linux-amd64"; \
      GITHUB_CLI_DOWNLOAD_URL="https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz" \
      TERRAFORM_DOWNLOAD_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" \
      BAZELISK_DOWNLOAD_URL="https://github.com/bazelbuild/bazelisk/releases/download/v${BAZELISK_VERSION}/bazelisk-linux-amd64"; \
      CODER_DOWNLOAD_URL="https://github.com/coder/coder/releases/download/v${CODER_CLI_VERSION}/coder_${CODER_CLI_VERSION}_linux_amd64.tar.gz" \
      KUBECTL_DOWNLOAD_URL="https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl"; \
      HELM_DOWNLOAD_URL="https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz"; \
      ;; \
  esac; \
  mkdir -p /opt/coder/cli /opt/github/cli /opt/hashicorp/terraform /opt/helm /tmp/nixos-install; \
  curl -L -o /usr/local/bin/kubectl ${KUBECTL_DOWNLOAD_URL}; \
  curl -L ${CODER_DOWNLOAD_URL}      | tar xfz - -C /opt/coder/cli --strip-components=1; \
  curl -L ${GITHUB_CLI_DOWNLOAD_URL} | tar xfz - -C /opt/github/cli --strip-components=1; \
  curl -L ${HELM_DOWNLOAD_URL}       | tar xfz - -C /opt/helm --strip-components=1; \
  curl -L ${TERRAFORM_DOWNLOAD_URL}  | bsdtar xfz - -C /opt/hashicorp/terraform; \
  curl -fsSL -o /usr/local/bin/bazel             ${BAZELISK_DOWNLOAD_URL}; \
  curl -fsSL -o /usr/local/bin/bazel-buildifier  ${BAZEL_BUILDIFIER_DOWNLOAD_URL}; \
  curl -fsSL -o /usr/local/bin/bazel-buildozer   ${BAZEL_BUILDOZER_DOWNLOAD_URL}; \
  curl -fsSL -o /usr/local/bin/bazel-unused-deps ${BAZEL_UNUSED_DEPS_DOWNLOAD_URL};

RUN chmod +x /usr/local/bin/kubectl /usr/local/bin/bazel /usr/local/bin/bazel-* /opt/hashicorp/terraform/terraform

USER ${USERNAME}
WORKDIR /home/${USERNAME}

ENV PATH=$PATH:/opt/coder/cli:/opt/hashicorp/terraform:/opt/helm:/opt/github/cli/bin:/home/${USERNAME}/.local/bin
RUN helm repo add bitnami https://charts.bitnami.com/bitnami
