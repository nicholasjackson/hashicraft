DOCKER_NAME=nicholasjackson/minecraft
DOCKER_VERSION=v1.12.2

build:
	cd Docker && docker build -t ${DOCKER_NAME}:${DOCKER_VERSION} .

build_and_push: build
	docker push ${DOCKER_NAME}:${DOCKER_VERSION}

ngrok:
	ngrok tcp 25565