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

data "coder_parameter" "workspace" {
  description = "Workspace directory to use to where we clone a Git repository to, or a empty directory if `git_url` is not specified."
  default     = "$HOME/workspace"
  mutable     = false
  type        = "string"
  name        = "Workspace"
  icon        = "${data.coder_workspace.me.access_url}/icon/folder.svg"
}

data "coder_parameter" "volume_dir" {
  description = "Directory to persist for the Docker volume"
  default     = "/home/noel"
  mutable     = false
  type        = "string"
  name        = "Volume Persistence Directory"
  icon        = "${data.coder_workspace.me.access_url}/icon/folder.svg"
}

data "coder_parameter" "base_docker_image" {
  description = "What base Docker image to use? These are dependent of Noel's Coder images available. Use the `custom_docker_image` option to use a custom one."
  default     = "base"
  mutable     = true
  icon        = "${data.coder_workspace.me.access_url}/icon/docker.png"
  name        = "Base Docker Image"
  type        = "string"

  option {
    name  = "Custom"
    value = ""
  }

  option {
    icon  = "${data.coder_workspace.me.access_url}/icon/docker.png"
    name  = "Base (ghcr.io/auguwu/coder-images/base)"
    value = "base"
  }

  option {
    icon  = "${data.coder_workspace.me.access_url}/icon/java.svg"
    name  = "Java (ghcr.io/auguwu/coder-images/java)"
    value = "java"
  }

  option {
    name  = "Go (ghcr.io/auguwu/coder-images/golang)"
    icon  = "https://go.dev/blog/go-brand/Go-Logo/SVG/Go-Logo_Aqua.svg"
    value = "golang"
  }

  option {
    icon  = "${data.coder_workspace.me.access_url}/icon/node.svg"
    name  = "Node.js (ghcr.io/auguwu/coder-images/node)"
    value = "node"
  }

  option {
    icon  = "https://user-images.githubusercontent.com/709451/182802334-d9c42afe-f35d-4a7b-86ea-9985f73f20c3.png"
    name  = "Bun (ghcr.io/auguwu/coder-images/bun)"
    value = "bun"
  }

  option {
    icon  = "https://raw.githubusercontent.com/dotnet/brand/main/logo/dotnet-logo.svg"
    name  = ".NET Core (ghcr.io/auguwu/coder-images/dotnet)"
    value = "dotnet"
  }

  option {
    icon  = "https://raw.githubusercontent.com/rust-lang/rust-artwork/master/logo/rust-logo-128x128.png"
    name  = "Rust (ghcr.io/auguwu/coder-images/rust)"
    value = "rust"
  }
}

data "coder_parameter" "custom_docker_image" {
  description = "Custom Docker image to use if the custom option was set."
  mutable     = true
  default     = ""
  type        = "string"
  name        = "Custom Docker Image"
  icon        = "${data.coder_workspace.me.access_url}/icon/docker.png"

  validation {
    error = "Invalid registry image"

    # Grabbed from https://github.com/distribution/distribution/blob/main/reference/regexp.go#L31-L34
    regex = "(^$)|^((?:(?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9])(?:(?:\\.(?:[a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9-]*[a-zA-Z0-9]))+)?(?::[0-9]+)?/)?[a-z0-9]+(?:(?:(?:[._]|__|[-]*)[a-z0-9]+)+)?(?:(?:/[a-z0-9]+(?:(?:(?:[._]|__|[-]*)[a-z0-9]+)+)?)+)?)(?::([\\w][\\w.-]{0,127}))?(?:@([A-Za-z][A-Za-z0-9]*(?:[-_+.][A-Za-z][A-Za-z0-9]*)*[:][[:xdigit:]]{32,}))?$"
  }
}

data "coder_parameter" "git_repository" {
  description = "Git repository URL to clone into the workspace directory. This can be changed if wished."
  mutable     = true
  default     = ""
  type        = "string"
  name        = "Git Repository"
}

data "coder_parameter" "dotfiles" {
  description = "Git repository URL that holds your files that start with a '.'"
  mutable     = true
  default     = ""
  type        = "string"
  name        = "Dotfiles"
}

data "coder_parameter" "docker_network_name" {
  description = "Name for the Docker network you wish to expose. This is useful for .coder/docker-compose.yml to link services between."
  default     = "fluff"
  mutable     = false
  type        = "string"
  name        = "Docker Network Name"
}
