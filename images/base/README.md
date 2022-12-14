# ghcr.io/auguwu/coder-images/base:latest
This image is the main base for all of the images in this repository. It uses the **Arch Linux** distribution since I am most comfortable in that distribution, I might provide Debian and Ubuntu variants, if other people use this!

## Bundled Software
| Name        | Description                                                                       | Version               |
| ----------- | --------------------------------------------------------------------------------- | --------------------- |
| GitHub CLI  | GitHub's official command line utility                                            | [v2.20.2][github-cli] |
| Coder (OSS) | Remote development environments on your infrastructure provisioned with Terraform | [v0.13.2][coder]      |
| Terraform   | Automate Infrastructure on Any Cloud                                              | [v1.3.6][terraform]   |
| `kubectl`   | kubectl controls the Kubernetes cluster manager.                                  | [v1.26.0][kubectl]    |
| `helm`      | The Kubernetes Package Manager                                                    | [v3.10.2][helm]       |

[github-cli]: https://github.com/cli/cli/releases/tag/v2.20.2
[terraform]:  https://github.com/hashicorp/terraform/releases/tag/v1.3.6
[kubectl]:    https://github.com/kubernetes/kubernetes/releases/tag/v1.26.0
[coder]:      https://github.com/coder/coder/releases/tag/v0.13.2
[helm]:       https://github.com/helm/helm/releases/tag/v3.10.2

### Helm
Helm comes with Bitnami's charts library preconfigured.
