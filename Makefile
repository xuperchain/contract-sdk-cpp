.PHONY: build test

export XDEV_ROOT=$(shell pwd)
export PATH := $(shell pwd)/../../../output/:$(PATH)

build:
	./build.sh

test:
	xdev test	

build-image:
	docker build -t hub.baidubce.com/xchain/emcc:latest -f scripts/emcc.Dockerfile .

checkout-pb:
	git submodule init && git submodule update
	ln -s ../xupercore/kernel/contract/bridge/pb/contract.proto pb/contract.proto
	ln -s ../xupercore/kernel/contract/bridge/pb/contract.proto pb/contract-service.proto

update-pb:
	git submodule update

build-pb:
	protoc --cpp_out=src/xchain -I pb pb/contract.proto
