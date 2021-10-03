RELEASER_IMAGE=quay.io/helmpack/chart-releaser:v1.0.0
GIT_REPO=helm-charts
OWNER=nanit
TOKEN=$(GITHUB_TOKEN)
DIR=$(shell pwd)

reindex: download-all index

index:
	docker run --rm \
    		-v $(DIR)/charts:/charts \
    		-v $(DIR):/index \
    		$(RELEASER_IMAGE) cr index \
    		-c https://$(OWNER).github.com/$(GIT_REPO) \
    		-r $(GIT_REPO) \
    		-i /index \
    		-o $(OWNER) \
    		-p /charts \
    		-t $(TOKEN)
	@echo "Done updating index file"

download-all: cleanup
	gh release list | awk '{print $$1}' | xargs -I {} gh release download {} -D ./charts

cleanup:
	rm -rf charts
