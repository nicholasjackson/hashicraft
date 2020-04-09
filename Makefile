DOCKER_NAME=nicholasjackson/minecraft
DOCKER_VERSION=latest

build:
	docker build -t ${DOCKER_NAME}:${DOCKER_VERSION} .

ngrok:
	ngrok tcp 25565