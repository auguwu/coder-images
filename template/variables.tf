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


variable "base_image" {
  description = "The base image from Noel's Coder images that should be used."
  default     = "base"
  type        = string

  validation {
    condition     = contains(["java", "golang", "base", "node", "rust", ""], var.base_image)
    error_message = "Unknown base image to use"
  }
}

variable "custom_image" {
  description = "The image to use if the base image variable is empty"
  default     = ""
  type        = string
}

variable "home_dir" {
  description = "What directory should be persisted in the Docker volume?"
  default     = "/home/noel"
  type        = string
}

variable "git_repository" {
  description = "Repository URL that is cloned right after the workspace is created"
  default     = ""
  type        = string
}

variable "install_codeserver" {
  description = "If the workspace should include code-server to work on this workspace with Visual Studio Code"
  default     = false
  type        = bool
}

variable "dotfiles_repo" {
  description = "Repository URL of the dotfiles to initialize"
  default     = ""
  type        = string
}
