FROM golang:1.14 AS builder
RUN apt-get update && apt-get install git

# TODO fix it 
RUN git clone https://github.com/chenfengjin/xdev.git -b emsdk-latest /data/apps/xdev
RUN ls /data/apps/xdev 
WORKDIR /data/apps/xdev
RUN git pull && make build

# ---
FROM ubuntu:18.04
SHELL ["/bin/bash", "-c"]


RUN apt update
# python for emscripten python3 for cmake
RUN apt install -y python3 wget cmake  clang curl git python

WORKDIR /data/apps
RUN git clone https://github.com/emscripten-core/emsdk.git
WORKDIR /data/apps/emsdk
RUN ./emsdk install 2.0.30
RUN ./emsdk activate 2.0.30

ENV EMSDK=/data/apps/emsdk
ENV EM_CONFIG=/data/apps/emsdk/.emscripten
ENV EMSDK_NODE=/data/apps/emsdk/node/14.15.5_64bit/bin/node
ENV PATH=/data/apps/emsdk:/data/apps/emsdk/upstream/emscripten:/data/apps/emsdk/node/14.15.5_64bit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin


# 安装 protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xvf protobuf-cpp-3.7.1.tar.gz

WORKDIR /data/apps/emsdk/protobuf-3.7.1/cmake/
RUN mkdir build && cd build &&  emcmake cmake  -D protobuf_BUILD_PROTOC_BINARIES=0 -D protobuf_BUILD_TESTS=0 -D protobuf_BUILD_EXAMPLES=0 ..  && emmake make  -j 8  
RUN cd build&& emmake make install 

# # build embeded library
WORKDIR /opt/xchain
COPY --from=builder /data/apps/xdev/bin/xdev bin/xdev
COPY src src
COPY xdev.toml xdev.toml

RUN mkdir lib && XEDV_ROOT=`pwd` bin/xdev build -o lib/libxchain.a --compiler host --using-precompiled-sdk=false -s "xchain" -s "xchain/trust_operators"


COPY example example
RUN  bin/xdev build -o example/counter.wasm  --compiler host example/counter.cc
