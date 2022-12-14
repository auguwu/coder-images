# Noel's Coder Template
This template was imported from [auguwu/coder-images/template](https://github.com/auguwu/coder-images/tree/master/template). This is a base template that you can configure when you're creating your workspace. This template supports using Docker or Kubernetes.

## Template Import
### Docker
Create a file called `docker.tfvars` in the root directory where this **README** lives in with the following:

```tf
use_docker = true
```

This will instruct Coder to use Docker rather than Kubernetes when you want to import it:

```shell
# If you're first creating it in your Coder installation
$ coder templates create noel --url=<coder install>

# If you are updating it
$ coder templates push noel --url=<coder install>
```

### Kubernetes
The template's default variables will assume you're using Kubernetes as the main installation route, so you don't need to include a `.tfvars` for it.

```shell
# If you're first creating it in your Coder installation
$ coder templates create noel --url=<coder install>

# If you are updating it
$ coder templates push noel --url=<coder install>
```
