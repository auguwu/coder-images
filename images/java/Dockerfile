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

# use April 26th image (since Adoptium doesn't support Ubuntu Lunar yet)
FROM ghcr.io/auguwu/coder-images/base:2023.05.02

ENV USERNAME=noel

# Run as root so we don't have to repeat sudo
USER root

# Set version environment variables
ENV GRADLE_VERSION="8.1.1"
ENV MAVEN_VERSION="3.9.1"

# install required things
RUN DEBIAN_FRONTEND="noninteractive" apt install -y wget libarchive-tools

# Install Temurin 19
RUN wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | sudo apt-key add -
RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | sudo tee /etc/apt/sources.list.d/adoptium.list
RUN DEBIAN_FRONTEND="noninteractive" apt update && \
  DEBIAN_FRONTEND="noninteractive" apt install -y temurin-20-jdk

# Install packages!
RUN GRADLE_DOWNLOAD_URL="https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-all.zip"; \
  MAVEN_DOWNLOAD_URL="https://dlcdn.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz"; \
  mkdir -p /opt/gradle; \
  mkdir -p /opt/maven; \
  curl -L ${MAVEN_DOWNLOAD_URL}   | tar xfz - -C /opt/maven --strip-components=1; \
  curl -L ${GRADLE_DOWNLOAD_URL}  | bsdtar xfz - --strip-components=1 -C /opt/gradle;

RUN chmod +x /opt/gradle/bin/gradle

# Go back as the user
USER ${USERNAME}

ENV PATH=$PATH:/opt/maven/bin:/opt/gradle/bin
