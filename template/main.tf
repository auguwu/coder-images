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

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "kubernetes" {
  config_path = var.use_host_kubeconfig == true ? "~/.kube/config" : null
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

  # Install the Docker engine
  sudo apt update
  sudo apt install ca-certificates curl gnupg lsb-release
  sudo mkdir -p /etc/apt/keyrings

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo apt update && sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin
  sudo systemctl enable --now docker
  sudo usermod -aG docker $USER

  # Install code-server if enabled
  ${var.install_codeserver == true ? "curl -fsSL https://code-server.dev/install.sh | sh" : ""}
  ${var.install_codeserver == true ? "code-server --auth none --port 3621" : ""}

  # Clone the given repository if needed
  ${var.git_repository != "" ? "git clone ${var.git_repository} ${var.home_dir}/workspace" : ""}
  EOL
}

resource "coder_app" "code-server" {
  count    = var.install_codeserver ? 1 : 0
  agent_id = coder_agent.main.id
  slug     = "code-server"
  display  = "Visual Studio Code"
  url      = "http://localhost:3621/?folder=${var.git_repository != "" ? "${var.home_dir}/workspace" : var.home_dir}"
  icon     = "/icon/code.svg"

  healthcheck {
    threshold = 10
    interval  = 10
    url       = "http://localhost:3621/healthz"
  }
}

resource "kubernetes_persistent_volume_claim" "workspace" {
  count = var.pvc_name != "" ? 0 : 1
  metadata {
    namespace = var.namespace
    name      = "workspace-pvc"
  }

  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteMany"]
    resources {
      requests = {
        storage = "15Gi"
      }
    }
  }
}

resource "kubernetes_pod" "workspace" {
  metadata {
    namespace = var.namespace
    name      = "coder-workspace"

    annotations = {
      "k8s.noelware.cloud/component" = "coder",
      "k8s.noelware.cloud/template"  = "code-server"
    }
  }

  spec {
    security_context {
      run_as_user = "1000"
      fs_group    = "1000"
    }

    container {
      image_pull_policy = "Always"
      command           = ["/bin/bash", "-c", coder_agent.main.init_script]
      image             = var.custom_image != "" ? var.custom_image : "ghcr.io/auguwu/coder-images/${var.base_image}:latest"
      name              = "coder-workspace"

      env {
        name  = "CODER_ACCESS_URL"
        value = "https://coder.floofy.dev"
      }

      env {
        name  = "CODER_AGENT_TOKEN"
        value = coder_agent.main.token
      }

      volume_mount {
        mount_path = "/home/noel"
        read_only  = false
        name       = "workspace"
      }

      security_context {
        run_as_user = "1000"
      }
    }

    volume {
      name = "workspace"
      persistent_volume_claim {
        claim_name = "workspace-pvc"
        read_only  = false
      }
    }
  }
}
