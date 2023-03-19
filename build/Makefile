RM := rm -rf
PKG := ipu6-build
PKGENV := ipu6-env
REPO := local
PWD := $(shell pwd)
BUILD_DATE := $(shell date +"%Y-%m-%-d-%H-%M-%S")
BUILD_DEST := ${PWD}/out/${BUILD_DATE}
VERSION := $(shell grep 'LABEL version' Dockerfile.env | awk -F'=' '{print $$2}' | tr -d '\"')

GIT_REPO_TAG := $(shell git describe --abbrev=0 --tags 2>/dev/null)
GIT_REPO_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null)
# path to get linux-headers-5.15.49-for-ubuntu_5.15.49-for-ubuntu-1_amd64.deb
#PKG_PATH := ${PWD}/../artifactory/

ifeq ($(GIT_REPO_TAG), )
	GIT_REPO_TAG := latest
endif

ifeq ($(GIT_REPO_ROOT), )
	GIT_REPO_ROOT := ./
endif

ifeq ($(PKG_PATH), )
	PKG_PATH := ${PWD}/../artifactory/
endif

all: env build
docker: env

env:
	mkdir -p pkg && cp -r ${PKG_PATH}/* ./pkg/
	docker build -t $(REPO)/$(PKGENV):$(VERSION) \
			--build-arg PKG_PATH=$(PKG_PATH) \
			-f Dockerfile.env ./
	docker tag $(REPO)/$(PKGENV):$(VERSION) $(REPO)/$(PKGENV):latest

build:
	docker build -t $(REPO)/$(PKG):$(VERSION) \
		--build-arg GIT_REPO_ROOT=$(GIT_REPO_ROOT) \
		-f Dockerfile.build $(GIT_REPO_ROOT)
	mkdir -p ${BUILD_DEST}
	docker run --rm -it -v ${BUILD_DEST}:/out/ \
		$(REPO)/$(PKG):$(VERSION) \
		/bin/bash -c 'cp -r /build/results/* /out/; \
		chown -R --reference=/out /out'

push:

tag:
	docker tag $(REPO)$(PKG):$(VERSION) $(REPO)/$(PKG):latest

pack:
#	docker save -o ./$(PKG)_$(VERSION).tar $(REPO)/$(PKG):$(VERSION)
#	gzip -vf $(PKG)_$(VERSION).tar
	echo "Use on target: 'docker load -i $(PKG)_$(VERSION).tar'"

run:
	docker run --rm -it $(REPO)/$(PKG):$(VERSION)

run-env:
	docker run --rm -it $(REPO)/$(PKGENV):$(VERSION)

clean-out:
	${RM} out/* 

clean-env:
	docker rmi $(REPO)/$(PKGENV):latest $(REPO)/$(PKGENV):$(VERSION)
	rm -rf pkg

clean-build:
	docker rmi $(REPO)/$(PKG):$(VERSION)

clean: clean-env clean-build clean-out
	-@echo ' '

clean-all: clean
	
.PHONY: all clean
.SECONDARY:

