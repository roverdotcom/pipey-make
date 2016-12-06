cur-dir := $(shell pwd)

ENVIRONMENT_FLAGS := --env-file ~/.pipey.config --env-file local.config
DOCKER_RUN_OPTS := $(ENVIRONMENT_FLAGS) $(DOCKER_RUN_OPTS)

# lists all available targets
lis%:
	@sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'make\[1\]' | grep -v 'Makefile' | sort"
# required for list
no_targets__:

docke%:
	touch ~/.pipey.config
	touch local.config
	docker build $(DOCKER_BUILD_OPTS) -t $(PKG_NAME) .

# Build the docker container, install the package, and open a shell inside it for testing
docker-shel%: docker
	docker run --rm -it $(DOCKER_RUN_OPTS) $(PKG_NAME) /bin/sh

docker-tes%: docker
	docker run --rm $(DOCKER_RUN_OPTS) $(PKG_NAME) nosetests

docker-ru%: docker
	docker run --rm -it $(DOCKER_RUN_OPTS) $(PKG_NAME)

docker-pus%: docker
	docker push $(PKG_NAME)

update-tools:
	@curl -sL https://raw.githubusercontent.com/roverdotcom/pipey-make/master/pipey.Makefile > pipey.Makefile

.DEFAULT_GOAL := docker-test
