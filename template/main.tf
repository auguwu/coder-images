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

  metadata {
    display_name = "Docker Containers"
    script       = "docker ps -aq | wc -l"
    interval     = 1
    timeout      = 1
    key          = "containers"
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
    sudo dockerd > /dev/null 2>&1 &
  fi

  # Wait for Docker to start
  while true; do
    if curl -s --unix-socket /var/run/docker.sock http/_ping 2>&1 >/dev/null; then
      echo "Docker Daemon has started!"
      break
    fi

    echo "Waiting for Docker daemon to start..."
    sleep 1
  done

  # Install code-server if enabled
  ${var.install_codeserver == true ? "curl -fsSL https://code-server.dev/install.sh | sh" : ""}
  ${var.install_codeserver == true ? "code-server --auth none --port 3621" : ""}

  # Clone the given repository if needed
  if ! [ -d "${var.workspace_dir}" ]; then
    ${var.git_repository != "" ? "git clone ${var.git_repository} ${var.workspace_dir}" : ""}
  fi

  if ! [ -d "${var.workspace_dir}" ]; then
    mkdir ${var.workspace_dir}
  fi

  if [ -n "${var.docker_network_name}" ]; then
    docker network create "${var.docker_network_name}" --driver=bridge
  fi

  # if ${var.workspace_dir}/.coder exists, then we will run the pre-init scripts
  # and then the Docker Compose project (if any).
  if [ -d "${var.workspace_dir}/.coder" ]; then
    # Run any pre-init scripts in .coder/scripts/pre-init
    if [ -d "${var.workspace_dir}/.coder/scripts/pre-init" ]; then
      files=$(find "${var.workspace_dir}/.coder/scripts/pre-init" -maxdepth 1 -type f -executable -name '*.sh')
      for f in "$files"; do
        (cd "${var.workspace_dir}/.coder" && bash $f) || echo "[coder::preinit] Unable to run pre-init script [$f]"
      done
    fi

    # Run the docker compose project
    if [ -f "${var.workspace_dir}/.coder/docker-compose.yml" ]; then
      dc=""

      if command -v docker-compose &>/dev/null; then
        dc="docker-compose"
      fi

      if command docker compose &>/dev/null; then
        dc="docker compose"
      fi

      if [ -n "$dc" ]; then
        echo "[coder::docker-compose] Using \`$dc\` as the Docker compose command!"
        $dc -f "${var.workspace_dir}/.coder/docker-compose.yml" up -d
      fi
    fi

    # run post-init scripts
    if [ -d "${var.workspace_dir}/.coder/scripts/post-init" ]; then
      files=$(find "${var.workspace_dir}/.coder/scripts/post-init" -maxdepth 1 -type f -executable -name '*.sh')
      for f in "$files"; do
        (cd "${var.workspace_dir}/.coder" && bash $f) || echo "[coder::postinit] Unable to run post-init script [$f]"
      done
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

data "docker_registry_image" "image" {
  name = var.custom_image != "" ? var.custom_image : "ghcr.io/auguwu/coder-images/${var.base_image}:latest"
}

resource "docker_image" "docker_image" {
  name          = data.docker_registry_image.image.name
  pull_triggers = [data.docker_registry_image.image.sha256_digest]
}

resource "docker_volume" "coder_workspace" {
  name = "${data.coder_workspace.me.name}-coder-workspace"
}

resource "docker_container" "workspace" {
  hostname = data.coder_workspace.me.name
  count    = data.coder_workspace.me.start_count
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
  image   = docker_image.docker_image.image_id
  name    = data.coder_workspace.me.name
}
