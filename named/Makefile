BUILD_NUMBER := latest
PROJECT_NAME := home-named
DOCKER_REGISTRY := jodydadescott
DOCKER_IMAGE_NAME?=$(PROJECT_NAME)
DOCKER_IMAGE_TAG?=$(BUILD_NUMBER)

build:
	shellcheck make-example-config
	shellcheck entrypoint.sh
	$(MAKE) yaml
	$(MAKE) container

container:
	docker build -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

shell:
	docker run -it $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh

push:
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

yaml:
	@echo "version: '2.2'" > docker-compose.yaml
	@echo "services:" >> docker-compose.yaml
	@echo "  named:"  >> docker-compose.yaml
	@echo "    image: \"$(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)\""  >> docker-compose.yaml
	@echo "    container_name: named"  >> docker-compose.yaml
	@echo "    restart: always"  >> docker-compose.yaml
