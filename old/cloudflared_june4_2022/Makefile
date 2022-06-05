BUILD_NUMBER := latest
PROJECT_NAME := home-cloudflared
DOCKER_REGISTRY := jodydadescott
DOCKER_IMAGE_NAME?=$(PROJECT_NAME)
DOCKER_IMAGE_TAG?=$(BUILD_NUMBER)

build:
	$(MAKE) cloudflared.binary
	docker build -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

cloudflared.binary:
	cd cloudflared_binary_builder && $(MAKE)
	cp cloudflared_binary_builder/cloudflared.binary .

shell:
	docker run -it $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh

push:
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

clean:
	$(RM) cloudflared.binary
	cd cloudflared_binary_builder && $(MAKE) clean
