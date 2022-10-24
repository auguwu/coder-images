# 💐💚 Noel's Coder Templates and Docker Images
> *Optimized, and easy Docker images and Coder templates to use in your everyday work!*

This repository contains the templates and Docker images I built that is optimized for my work. I use [Coder](https://coder.com) to develop my projects when I do not have access to my main computer at home, so, it was easy to install and use.

## Docker Images
### `ghcr.io/auguwu/coder-images/base:latest`
This is the base image that is based off **Arch Linux** since I am most confident of using Arch when developing.

This installs the following packages:
- GitHub CLI
- Coder CLI

### `ghcr.io/auguwu/coder-images/golang:latest`
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbaselatest), but adds the **Go** compiler installed.

### `ghcr.io/auguwu/coder-images/java:latest`
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbaselatest), but bundles Adoptium JDK 19, Gradle, and Maven

### `ghcr.io/auguwu/coder-images/node:latest`
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbaselatest), but bundles **Node.js**.

### `ghcr.io/auguwu/coder-images/rust:latest`
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbaselatest), but bundles all the Rust components required.

### `ghcr.io/auguwu/coder-images/docker:latest`
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbaselatest), but bundles and starts the Docker engine.

### `ghcr.io/auguwu/coder-images/intellij:latest`
This image extends [ghcr.io/auguwu/coder-images/java](#ghcrioauguwucoder-imagesjavalatest), but adds the IntelliJ IDEA IDE into use.

## Coder Templates
### docker-in-k8s
This template allows you to bring in the Docker runtime to use Docker images with the [buildx]() and [Compose v2]() plugins being installed, in a Kubernetes environment.

This will use the `ghcr.io/auguwu/coder-images/docker:latest` image by default to run the Docker engine.

### k8s-intellij
This template allows you to use IntelliJ IDEA CE to build Java or Kotlin applications with, but in a Kubernetes environment.

This will use the `ghcr.io/auguwu/coder-images/intellij:latest` image by default to run the Docker engine.

## License
**coder-images** is released under the **MIT License** with love by me, Noel. <3
