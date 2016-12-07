# pipey-make

Base repo for pipey makefile. Pipey makefile is shared via copy to all pipey jobs. It exposes a standard set of 
Makefile targets:

* `docker-build` - Build the docker image
* `docker-shell` - Open a shell inside the pipey container
* `docker-push` - Push the docker image to the repository
* `docker-run` - Run the pipey task in the docker container

