LATEST_RELEASE=$(shell gh release list | grep Latest | awk '{print $$1}')
RELEASER_IMAGE=quay.io/helmpack/chart-releaser:v1.0.0
GIT_REPO=helm-charts
OWNER=nanit
TOKEN=$(GITHUB_TOKEN)
DIR=$(shell pwd)

index: download cleanup
	docker run --rm \
		-v charts:/charts \
		-v $(DIR):/index \
		$(RELEASER_IMAGE) cr index \
		-c https://$(OWNER).github.com/$(GIT_REPO) \
		-r $(GIT_REPO) \
		-i /index \
		-o $(OWNER) \
		-p /charts \
		-t $(TOKEN)
	@echo "Done updating index file"

download:
ifeq (,$(wildcard ./charts/$(LATEST_RELEASE).tgz))
	gh release download $(LATEST_RELEASE) -D ./charts
else
	@echo "$(LATEST_RELEASE) already exists"
endif

cleanup:
	rm -rf charts
