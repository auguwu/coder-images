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
ENV DOTNET_VERSION=7.0.202
ENV DEBIAN_FRONTEND=noninteractive
ENV X64_PR="bda88810-e1a6-4cf0-8139-7fd7fe7b2c7a/7a9ffa3e12e5f1c3d8b640e326c1eb14"
ENV ARM_PR="c1fd11b0-186a-4aa1-a578-bb1b6613886e/b67e1c9d6d90b1c99b23935273921fa1"

USER root

RUN apt update && apt install -y build-essential zlib1g openssl
RUN set -eux;                         \
  arch="$(dpkg --print-architecture)"; \
  case "${arch}" in                   \
    aarch64|arm64)                    \
      DOTNET_DOWNLOAD_URL="https://download.visualstudio.microsoft.com/download/pr/${ARM_PR}/dotnet-sdk-${DOTNET_VERSION}-linux-arm64.tar.gz"; \
      ;; \
    amd64|x86_64) \
      DOTNET_DOWNLOAD_URL="https://download.visualstudio.microsoft.com/download/pr/${X64_PR}/dotnet-sdk-${DOTNET_VERSION}-linux-x64.tar.gz"; \
      ;; \
    esac; \
  mkdir -p /opt/dotnet; \
  curl -L ${DOTNET_DOWNLOAD_URL} | tar xfz - -C /opt/dotnet --strip-components=1;

USER ${USERNAME}
ENV PATH=$PATH:/opt/dotnet
ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
