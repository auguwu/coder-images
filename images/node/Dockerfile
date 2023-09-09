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

# renovate: datasource=github-tags name=nodejs/node
ENV NODE_VERSION="v20.6.1"

RUN set -eux;                                                                                                      \
    arch="$(dpkg --print-architecture)";                                                                           \
    case "${arch}" in                                                                                              \
        aarch64|arm64)                                                                                             \
            NODE_DOWNLOAD_URL="https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-arm64.tar.xz"; \
            ;;                                                                                                     \
        amd64|x86_64)                                                                                              \
            NODE_DOWNLOAD_URL="https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}-linux-x64.tar.xz";   \
            ;;                                                                                                     \
    esac;                                                                                                          \
    mkdir -p /opt/nodejs;                                                                                          \
    curl -L ${NODE_DOWNLOAD_URL} | bsdtar xf - --strip-components=1 -C /opt/nodejs

ENV PATH=$PATH:/opt/nodejs/bin
RUN npm i -g yarn pnpm

USER ${USERNAME}
ENV PATH=$PATH:/opt/nodejs/bin
