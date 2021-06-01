.PHONY: build test

build:
	bash build.sh

test:build
	xdev test	

build-image:
	docker build -t hub.baidubce.com/xchain/emcc:dev -f scripts/emcc.Dockerfile .

