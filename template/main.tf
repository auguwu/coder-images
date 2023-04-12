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

terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.7.0"
    }

    docker = {
      version = "3.0.2"
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "coder_git_auth" "github" {
  id = "noel-git"
}

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch = "amd64"
  dir  = var.home_dir
  os   = "linux"
  metadata {
    display_name = "Processes"
    key          = "proc_count"
    script       = "ps aux | wc -l"
    interval     = 1
    timeout      = 1
  }

  # metadata {
  #   display_name = "Docker Containers"
  #   key = "docker_containers"
  #   script = ""
  #   interval = 1
  #   timeout = 1
  # }

  metadata {
    display_name = "Load Average"
    key          = "load"
    script       = "awk '{print $1}' /proc/loadavg"
    interval     = 1
    timeout      = 1
  }

  metadata {
    display_name = "Disk Usage"
    key          = "disk"
    script       = "df -h | awk '$6 ~ /^\\/$/ { print $5 }'"
    interval     = 1
    timeout      = 1
  }

  startup_script = <<-EOL
  #!/bin/bash
  # Fix folder permissions since root owns /home/noel for some reason???
  sudo chown -R noel:noel /home/noel

  if [ ! -f ~/.profile ]; then
    cp /etc/skel/.profile $HOME/.profile
  fi

  if [ ! -f ~/.bashrc ]; then
    cp /etc/skel/.bashrc $HOME/.bashrc
  fi

  # Run Docker in the background
  if command -v dockerd &> /dev/null; then
    sudo dockerd &
  fi

  # Install code-server if enabled
  ${var.install_codeserver == true ? "curl -fsSL https://code-server.dev/install.sh | sh" : ""}
  ${var.install_codeserver == true ? "code-server --auth none --port 3621" : ""}

  # I don't know why this happens but, the base Rust image loses all information, so we
  # will re-run the rustup-init script, which is still present.
  if [ -x /tmp/rustup-init ]; then
    /tmp/rustup-init -y --no-modify-path --profile minimal --default-toolchain nightly --default-host=x86_64-unknown-linux-gnu
    source $HOME/.cargo/env

    rustup component add clippy rustfmt
  fi

  # Clone the given repository if needed
  if ! [ -d "${var.workspace_dir}" ]; then
    ${var.git_repository != "" ? "git clone ${var.git_repository} ${var.workspace_dir}" : ""}
  fi

  if ! [ -d "${var.workspace_dir}" ]; then
    mkdir ${var.workspace_dir}
  fi

  # if ${var.workspace_dir}/.coder exists, then we will run the pre-init scripts
  # and then the Docker Compose project (if any).
  if [ -d "${var.workspace_dir}/.coder" ]; then
    # Run any pre-init scripts in .coder/scripts/pre-init
    if [ -d "${var.workspace_dir}/.coder/scripts/pre-init" ]; then
      # run pre-init scripts
    fi

    # Run the docker compose project
    if [ -f "${var.workspace_dir}/.coder/docker-compose.yml" ]; then
      # run it
    fi

    # run post-init scripts
    if [ -d "${var.workspace_dir}/.coder/scripts/post-init" ]; then
      # run post-init scripts
    fi
  fi

  # initialize dotfiles
  ${var.dotfiles_repo != "" ? "coder dotfiles -y ${var.dotfiles_repo}" : ""}
  EOL
}

resource "coder_app" "code-server" {
  count        = var.install_codeserver ? 1 : 0
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "Visual Studio Code"
  url          = "http://localhost:3621/?folder=${var.workspace_dir}"
  icon         = "/icon/code.svg"

  healthcheck {
    threshold = 10
    interval  = 10
    url       = "http://localhost:3621/healthz"
  }
}

resource "docker_volume" "coder_workspace" {
  name = "${data.coder_workspace.me.name}-coder-workspace"
}

resource "docker_container" "workspace" {
  count = data.coder_workspace.me.start_count
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "CODER_ACCESS_URL=https://coder.floofy.dev"
  ]

  volumes {
    container_path = var.home_dir
    host_path      = docker_volume.coder_workspace.mountpoint
  }

  command = ["/bin/bash", "-c", coder_agent.main.init_script]
  runtime = "sysbox-runc"
  image   = var.custom_image != "" ? var.custom_image : "ghcr.io/auguwu/coder-images/${var.base_image}:latest"
  name    = data.coder_workspace.me.name
}
