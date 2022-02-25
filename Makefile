.PHONY: build test

build:
	./build.sh

test:
	xdev test test/crypto.test.js
	xdev test test/features.test.js
	xdev test test/game_assets.test.js
	# xdev test	
build-image:
	docker build  --build-arg=XDEV_COMMIT_HASH=1262bba3d47ac22a461f907b614eba654d171216 --build-arg=EMSCRIPTEN_VERSION=2.0.34 --network host -t xuper/emcc:dev .  -f scripts/emcc.Dockerfile 
