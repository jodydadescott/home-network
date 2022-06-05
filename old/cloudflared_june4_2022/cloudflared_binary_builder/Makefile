BUILD_NUMBER := latest
PROJECT_NAME := alpine-cloudflared-temp
DOCKER_REGISTRY := jodydadescott
DOCKER_IMAGE_NAME?=$(PROJECT_NAME)
DOCKER_IMAGE_TAG?=$(BUILD_NUMBER)

build:
	$(MAKE) cloudflared.binary

cloudflared.binary:
	docker build -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .
	docker run -it -v $(PWD):/mnt $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh /mnt/helper

shell:
	docker run -it -v $(PWD):/mnt $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh

clean:
	$(RM) cloudflared.binary
