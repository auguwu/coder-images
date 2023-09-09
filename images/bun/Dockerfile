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

USER root

# renovate: datasource=github-tags name=oven-sh/bun
ENV BUN_VERSION="0.7.3"

RUN set -eux;                                                                                                              \
    arch="$(dpkg --print-architecture)";                                                                                   \
    case "${arch}" in                                                                                                      \
        aarch64|arm64)                                                                                                     \
            BUN_DOWNLOAD_URL="https://github.com/oven-sh/bun/releases/download/bun-${BUN_VERSION}/bun-linux-aarch64.zip";  \
            ;;                                                                                                             \
        amd64|x86_64)                                                                                                      \
            BUN_DOWNLOAD_URL="https://github.com/oven-sh/bun/releases/download/bun-${BUN_VERSION}/bun-linux-x64.zip";      \
            ;;                                                                                                             \
    esac;                                                                                                                  \
    mkdir -p /opt/oven/bun;                                                                                                \
    curl -L "${BUN_DOWNLOAD_URL}" | bsdtar xf - --strip-components=1 -C /opt/oven/bun;                                     \
    chmod +x /opt/oven/bun/bun

ENV PATH=$PATH:/opt/oven/bun
USER ${USERNAME}

ENV PATH=$PATH:/opt/oven/bun
