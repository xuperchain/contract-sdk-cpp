FROM golang:1.14 AS builder
RUN apt-get update && apt-get install git

RUN git clone https://github.com/xuperchain/xdev.git /data/apps/xdev
WORKDIR /data/apps/xdev

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
RUN ./emsdk install 1.38.48
RUN ./emsdk activate 1.38.48

# 1.38.48
ENV PATH=/data/apps/emcc/emsdk:/data/apps/emcc/emsdk/fastcomp/emscripten:/data/apps/emcc/emsdk/node/14.15.5_64bit/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV EMSDK=/data/apps/emcc/emsdk
ENV EM_CONFIG=/data/apps/emcc/emsdk/.emscripten
ENV EMSDK_NODE=/data/apps/emcc/emsdk/node/14.15.5_64bit/bin/node



# 安装 protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xvf protobuf-cpp-3.7.1.tar.gz
WORKDIR /data/apps/emcc/emsdk/protobuf-3.7.1/
RUN  emconfigure ./configure --enable-shared=no
RUN  emmake make -j 4
RUN  emmake make install


# # # build embeded library
WORKDIR /opt/xchain
COPY --from=builder /data/apps/xdev/bin/xdev bin/xdev
COPY src src
COPY xdev.toml xdev.toml

RUN mkdir lib && XEDV_ROOT=`pwd` bin/xdev build -o lib/libxchain.a --compiler host --using-precompiled-sdk=false -s "xchain" -s "xchain/trust_operators"


COPY example example
RUN  bin/xdev build -o example/counter.wasm  --compiler host example/counter.cc

RUN chmod 777 -R /data/apps/emcc/emsdk/emscripten/1.38.30/
