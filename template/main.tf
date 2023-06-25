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
      version = "0.8.3"
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
  dir  = data.coder_parameter.volume_dir.value
  os   = "linux"

  metadata {
    display_name = "Processes"
    interval     = 1
    timeout      = 1
    script       = "ps aux | wc -l"
    key          = "proc_count"
  }

  metadata {
    display_name = "CPU Usage"
    interval     = 1
    timeout      = 1
    script       = "vmstat | awk 'FNR==3 {printf \"%2.0f%%\", $13+14+16}'"
    key          = "cpu"
  }

  metadata {
    display_name = "Load Average"
    interval     = 1
    timeout      = 1
    script       = "awk '{print $1}' /proc/loadavg"
    key          = "load"
  }

  metadata {
    display_name = "Disk Usage"
    interval     = 1
    timeout      = 1
    script       = "df -h | awk '$6 ~ /^\\/$/ { print $5 }'"
    key          = "disk"
  }

  metadata {
    display_name = "Docker Containers"
    script       = "docker ps -aq | wc -l"
    interval     = 1
    timeout      = 1
    key          = "containers"
  }

  metadata {
    display_name = "Memory Usage"
    interval     = 1
    timeout      = 1
    script       = "free | awk '/^Mem/ { printf(\"%.0f%%\", $4/$2 * 100.0) }'"
    key          = "memory"
  }

  startup_script = <<-EOL
  #!/bin/bash
  # Fix folder permissions since root owns /home/noel for some reason???
  sudo chown -R $USER:$USER /home/$USER

  # Set default shell to zsh
  sudo chsh -s /usr/bin/zsh $USER
  sudo chsh -s /usr/bin/zsh root

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

  # Clone the given repository if needed
  if ! [ -d "${data.coder_parameter.workspace.value}" ]; then
    ${data.coder_parameter.git_repository.value != "" ? "git clone ${data.coder_parameter.git_repository.value} ${data.coder_parameter.workspace.value}" : "mkdir ${data.coder_parameter.workspace.value}"}
  fi

  if [ -n "${data.coder_parameter.docker_network_name.value}" ]; then
    docker network create "${data.coder_parameter.docker_network_name.value}" --driver=bridge >/dev/null 2>&1
    echo "Created Docker network \`${data.coder_parameter.docker_network_name.value}\`, you can use it with .coder/docker-compose.yml as a external network!"
  fi

  # if ${data.coder_parameter.workspace.value}/.coder exists, then we will run the pre-init scripts
  # and then the Docker Compose project (if any).
  if [ -d "${data.coder_parameter.workspace.value}/.coder" ]; then
    # Run any pre-init scripts in .coder/scripts/pre-init
    if [ -d "${data.coder_parameter.workspace.value}/.coder/scripts/pre-init" ]; then
      files=$(find "${data.coder_parameter.workspace.value}/.coder/scripts/pre-init" -maxdepth 1 -type f -executable -name '*.sh')
      for f in "$files"; do
        (cd "${data.coder_parameter.workspace.value}/.coder" && bash $f) || echo "[coder::preinit] Unable to run pre-init script [$f]"
      done
    fi

    # Run the docker compose project
    if [ -f "${data.coder_parameter.workspace.value}/.coder/docker-compose.yml" ]; then
      dc=""

      if command -v docker-compose &>/dev/null; then
        dc="docker-compose"
      fi

      if command docker compose &>/dev/null; then
        dc="docker compose"
      fi

      if [ -n "$dc" ]; then
        echo "[coder::docker-compose] Using \`$dc\` as the Docker compose command!"
        $dc -f "${data.coder_parameter.workspace.value}/.coder/docker-compose.yml" up -d
      fi
    fi

    # run post-init scripts
    if [ -d "${data.coder_parameter.workspace.value}/.coder/scripts/post-init" ]; then
      files=$(find "${data.coder_parameter.workspace.value}/.coder/scripts/post-init" -maxdepth 1 -type f -executable -name '*.sh')
      for f in "$files"; do
        (cd "${data.coder_parameter.workspace.value}/.coder" && bash $f) || echo "[coder::postinit] Unable to run post-init script [$f]"
      done
    fi
  fi

  # initialize dotfiles
  ${data.coder_parameter.dotfiles.value != "" ? "coder dotfiles \"${data.coder_parameter.dotfiles.value}\" -y" : ""}
  EOL
}

data "docker_registry_image" "image" {
  name = data.coder_parameter.custom_docker_image.value != "" ? data.coder_parameter.custom_docker_image.value : "ghcr.io/auguwu/coder-images/${data.coder_parameter.base_docker_image.value}"
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
    "CODER_ACCESS_URL=https://coder.floofy.dev",
    "TZ=America/Los_Angeles"
  ]

  volumes {
    container_path = data.coder_parameter.volume_dir.value
    host_path      = docker_volume.coder_workspace.mountpoint
  }

  command = ["/bin/bash", "-c", coder_agent.main.init_script]
  runtime = "sysbox-runc"
  image   = docker_image.docker_image.image_id
  name    = data.coder_workspace.me.name
}
