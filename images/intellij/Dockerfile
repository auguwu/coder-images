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

FROM ghcr.io/auguwu/coder-images/java

ENV USERNAME=noel

# Run as root so we don't have to repeat sudo
USER root

# set versions here
ENV IJ_VERSION="2022.2.3"

# Install packages
RUN DEBIAN_FRONTEND="noninteractive" apt install -y libxtst6 libxrender1 libfontconfig1 libxi6 libgtk-3-0

# Install IntelliJ IDEA
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "${arch}" in \
    arm64|aarch64) \
      INTELLIJ_DOWNLOAD="https://download.jetbrains.com/idea/ideaIU-${IJ_VERSION}.tar.gz"; \
      ;; \
    amd64|x86_64) \
      INTELLIJ_DOWNLOAD="https://download.jetbrains.com/idea/ideaIU-${IJ_VERSION}.tar.gz"; \
      ;; \
  esac; \
  mkdir -p /opt/jetbrains/idea; \
  curl -L -o /tmp/intellij.tar.gz ${INTELLIJ_DOWNLOAD}; \
  tar -xf /tmp/intellij.tar.gz -C /opt/jetbrains/idea --strip-components=1 --no-same-owner; \
  rm /tmp/*.tar.gz;

# Symlink as /usr/bin/intellij-idea-community
RUN ln -s /opt/jetbrains/idea/bin/idea.sh /usr/bin/intellij-idea-community

# Set back to the username specified
USER ${USERNAME}
