BUILD_NUMBER := latest
PROJECT_NAME := home-sshd
DOCKER_REGISTRY := jodydadescott
DOCKER_IMAGE_NAME?=$(PROJECT_NAME)
DOCKER_IMAGE_TAG?=$(BUILD_NUMBER)

build:
	shellcheck make-config
	shellcheck entrypoint.sh
	$(MAKE) container
	$(MAKE) yaml

container:
	docker build -t $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

shell:
	docker run -it $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) sh

push:
	docker push $(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

yaml:
	@echo "version: '2.2'" > docker-compose.yaml
	@echo "services:" >> docker-compose.yaml
	@echo "  sshd:"  >> docker-compose.yaml
	@echo "    image: \"$(DOCKER_REGISTRY)/$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)\""  >> docker-compose.yaml
	@echo "    container_name: sshd"  >> docker-compose.yaml
	@echo "    restart: always"  >> docker-compose.yaml
