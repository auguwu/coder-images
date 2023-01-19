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
ENV DOTNET_VERSION=7.0.102
ENV DEBIAN_FRONTEND=noninteractive
ENV X64_PR="c646b288-5d5b-4c9c-a95b-e1fad1c0d95d/e13d71d48b629fe3a85f5676deb09e2d"
ENV ARM_PR="72ec0dc2-f425-48c3-97f1-dc83740ba400/78e8fa01fa9987834fa01c19a23dd2e7"

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
