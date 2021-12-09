.PHONY: build test

export XDEV_ROOT=$(shell pwd)
export PATH := $(shell pwd)/../../../output/:$(PATH)

build:
	./build.sh

test:
	xdev test test/crypto.test.js
	xdev test test/features.test.js
	xdev test test/game_assets.test.js