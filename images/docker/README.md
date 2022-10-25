# ghcr.io/auguwu/coder-images/docker
This image brings in Docker usage... in a Docker container... yeah, it's weird! But, it works.

## Bundled Software
| Name     | Description                                        | Version                     |
| -------- | -------------------------------------------------- | --------------------------- |
| `docker` | Accelerated, Containerized Application Development | [v20.10.20][docker-release] |

### Docker Plugins
| Name             | Description                                                     | Version |
| ---------------- | --------------------------------------------------------------- | ------- |
| `docker compose` | Define and run multi-container applications with Docker         | [v2.12.2][compose-release]  |
| `docker buildx`  | Docker CLI plugin for extended build capabilities with BuildKit | [v0.9.1][buildx-release]   |

[compose-release]: https://github.com/docker/compose/releases/tag/v2.12.2
[docker-release]: https://github.com/moby/moby/releases/tag/v20.10.20
[buildx-release]: https://github.com/docker/buildx/releases/tag/v0.9.1
