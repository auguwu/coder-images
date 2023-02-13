# ghcr.io/auguwu/coder-images/base:latest
This image is the main base for all of the images in this repository.

## Bundled Software
| Name        | Description                                                                       | Version               |
| ----------- | --------------------------------------------------------------------------------- | --------------------- |
| GitHub CLI  | GitHub's official command line utility                                            | [v2.23.0][github-cli] |
| Coder (OSS) | Remote development environments on your infrastructure provisioned with Terraform | [v0.17.1][coder]      |
| Terraform   | Automate Infrastructure on Any Cloud                                              | [v1.3.8][terraform]   |
| `kubectl`   | kubectl controls the Kubernetes cluster manager.                                  | [v1.26.1][kubectl]    |
| `helm`      | The Kubernetes Package Manager                                                    | [v3.11.1][helm]       |

[github-cli]: https://github.com/cli/cli/releases/tag/v2.23.0
[terraform]:  https://github.com/hashicorp/terraform/releases/tag/v1.3.8
[kubectl]:    https://github.com/kubernetes/kubernetes/releases/tag/v1.26.1
[coder]:      https://github.com/coder/coder/releases/tag/v0.17.1
[helm]:       https://github.com/helm/helm/releases/tag/v3.11.1

### Helm
Helm comes with Bitnami's charts library preconfigured.
