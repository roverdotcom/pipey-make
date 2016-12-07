# pipey-make

Base repo for pipey makefile. Pipey makefile is shared via copy to all pipey jobs. It exposes a standard set of 
Makefile targets:

* `docker-build` - Build the docker image
* `docker-shell` - Open a shell inside the pipey container
* `docker-push` - Push the docker image to the repository
* `docker-run` - Run the pipey task in the docker container

It requires that pipey job makefiles define a PKG_NAME variable and include the pipey.Makefile which is copied 
into the repo root. An example from `pipey-example`:

```
include pipey.Makefile
PKG_NAME = roverdotcom/rover-data-pipeline-example:latest
```
