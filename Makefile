VERSION    ?= dev
REPOSITORY ?= esselius/sysdig
IMAGE      ?= $(REPOSITORY)

BUILD_OPTIONS = -t $(IMAGE)
ifdef http_proxy
BUILD_OPTIONS += --build-arg http_proxy=$(http_proxy)
endif
ifdef https_proxy
BUILD_OPTIONS += --build-arg https_proxy=$(https_proxy)
endif
BUILD_OPTIONS += --build-arg application_version=$(VERSION)

RUN_OPTIONS = --privileged
RUN_OPTIONS += -v /var/run/docker.sock:/host/var/run/docker.sock
RUN_OPTIONS += -v /dev:/host/dev
RUN_OPTIONS += -v /proc:/host/proc:ro
RUN_OPTIONS += -v /lib/modules:/host/lib/modules:ro
RUN_OPTIONS += -v /usr:/host/usr:ro
RUN_OPTIONS += -v /usr/bin/docker:/usr/bin/docker:ro

default: csysdig

build:
	docker build --no-cache $(BUILD_OPTIONS) .

push: build
	docker push $(IMAGE)

sysdig:
	docker run -it --rm $(RUN_OPTIONS) $(IMAGE) sysdig

csysdig:
	docker run -it --rm $(RUN_OPTIONS) $(IMAGE) csysdig

clean:
	docker rmi $(IMAGE)
