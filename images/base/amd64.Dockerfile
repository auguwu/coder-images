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

FROM archlinux:base-devel

# For now, this will be `noel` as the user. You can extend this to be whatever you like.
ENV USERNAME=noel \
  USER_UID=1000 \
  USER_GID=1000

# Install needed packages
RUN pacman -Syu --noconfirm && pacman -Sy --noconfirm sudo git curl neofetch git-lfs ca-certificates unzip zip bash

# Setup the user environment
RUN groupadd -g ${USER_GID} ${USERNAME} && \
  useradd -u ${USER_UID} -g ${USER_GID} -m -s /bin/bash -d /home/${USERNAME} ${USERNAME} && \
  echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
  chown ${USER_UID}:${USER_GID} "/home/${USERNAME}"

# Configure git-lfs
RUN sudo git lfs install --system

# Configure the GitHub CLI
ENV GITHUB_CLI_VERSION="2.18.1"
RUN curl -L -o /tmp/gh.tar.gz https://github.com/cli/cli/releases/download/v${GITHUB_CLI_VERSION}/gh_${GITHUB_CLI_VERSION}_linux_amd64.tar.gz && \
  mkdir -p /opt/github/cli && \
  tar -xf /tmp/gh.tar.gz -C /opt/github/cli

# Configure the Coder CLI
ENV CODER_CLI_VERSION="0.10.2"
RUN curl -L -o /tmp/coder.tar.gz https://github.com/coder/coder/releases/download/v${CODER_CLI_VERSION}/coder_${CODER_CLI_VERSION}_linux_amd64.tar.gz && \
  mkdir -p /opt/coder/cli && \
  tar -xf /tmp/coder.tar.gz -C /opt/coder/cli

# Configure Terraform
ENV TERRAFORM_VERSION="1.3.3"
RUN curl -L -o /tmp/terraform.tar.gz https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
  mkdir -p /opt/hashicorp/terraform && \
  unzip -qd /opt/hashicorp/terraform /tmp/terraform.tar.gz

# Cleanup temporary distributions
RUN rm /tmp/*.tar.gz

USER ${USERNAME}
WORKDIR /home/${USERNAME}

# Set paths to coder, gh, and terraform
RUN echo "export PATH=\"\$PATH:/opt/coder/cli\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/hashicorp/terraform\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/github/cli/gh_${GITHUB_CLI_VERSION}_linux_amd64/bin\"" >> /home/${USERNAME}/.bashrc
