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

terraform {
  required_providers {
    coder = {
      source  = "coder/coder"
      version = "0.6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.14.0"
    }
  }
}

provider "kubernetes" {
  config_path = var.use_host_kubeconfig == true ? "~/.kube/config" : null
}

variable "dotfiles_repo" {
  description = "The repository URL to your dotfiles configuration"
  default     = ""
  type        = string
}

variable "use_host_kubeconfig" {
  description = "This variable allows you to use the host pod's Kubernetes configuration"
  sensitive   = true
  default     = false
  type        = bool
}

variable "namespace" {
  description = "Kubernetes namespace to use for the pod."
  default     = "noel-system"
  type        = string
}

data "coder_workspace" "me" {
}

resource "coder_agent" "main" {
  arch = "arm64"
  dir  = "/home/noel"
  os   = "linux"

  startup_script = <<-EOF
  #!/bin/bash

  function log_cmd {
    echo "[$(date)] $ $@"
    $@ 2>&1 | tee /home/noel/.logs/projector.log
  }

  # This script installs JetBrains Projector, I'm fine with the latency, but
  # you might not.
  PROJECTOR_LOGS=/home/noel/.logs/projector.log
  PROJECTOR_BINARY=/home/noel/.local/bin/projector
  PROJECTOR_CONFIG_PATH=/home/noel/.projector/configs/intellij

  [ ! -d "/home/noel/.logs" ] && mkdir -p /home/noel/.logs
  if [ -f "$PROJECTOR_BINARY" ]; then
    echo "[startup] JetBrains Projector is already installed -- checking for updates..." 2>&1 | tee /home/noel/.logs/projector.log
    $PROJECTOR_BINARY self-update 2>&1 | tee /home/noel/.logs/projector.log
  else
    echo "[startup] Installing JetBrains Projector installer..." | tee /home/noel/.logs/projector.log
    pip3 install projector-installer --user 2>&1 | tee /home/noel/.logs/projector.log
  fi

  if [ -d "$PROJECTOR_CONFIG_PATH" ]; then
    echo "[startup] Projector already has IntelliJ installed! skipping..." 2>&1 | tee /home/noel/.logs/projector.log
  else
    echo "[startup] Installing IntelliJ IDEA Community! This might take a while..." 2>&1 | tee /home/noel/.logs/projector.log
    $PROJECTOR_BINARY ide autoinstall --config-name intellij --ide-name "IntelliJ IDEA Community Edition 2022.2.3" --hostname=localhost --port=3621 2>&1 | tee /home/noel/.logs/projector.log
    grep -iv "HANDSHAKE_TOKEN" $PROJECTOR_CONFIG_PATH/run.sh > temp && mv temp $PROJECTOR_CONFIG_PATH/run.sh 2>&1 | tee -a /home/noel/.logs/projector.log
    chmod +x $PROJECTOR_CONFIG_PATH/run.sh 2>&1 | tee -a /home/noel/.logs/projector.log
    echo "[startup] Installed IntelliJ IDEA Community!" 2>&1 | tee -a /home/noel/.logs/projector.log
  fi

  echo "[startup] Starting JetBrains Projector..." 2>&1 | tee -a /home/noel/.logs/projector.log
  $PROJECTOR_BINARY run intellij &

  # Setup Git
  ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

  ${var.dotfiles_repo != "" ? "coder dotfiles -y ${var.dotfiles_repo}" : ""}

  # Initialize charted-server's code
  mkdir /home/noel/workspace
  git clone https://github.com/charted-dev/charted /home/noel/workspace
  EOF
}

resource "coder_app" "intellij" {
  display_name = "IntelliJ IDEA Community Edition 2022.2.3"
  agent_id     = coder_agent.main.id
  icon         = "/icon/intellij.svg"
  slug         = "intellij"
  url          = "http://localhost:3621/"

  healthcheck {
    url       = "http://localhost:3621/"
    interval  = 6
    threshold = 20
  }
}

resource "kubernetes_persistent_volume_claim" "workspace" {
  metadata {
    namespace = var.namespace
    name      = "charted-server-workspace"
  }

  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_pod" "charted-server" {
  metadata {
    name      = "charted-server"
    namespace = var.namespace

    labels = {
      "k8s.noelware.cloud/component" = "coder",
      "k8s.noelware.cloud/template"  = "charted-server"
    }
  }

  spec {
    security_context {
      run_as_user = "1000"
      fs_group    = "1000"
    }

    container {
      name              = "charted-server-workspace"
      image             = "ghcr.io/auguwu/coder-images/java:latest"
      command           = ["sh", "-c", coder_agent.main.init_script]
      image_pull_policy = "Always"

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
        claim_name = "charted-server-workspace"
        read_only  = false
      }
    }
  }
}
