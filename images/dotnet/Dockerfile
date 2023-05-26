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

FROM ghcr.io/auguwu/coder-images/base

ENV USERNAME=noel
ENV DOTNET_VERSION=7.0.203
ENV DEBIAN_FRONTEND=noninteractive
ENV X64_PR="ebfd0bf8-79bd-480a-9e81-0b217463738d/9adc6bf0614ce02670101e278a2d8555"
ENV ARM_PR="6cd2eaa7-4c06-4168-b90b-ee2d6bb40b10/4a8387eb07e17d262bfb9965f6d34462"

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
