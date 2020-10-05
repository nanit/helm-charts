RELEASER_IMAGE=quay.io/helmpack/chart-releaser:v1.0.0
GIT_REPO=helm-charts
OWNER=nanit
TOKEN=$(GITHUB_TOKEN)
DIR=$(shell pwd)

index:
	docker run --rm \
		-v $(charts):/charts \
		-v $(DIR):/index \
		$(RELEASER_IMAGE) cr index \
		-c https://$(OWNER).github.com/$(GIT_REPO) \
		-r $(GIT_REPO) \
		-i /index \
		-o $(OWNER) \
		-p /charts \
		-t $(TOKEN)
	@echo "Done updating index file"