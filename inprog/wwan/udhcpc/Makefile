BUILD_NUMBER := latest
PROJECT_NAME := udhcpc-builder-tmp
DOCKER_REGISTRY := jodydadescott
DOCKER_IMAGE_NAME?=$(PROJECT_NAME)
DOCKER_IMAGE_TAG?=$(BUILD_NUMBER)

bin:
	docker build -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .
	mkdir -p tmp
	docker run --rm -it --volume $(PWD)/tmp:/mnt $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) cp /build/udhcpc /mnt
	mv tmp bin

clean:
	rm -rf bin

shell:
	docker run -it $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh
