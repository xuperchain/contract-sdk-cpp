FROM golang:1.14 AS builder
RUN apt-get update && apt-get install git

# for arm

RUN git clone https://github.com/xuperchain/xdev.git /data/apps/xdev
WORKDIR /data/apps/xdev

# for arm


RUN make build

# ---
FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]


RUN apt update
# python for emscripten python3 for cmake
RUN apt install -y python3 wget cmake  clang curl git python

WORKDIR /data/apps/emcc
RUN git clone https://github.com/emscripten-core/emsdk.git
WORKDIR /data/apps/emcc/emsdk
RUN ./emsdk install fastcomp-clang-tag-e1.38.30-64bit&& ./emsdk activate fastcomp-clang-tag-e1.38.30-64bit
RUN ./emsdk install node-14.15.5-64bit && ./emsdk activate node-14.15.5-64bit
RUN ./emsdk install  emscripten-1.38.30 && ./emsdk activate emscripten-1.38.30
RUN ./emsdk install binaryen-tag-1.38.30-64bit && ./emsdk activate binaryen-tag-1.38.30-64bit


ENV PATH=/data/apps/emcc/emsdk:/data/apps/emcc/emsdk/fastcomp-clang/tag-e1.38.30/build_tag-e1.38.30_64/bin:/data/apps/emcc/emsdk/node/14.15.5_64bit/bin:/data/apps/emcc/emsdk/emscripten/1.38.30:/data/apps/emcc/emsdk/binaryen/tag-1.38.30_64bit_binaryen/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EMSDK=/data/apps/emcc/emsdk
ENV EM_CONFIG=/data/apps/emcc/emsdk/.emscripten
ENV LLVM_ROOT=/data/apps/emcc/emsdk/fastcomp-clang/tag-e1.38.30/build_tag-e1.38.30_64/bin
ENV EMCC_WASM_BACKEND=0
ENV EMSDK_NODE=/data/apps/emcc/emsdk/node/14.15.5_64bit/bin/node
ENV EM_CACHE=/data/apps/emcc/emsdk/emscripten/1.38.30/cache
ENV EMSCRIPTEN=/data/apps/emcc/emsdk/emscripten/1.38.30
ENV BINARYEN_ROOT=/data/apps/emcc/emsdk/binaryen/tag-1.38.30_64bit_binaryen

# 安装 protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xvf protobuf-cpp-3.7.1.tar.gz
WORKDIR /data/apps/emcc/emsdk/protobuf-3.7.1/
RUN source "/data/apps/emcc/emsdk/emsdk_env.sh" &&emconfigure ./configure && emmake make -j 40 && emmake make install

# build embeded library
WORKDIR /opt/xchain
COPY --from=builder /data/apps/xdev/bin/xdev bin/xdev
COPY src src
COPY xdev.toml xdev.toml

RUN mkdir lib && XEDV_ROOT=`pwd` bin/xdev build -o lib/libxchain.a --compiler host --using-precompiled-sdk=false -s "xchain" -s "xchain/trust_operators"
