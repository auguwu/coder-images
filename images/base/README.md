# ghcr.io/auguwu/coder-images/base:latest
This image is the main base for all of the images in this repository.

## Bundled Software
| Name        | Description                                                                       | Version               |
| ----------- | --------------------------------------------------------------------------------- | --------------------- |
| GitHub CLI  | GitHub's official command line utility                                            | [v2.23.0][github-cli] |
| Coder (OSS) | Remote development environments on your infrastructure provisioned with Terraform | [v0.17.4][coder]      |
| Terraform   | Automate Infrastructure on Any Cloud                                              | [v1.3.9][terraform]   |
| Bazelisk    | A user-friendly launcher for Bazel.                                               | [v1.16.0][bazelisk]   |
| `kubectl`   | kubectl controls the Kubernetes cluster manager.                                  | [v1.26.1][kubectl]    |
| `bazel`     | a fast, scalable, multi-language and extensible build system                      | [v6.0.0][bazel]       |
| `helm`      | The Kubernetes Package Manager                                                    | [v3.11.1][helm]       |

[github-cli]: https://github.com/cli/cli/releases/tag/v2.23.0
[terraform]:  https://github.com/hashicorp/terraform/releases/tag/v1.3.9
[bazelisk]:   https://github.com/bazelbuild/bazelisk/releases/tag/v1.16.0
[kubectl]:    https://github.com/kubernetes/kubernetes/releases/tag/v1.26.1
[coder]:      https://github.com/coder/coder/releases/tag/v0.17.4
[bazel]:      https://github.com/bazelbuild/bazel/releases/tag/6.0.0
[helm]:       https://github.com/helm/helm/releases/tag/v3.11.1

### Helm
Helm comes with Bitnami's charts library preconfigured.
