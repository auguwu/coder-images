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

variable "pvc_name" {
  description = "The existing PVC if one exists"
  default     = ""
  type        = string
}

variable "use_host_kubeconfig" {
  description = "If the template should use the host's Kubernetes configuration or not."
  default     = true
  type        = bool
}

variable "kube_context" {
  description = "The context name of the cluster to connect to."
  default     = ""
  type        = string
}

variable "base_image" {
  description = "If `custom_image` is set to a string that is a valid Docker image, this will be skipped. If not, this will use a base image that is from Noel's Coder images (https://github.com/auguwu/coder-images) from this list"
  default     = ""
  type        = string

  validation {
    condition     = contains(["java", "golang", "base", "node", "rust", ""], var.base_image)
    error_message = "Unknown base image to use"
  }
}

variable "custom_image" {
  description = "The Docker image to use if `base_image` is an empty string."
  default     = ""
  type        = string
}

variable "home_dir" {
  description = "The home directory to persist"
  default     = "/home/noel"
  type        = string
}

variable "git_repository" {
  description = "The Git repository to clone when the pod or container is initializing"
  default     = ""
  type        = string
}

variable "install_codeserver" {
  description = "If the startup script should install Code Server"
  default     = false
  type        = string
}

variable "dotfiles_repo" {
  description = "The repository URL to your dotfiles configuration"
  default     = ""
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to use for the pod."
  default     = "august"
  type        = string
}

variable "kube_host" {
  description = "Kubernetes hostname"
  default = "localhost"
  type = string
}