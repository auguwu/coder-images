# ghcr.io/auguwu/coder-images/base:latest
This image is the main base for all of the images in this repository.

## Bundled Software
| Name             | Description                                                                       | Version                    |
| ---------------- | --------------------------------------------------------------------------------- | -------------------------- |
| Bazel Buildtools | A bazel BUILD file formatter and editor                                           | [v6.4.0][bazel-buildtools] |
| GitHub CLI       | GitHub's official command line utility                                            | [v2.42.0][github-cli]      |
| Coder (OSS)      | Remote development environments on your infrastructure provisioned with Terraform | [v2.6.0][coder]            |
| Terraform        | Automate Infrastructure on Any Cloud                                              | [v1.6.6][terraform]        |
| Bazelisk         | A user-friendly launcher for Bazel.                                               | [v1.19.0][bazelisk]        |
| `kubectl`        | kubectl controls the Kubernetes cluster manager.                                  | [v1.29.0][kubectl]         |
| `bazel`          | a fast, scalable, multi-language and extensible build system                      | [v7.0.0][bazel]            |
| `helm`           | The Kubernetes Package Manager                                                    | [v3.13.3][helm]            |

[bazel-buildtools]: https://github.com/bazelbuild/buildtools/releases/tag/v6.4.0
[github-cli]:       https://github.com/cli/cli/releases/tag/v2.42.0
[terraform]:        https://github.com/hashicorp/terraform/releases/tag/v1.6.6
[bazelisk]:         https://github.com/bazelbuild/bazelisk/releases/tag/v1.19.0
[kubectl]:          https://github.com/kubernetes/kubernetes/releases/tag/v1.29.0
[coder]:            https://github.com/coder/coder/releases/tag/v2.6.0
[bazel]:            https://github.com/bazelbuild/bazel/releases/tag/7.0.0
[helm]:             https://github.com/helm/helm/releases/tag/v3.13.3

### Helm
Helm comes with Bitnami's charts library preconfigured.
