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

# rust version to install
ENV RUSTUP_VERSION="1.25.1"
ENV RUST_VERSION="1.65.0"

# Install the Rust (minimal) toolchain
RUN apt install -y --no-install-recommends ca-certificates gcc libc6-dev

# We need to install Rust on the user so it can properly add it to the path.
USER ${USERNAME}

RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  case "${arch}" in \
    aarch64|arm64) \
      ARCH="arm64"; \
      ARCH_TRIPLE="aarch64-unknown-linux-gnu"; \
      RUSTUP_INSTALL_URL="https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${ARCH_TRIPLE}/rustup-init"; \
      ;; \
    x86_64|amd64) \
      ARCH="amd64"; \
      ARCH_TRIPLE="x86_64-unknown-linux-gnu"; \
      RUSTUP_INSTALL_URL="https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${ARCH_TRIPLE}/rustup-init"; \
      ;; \
  esac; \
  curl -sL -o /tmp/rustup-init ${RUSTUP_INSTALL_URL}; \
  chmod +x /tmp/rustup-init && /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain ${RUST_VERSION} --default-host=${ARCH_TRIPLE};

ENV PATH="$PATH:/home/${USERNAME}/.cargo/bin"
