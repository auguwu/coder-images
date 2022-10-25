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

FROM ghcr.io/auguwu/coder-images/base

ENV USERNAME=noel

# Run as root so we don't have to repeat sudo
USER root

# Put versions in environment variables
ENV GOLANG_VERSION="1.19.2"
ENV GORELEASER_VERSION="1.12.3"
ENV GOLANGCI_VERSION="1.50.1"

# Install packages here.
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "${arch}" in \
    aarch64|arm64) \
      ARCH="arm64"; \
      GO_DOWNLOAD_URL="https://go.dev/dl/go${GOLANG_VERSION}.linux-arm64.tar.gz" \
      GORELEASER_DOWNLOAD_URL="https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_Linux_arm64.tar.gz" \
      GOLANGCI_DOWNLOAD_URL="https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}-linux-arm64.tar.gz" \
      ;; \
    x86_64|amd64) \
      ARCH="amd64"; \
      GO_DOWNLOAD_URL="https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" \
      GORELEASER_DOWNLOAD_URL="https://github.com/goreleaser/goreleaser/releases/download/v${GORELEASER_VERSION}/goreleaser_Linux_x86_64.tar.gz" \
      GOLANGCI_DOWNLOAD_URL="https://github.com/golangci/golangci-lint/releases/download/v${GOLANGCI_VERSION}/golangci-lint-${GOLANGCI_VERSION}-linux-amd64.tar.gz" \
      ;; \
  esac; \
  mkdir -p /opt/golang; \
  mkdir -p /opt/tools/goreleaser; \
  mkdir -p /opt/tools/_golangci; \
  curl -L -o /tmp/golang.tar.gz ${GO_DOWNLOAD_URL}; \
  tar -xf /tmp/golang.tar.gz -C /opt/golang; \
  curl -L -o /tmp/goreleaser.tar.gz ${GORELEASER_DOWNLOAD_URL}; \
  tar -xf /tmp/goreleaser.tar.gz -C /opt/tools/goreleaser; \
  curl -L -o /tmp/golangci.tar.gz ${GOLANGCI_DOWNLOAD_URL}; \
  tar -xf /tmp/golangci.tar.gz -C /opt/tools/_golangci; \
  rm /tmp/*.tar.gz;

# Fix up the directory structure for GolangCI tools.
RUN set -eux; \
  mkdir -p /opt/tools/golangci; \
  cp /opt/tools/_golangci/**/LICENSE /opt/tools/golangci/LICENSE; \
  cp /opt/tools/_golangci/**/README.md /opt/tools/golangci/README.md; \
  cp /opt/tools/_golangci/**/golangci-lint /opt/tools/golangci/golangci-lint; \
  rm -rf /opt/tools/_golangci;

USER ${USERNAME}

RUN echo "export PATH=\"\$PATH:/opt/golang/go/bin\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/tools/goreleaser\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/tools/golangci\"" >> /home/${USERNAME}/.bashrc
