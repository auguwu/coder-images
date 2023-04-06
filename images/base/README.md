# ghcr.io/auguwu/coder-images/base:latest
This image is the main base for all of the images in this repository.

## Bundled Software
| Name             | Description                                                                       | Version                    |
| ---------------- | --------------------------------------------------------------------------------- | -------------------------- |
| Bazel Buildtools | A bazel BUILD file formatter and editor                                           | [v6.0.1][bazel-buildtools] |
| GitHub CLI       | GitHub's official command line utility                                            | [v2.25.1][github-cli]      |
| Coder (OSS)      | Remote development environments on your infrastructure provisioned with Terraform | [v0.20.1][coder]           |
| Terraform        | Automate Infrastructure on Any Cloud                                              | [v1.4.2][terraform]        |
| Bazelisk         | A user-friendly launcher for Bazel.                                               | [v1.16.0][bazelisk]        |
| `kubectl`        | kubectl controls the Kubernetes cluster manager.                                  | [v1.26.3][kubectl]         |
| `bazel`          | a fast, scalable, multi-language and extensible build system                      | [v6.1.1][bazel]            |
| `helm`           | The Kubernetes Package Manager                                                    | [v3.11.2][helm]            |

[bazel-buildtools]: https://github.com/bazelbuild/buildtools/releases/tag/6.1.0
[github-cli]:       https://github.com/cli/cli/releases/tag/v2.26.1
[terraform]:        https://github.com/hashicorp/terraform/releases/tag/v1.4.4
[bazelisk]:         https://github.com/bazelbuild/bazelisk/releases/tag/v1.16.0
[kubectl]:          https://github.com/kubernetes/kubernetes/releases/tag/v1.26.3
[coder]:            https://github.com/coder/coder/releases/tag/v0.21.3
[bazel]:            https://github.com/bazelbuild/bazel/releases/tag/6.1.1
[helm]:             https://github.com/helm/helm/releases/tag/v3.11.2

### Helm
Helm comes with Bitnami's charts library preconfigured.
