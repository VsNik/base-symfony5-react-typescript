init: app-init
ud: docker-up
down: docker-down
down-clear: docker-down-clear

app-init: docker-down-clear docker-pull docker-build docker-up

docker-build:
	docker-compose build

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphan

docker-down-clear:
	docker-compose down --remove-orphan -v

docker-pull:
	docker-compose pull




