# ghcr.io/auguwu/coder-images/golang:latest
This is the Docker image that bundles the Go compiler with **goreleaser** and **golangci** pre-packaged.

## Bundled Software
| Name       | Description                                        | Version               |
| ---------- | -------------------------------------------------- | --------------------- |
| Go         | The Go programming language                        | [v1.21][golang]       |
| GoReleaser | Deliver Go binaries as fast and easily as possible | [v1.20.0][goreleaser] |
| Golang CI  | Fast linters Runner for Go                         | [v1.54.2][golangci]   |

[goreleaser]: https://github.com/goreleaser/goreleaser/releases/tag/v1.20.0
[golangci]:   https://github.com/golangci/golangci-lint/releases/tag/v1.54.2
[golang]:     https://github.com/golang/go/releases/tag/go1.21.0
