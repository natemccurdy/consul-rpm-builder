PWD := $(shell pwd)
IMAGE_NAME := consul-rpm
CONTAINER_NAME := consul-rpm

all: builder-image rpm

.PHONY: builder-image rpm

builder-image: ## Build the image
	docker build --rm -t $(IMAGE_NAME) -f Dockerfile .

rpm: ## Run the image and build the RPM.
	docker run --rm --name $(CONTAINER_NAME) -v $(PWD)/artifacts:/tmp/artifacts -t $(IMAGE_NAME)
