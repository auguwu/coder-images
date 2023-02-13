# 💐💚 coder-images: Optimized, and easy Docker images and Coder templates to use in your everyday work!
# Copyright (c) 2022-2023 Noel <cutie@floofy.dev>
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
ENV GOLANG_VERSION="1.20"
ENV GORELEASER_VERSION="1.15.2"
ENV GOLANGCI_VERSION="1.51.1"

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
  mkdir -p /opt/golang/go /opt/golang/tools/golangci /opt/golang/tools/goreleaser; \
  curl -L ${GO_DOWNLOAD_URL}         | tar xfz - -C /opt/golang/go --strip-components=1 --no-same-owner; \
  curl -L ${GORELEASER_DOWNLOAD_URL} | tar xfz - -C /opt/golang/tools/goreleaser --no-same-owner; \
  curl -L ${GOLANGCI_DOWNLOAD_URL}   | tar xfz - -C /opt/golang/tools/golangci --strip-components 1 --no-same-owner;

USER ${USERNAME}

ENV PATH=$PATH:/opt/golang/go/bin:/opt/golang/tools/goreleaser:/opt/golang/tools/golangci
