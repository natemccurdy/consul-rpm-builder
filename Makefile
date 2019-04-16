IMAGE_NAME := consul-rpm
CONTAINER_NAME := consul-rpm

all: builder-image rpm

.PHONY: builder-image rpm vagrant

builder-image: ## Build the image
	docker build --rm -t $(IMAGE_NAME) -f Dockerfile .

rpm: ## Run the image and build the RPM.
	docker run --rm --name $(CONTAINER_NAME) -v $(CURDIR)/artifacts:/tmp/artifacts -t $(IMAGE_NAME)

vagrant: ## Build the RPM in Vagrant then destroy the machine
	vagrant up consul-builder && vagrant destroy -f consul-builder
