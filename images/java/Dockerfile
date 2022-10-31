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

# Set version environment variables
ENV JDK_VERSION="18.0.2.1"
ENV GRADLE_VERSION="7.5.1"
ENV MAVEN_VERSION="3.8.6"

# Install packages!
RUN set -eux; \
  arch="$(dpkg --print-architecture)"; \
  GRADLE_DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-7.5.1-all.zip"; \
  MAVEN_DOWNLOAD_URL="https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"; \
  case "${arch}" in \
    aarch64|arm64) \
      ARCH="arm64"; \
      TEMURIN_DOWNLOAD_URL="https://github.com/adoptium/temurin18-binaries/releases/download/jdk-${JDK_VERSION}+1/OpenJDK18U-jdk_arm_linux_hotspot_${JDK_VERSION}_1.tar.gz" \
      ;; \
    x86_64|amd64) \
      ARCH="amd64"; \
      TEMURIN_DOWNLOAD_URL="https://github.com/adoptium/temurin18-binaries/releases/download/jdk-${JDK_VERSION}+1/OpenJDK18U-jdk_x64_linux_hotspot_${JDK_VERSION}_1.tar.gz" \
      ;; \
  esac; \
  mkdir -p /opt/java/jdk; \
  mkdir -p /opt/gradle; \
  mkdir -p /opt/maven; \
  curl -L -s ${TEMURIN_DOWNLOAD_URL} | tar xfz - -C /opt/java/jdk --strip-components=1; \
  curl -L -s ${MAVEN_DOWNLOAD_URL}   | tar xfz - -C /opt/maven --strip-components=1; \
  curl -L -s ${GRADLE_DOWNLOAD_URL}  | bsdtar xvf - --strip-components=1 -C /opt/gradle;

# Go back as the user
USER ${USERNAME}

RUN echo "export PATH=\"\$PATH:/opt/java/jdk/bin\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/maven/bin\"" >> /home/${USERNAME}/.bashrc
RUN echo "export PATH=\"\$PATH:/opt/gradle/bin\"" >> /home/${USERNAME}/.bashrc
RUN echo "export JAVA_HOME=\"/opt/java/jdk\"" >> /home/${USERNAME}/.bashrc
