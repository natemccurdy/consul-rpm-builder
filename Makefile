IMAGE_NAME := consul-rpm
CONTAINER_NAME := consul-rpm

all: builder-image build-all-rpms

.PHONY: consul consul-template builder-image build-all-rpms build-consul-rpm build-consul-template-rpm vagrant

consul:          builder-image build-consul-rpm
consul-template: builder-image build-consul-template-rpm

builder-image: ## Build the image
	docker build --rm -t $(IMAGE_NAME) -f Dockerfile .

build-all-rpms: ## Run the image and build all the RPM's
	docker run --rm --name $(CONTAINER_NAME) -v $(CURDIR)/artifacts:/tmp/artifacts -e SPEC_FILE=all -t $(IMAGE_NAME)

build-consul-rpm: ## Run the image and build consul
	docker run --rm --name $(CONTAINER_NAME) -v $(CURDIR)/artifacts:/tmp/artifacts -e SPEC_FILE=consul -t $(IMAGE_NAME)

build-consul-template-rpm: ## Run the image and build consul-template
	docker run --rm --name $(CONTAINER_NAME) -v $(CURDIR)/artifacts:/tmp/artifacts -e SPEC_FILE=consul-template -t $(IMAGE_NAME)

vagrant: ## Build the RPM in Vagrant then destroy the machine
	vagrant up consul-builder && vagrant destroy -f consul-builder
