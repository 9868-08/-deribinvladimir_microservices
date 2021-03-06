SHELL = /bin/sh
USER_NAME=deribinvladimir

### adding variables for images versions ###
include ./docker/.env

### Build images ###
build_comment:
	cd ./src/comment && bash ./docker_build.sh

build_post:
	cd ./src/post-py && bash ./docker_build.sh

build_ui:
	cd ./src/ui && bash ./docker_build.sh

build_prometheus:
	cd ./monitoring/prometheus && bash ./docker_build.sh

build_mongodbexporter:
	cd ./monitoring/mongodb_exporter && bash ./docker_build.sh

build_cloudprober:
	cd ./monitoring/cloudprober && bash ./docker_build.sh

build_alertmanager:
	cd ./monitoring/alertmanager && bash ./docker_build.sh

build_grafana:
	cd ./monitoring/grafana && docker build -t $USER_NAME/grafana .

build_stackdriver:
	cd ./monitoring/stackdriver && bash ./docker_build.sh

build_telegraf:
	cd ./monitoring/telegraf && bash ./docker_build.sh

build_all: build_post build_comment build_ui build_mongodbexporter build_cloudprober build_prometheus build_alertmanager build_grafana build_stackdriver build_telegraf

### start env ####

start_all:
	echo '-- starting environment --'
	docker-compose --project-directory docker -f docker/docker-compose.yml up -d
	docker-compose --project-directory docker -f docker/docker-compose-monitoring.yml up -d

### stop env ###

stop_all:
	echo '-- stopping environment --'
	docker-compose --project-directory docker -f docker/docker-compose-monitoring.yml down
	docker-compose --project-directory docker -f docker/docker-compose.yml down

### push images ###

push_comment:
	docker push $(USER_NAME)/comment:latest

push_post:
	docker push ${USER_NAME}/post:latest

push_ui:
	docker push ${USER_NAME}/ui:latest

push_prometheus:
	docker push ${USER_NAME}/prometheus:latest

push_mongodbexporter:
	docker push ${USER_NAME}/percona-mongodb-exporter:${VER_MONGODBEXP}

push_cloudprober:
	docker push ${USER_NAME}/google-cloudprober:${VER_CLOUDPROBER}

push_alertmanager:
	docker push ${USER_NAME}/alertmanager:latest

push_grafana:
	docker push ${USER_NAME}/grafana:latest

push_stackdriver:
	docker push ${USER_NAME}/stackdriver:latest

push_telegraf:
	docker push ${USER_NAME}/telegraf:latest

push_all: push_comment push_post push_ui push_mongodbexporter push_cloudprober push_prometheus push_alertmanager push_grafana push_stackdriver push_telegraf
