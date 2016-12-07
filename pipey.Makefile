cur-dir := $(shell pwd)

ENVIRONMENT_FLAGS := --env-file ~/.pipey.config --env-file local.config
DOCKER_RUN_OPTS := $(ENVIRONMENT_FLAGS) $(DOCKER_RUN_OPTS)

DONE = echo ✓ $@ done
JSON_GET_VALUE = grep $1 | head -n 1 | sed 's/[," ]//g' | cut -d : -f 2
VERSION = master

# lists all available targets
lis%:
	@sh -c "$(MAKE) -p no_targets__ | awk -F':' '/^[a-zA-Z0-9][^\$$#\/\\t=]*:([^=]|$$)/ {split(\$$1,A,/ /);for(i in A)print A[i]}' | grep -v '__\$$' | grep -v 'make\[1\]' | grep -v 'Makefile' | sort"
# required for list
no_targets__:

docker-buil%:
	touch ~/.pipey.config
	touch local.config
	docker build $(DOCKER_BUILD_OPTS) -t $(PKG_NAME) .
	@$(DONE)

docker-shel%: docker
	docker run --rm -it $(DOCKER_RUN_OPTS) $(PKG_NAME) /bin/sh
	@$(DONE)

docker-tes%: docker
	docker run --rm $(DOCKER_RUN_OPTS) $(PKG_NAME) nosetests
	@$(DONE)

docker-ru%: docker
	docker run --rm -it $(DOCKER_RUN_OPTS) $(PKG_NAME)
	@$(DONE)

docker-pus%: docker
	docker push $(PKG_NAME)
	@$(DONE)

# https://raw.githubusercontent.com/roverdotcom/pipey-make/master/pipey.Makefile
update-tools:
	$(eval LATEST = $(shell curl -fs https://api.github.com/repos/roverdotcom/pipey-make/tags | $(call JSON_GET_VALUE,name)))
	$(if $(filter $(LATEST), $(VERSION)), $(error Cannot update pipey-makefile, as it is already up to date!))
	@curl -sL https://raw.githubusercontent.com/roverdotcom/pipey-make/$(LATEST)/pipey.Makefile > pipey.Makefile
	@perl -p -i -e "s/^VERSION = master/VERSION = ${LATEST}/" pipey.Makefile
	@read -p "Updated tools from $(VERSION) to $(LATEST).  Do you want to commit and push? [y/N] " Y;\
	if [ "$$Y" == "y" ]; then git add pipey.Makefile && git commit -m "Updated tools to $(LATEST)" && git push origin HEAD; fi
	@$(DONE)

.DEFAULT_GOAL := docker-test
