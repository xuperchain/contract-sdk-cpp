.PHONY: build test

export XDEV_ROOT=$(shell pwd)
export PATH := $(shell pwd)/../../../output/:$(PATH)

build:
	./build.sh

test:
	xdev test test/crypto.test.js
	xdev test test/features.test.js
	xdev test test/game_assets.test.js
	xdev test	
build-image:
	docker build  --build-arg=HTTPS_PROXY=agent.baidu.com:8118 --network host -t emcc:v1.0.2 .  -f scripts/emcc.Dockerfile 
