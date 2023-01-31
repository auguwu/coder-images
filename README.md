# 💐💚 Noel's Coder Templates and Docker Images
> *Optimized, and easy Docker images and Coder templates to use in your everyday work!*

This repository contains the templates and Docker images I built that is optimized for my work. I use [Coder](https://coder.com) to develop my projects when I do not have access to my main computer at home, so, it was easy to install and use.

## Docker Images
### ghcr.io/auguwu/coder-images/base
This is the base image that is based off **Ubuntu** since that's what I feel the most people are comfortable with Debian-based systems.

This installs the following packages:
- Terraform CLI
- GitHub CLI
- Coder CLI
- **kubectl**
- Helm

### ghcr.io/auguwu/coder-images/golang
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbase), but adds the **Go** compiler installed with GoReleaser and **golangci-lint**

### ghcr.io/auguwu/coder-images/dotnet
This image extends from the [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbase) but adds the **.NET Runtime**.

### ghcr.io/auguwu/coder-images/java
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbase), but bundles Adoptium JDK 19, Gradle, and Maven

### ghcr.io/auguwu/coder-images/node
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbase), but bundles **Node.js**, Yarn, and PNPM.

### ghcr.io/auguwu/coder-images/rust
This image extends [ghcr.io/auguwu/coder-images/base](#ghcrioauguwucoder-imagesbase), but bundles all the Rust components like **rustc**, **Cargo**, **clippy**, and **rustfmt**.

## Coder Template
This project also includes a base [Coder template](./template) to use when using the images. It's personally what I use to develop my own projects with Coder. Refer to the directory's README for more information.

## License
**coder-images** is released under the **MIT License** with love by me, Noel. <3
