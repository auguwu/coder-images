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

  # Setup Git
  ssh-keyscan -t rsa github.com >> ~/.ssh/known_hosts

  ${var.dotfiles_repo != "" ? "coder dotfiles -y ${var.dotfiles_repo}" : ""}

  # Initialize charted-server's code
  mkdir /home/noel/workspace
  git clone https://github.com/charted-dev/charted /home/noel/workspace
  EOF
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
      name    = "charted-server-workspace"
      image   = "ghcr.io/auguwu/coder-images/java:latest"
      command = ["sh", "-c", coder_agent.main.init_script]

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
