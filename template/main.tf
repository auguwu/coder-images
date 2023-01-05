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
      version = "0.6.5"
    }

    docker = {
      version = "2.25.0"
      source  = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch = "amd64"
  dir  = var.home_dir
  os   = "linux"

  startup_script = <<-EOL
  #!/bin/bash
  if [ ! -f ~/.profile ]; then
    cp /etc/skel/.profile $HOME
  fi

  if [ ! -f ~/.bashrc ]; then
    cp /etc/skel/.bashrc $HOME
  fi

  # Fix folder permissions since root owns /home/noel for some reason???
  sudo chown -R noel:noel /home/noel

  # Install the Docker engine
  #sudo apt update
  #DEBIAN_FRONTEND=noninteractive sudo apt install -y ca-certificates curl gnupg lsb-release
  #sudo mkdir -p /etc/apt/keyrings

  #curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  #echo \
  #  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  #  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list
  
  #sudo apt update && DEBIAN_FRONTEND=noninteractive sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  #sudo systemctl enable --now docker
  #sudo usermod -aG docker $USER

  # Install code-server if enabled
  ${var.install_codeserver == true ? "curl -fsSL https://code-server.dev/install.sh | sh" : ""}
  ${var.install_codeserver == true ? "code-server --auth none --port 3621" : ""}

  # Clone the given repository if needed
  ${var.git_repository != "" ? "git clone ${var.git_repository} ${var.home_dir}/workspace" : ""}
  EOL
}

resource "coder_app" "code-server" {
  count        = var.install_codeserver ? 1 : 0
  agent_id     = coder_agent.main.id
  slug         = "code-server"
  display_name = "Visual Studio Code"
  url          = "http://localhost:3621/?folder=${var.git_repository != "" ? "${var.home_dir}/workspace" : var.home_dir}"
  icon         = "/icon/code.svg"

  healthcheck {
    threshold = 10
    interval  = 10
    url       = "http://localhost:3621/healthz"
  }
}

resource "docker_volume" "coder-workspace" {
  name = "${data.coder_workspace.me.name}-coder-workspace"
}

resource "docker_container" "workspace" {
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "CODER_ACCESS_URL=https://coder.floofy.dev"
  ]

  volumes {
    container_path = "/home/noel"
    host_path      = docker_volume.coder-workspace.mountpoint
  }

  command = ["/bin/bash", "-c", coder_agent.main.init_script]
  image   = var.custom_image != "" ? var.custom_image : "ghcr.io/auguwu/coder-images/${var.base_image}:latest"
  name    = data.coder_workspace.me.name
}
