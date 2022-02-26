FROM golang:1.14 AS builder
RUN apt-get update && apt-get install git
ARG XDEV_COMMIT_HASH=5d4e404afbe8be9b8b63149255561206ea0bfbd9
ARG GOPROXY
ARG GO111MODULE
RUN git clone https://github.com/xuperchain/xdev.git /data/apps/xdev && \
    cd  /data/apps/xdev && git checkout ${XDEV_COMMIT_HASH} && make build

# ---
FROM ubuntu:focal AS stage_build
ARG EMSCRIPTEN_VERSION=2.0.34
ENV EMSDK /emsdk
# ------------------------------------------------------------------------------
# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
# RUN sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN apt update 
RUN echo "## Start building" \
    && echo "## Update and install packages" \
    && apt-get -qq -y update \
    && apt-get -qq install -y --no-install-recommends \
    binutils \
    build-essential \
    ca-certificates \
    file \
    git \
    python3 \
    python3-pip \
    && echo "## Done"

# Copy the contents of this repository to the container
# COPY . ${EMSDK}
RUN git clone https://github.com/emscripten-core/emsdk.git 

RUN echo "## Install Emscripten" \
    && cd ${EMSDK} \
    && ./emsdk install ${EMSCRIPTEN_VERSION} \
    && echo "## Done"

# This generates configuration that contains all valid paths according to installed SDK
# TODO(sbc): We should be able to use just emcc -v here but it doesn't
# currently create the sanity file.
RUN cd ${EMSDK} \
    && echo "## Generate standard configuration" \
    && ./emsdk activate ${EMSCRIPTEN_VERSION} \
    && chmod 777 ${EMSDK}/upstream/emscripten \
    && chmod -R 777 ${EMSDK}/upstream/emscripten/cache \
    && echo "int main() { return 0; }" > hello.c \
    && ${EMSDK}/upstream/emscripten/emcc -c hello.c \
    && cat ${EMSDK}/upstream/emscripten/cache/sanity.txt \
    && echo "## Done"

# Cleanup Emscripten installation and strip some symbols
RUN echo "## Aggressive optimization: Remove debug symbols" \
    && cd ${EMSDK} && . ./emsdk_env.sh \
    # Remove debugging symbols from embedded node (extra 7MB)
    && strip -s `which node` \
    # Tests consume ~80MB disc space
    && rm -fr ${EMSDK}/upstream/emscripten/tests \
    # Fastcomp is not supported
    && rm -fr ${EMSDK}/upstream/fastcomp \
    # strip out symbols from clang (~extra 50MB disc space)
    && find ${EMSDK}/upstream/bin -type f -exec strip -s {} + || true \
    && echo "## Done"

# ------------------------------------------------------------------------------
# -------------------------------- STAGE DEPLOY --------------------------------
# ------------------------------------------------------------------------------

FROM ubuntu:focal AS stage_deploy

COPY --from=stage_build /emsdk /emsdk

# Fallback in case Emscripten isn't activated.
# This will let use tools offered by this image inside other Docker images
# (sub-stages) or with custom / no entrypoint
ENV EMSDK=/emsdk \
    EM_CONFIG=/emsdk/.emscripten \
    EMSDK_NODE=/emsdk/node/14.18.2_64bit/bin/node \
    PATH="/emsdk:/emsdk/upstream/emscripten:/emsdk/upstream/bin:/emsdk/node/14.18.2_64bit/bin:${PATH}"

# ------------------------------------------------------------------------------
# Create a 'standard` 1000:1000 user
# Thanks to that this image can be executed as non-root user and created files
# will not require root access level on host machine Please note that this
# solution even if widely spread (i.e. Node.js uses it) is far from perfect as
# user 1000:1000 might not exist on host machine, and in this case running any
# docker image will cause other random problems (mostly due `$HOME` pointing to
# `/`)
RUN echo "## Create emscripten user (1000:1000)" \
    && groupadd --gid 1000 emscripten \
    && useradd --uid 1000 --gid emscripten --shell /bin/bash --create-home emscripten \
    && echo "umask 0000" >> /etc/bash.bashrc \
    && echo ". /emsdk/emsdk_env.sh" >> /etc/bash.bashrc \
    && echo "## Done"

# ------------------------------------------------------------------------------
# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list &&  sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
RUN echo "## Update and install packages" \
    && apt-get -qq -y update \
    # Somewhere in here apt sets up tzdata which asks for your time zone and blocks
    # waiting for the answer which you can't give as docker build doesn't read from
    # the terninal. The env vars set here avoid the interactive prompt and set the TZ.
    && DEBIAN_FRONTEND="noninteractive" TZ="America/San_Francisco" apt-get -qq install -y --no-install-recommends \
    sudo \
    libxml2 \
    ca-certificates \
    python3 \
    python3-pip \
    wget \
    curl \
    zip \
    unzip \
    git \
    git-lfs \
    ssh-client \
    build-essential \
    make \
    ant \
    libidn11 \
    cmake \
    openjdk-11-jre-headless \
    # Standard Cleanup on Debian images
    && apt-get -y clean \
    && apt-get -y autoclean \
    && apt-get -y autoremove \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/debconf/*-old \
    && rm -rf /usr/share/doc/* \
    && rm -rf /usr/share/man/?? \
    && rm -rf /usr/share/man/??_* \
    && echo "## Done"

# ------------------------------------------------------------------------------
# Use commonly used /src as working directory
WORKDIR /src

LABEL maintainer="1871653365@qq.com" \
    org.label-schema.name="chenfengjin" \
    org.label-schema.description="The official container of XuperChain contract sdk" \
    org.label-schema.url="xuper.baidu.com" \
    org.label-schema.vcs-url="https://github.com/xuperchain/contract-sdk-cpp" \
    org.label-schema.docker.dockerfile="/docker/Dockerfile"

# ------------------------------------------------------------------------------

# 安装 protobuf
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xvf protobuf-cpp-3.7.1.tar.gz

WORKDIR /src/protobuf-3.7.1/cmake/
RUN mkdir build && cd build &&  emcmake cmake  -D protobuf_BUILD_PROTOC_BINARIES=0 \
    -D protobuf_BUILD_TESTS=0 -D protobuf_BUILD_EXAMPLES=0 ..  && emmake make  -j 8  
RUN cd build&& emmake make install 
RUN rm -rf /src/protobuf-3.7.1
RUN rm -rf /src/protobuf-cpp-3.7.1.tar.gz

# # build embeded library
WORKDIR /opt/xchain
COPY --from=builder /data/apps/xdev/bin/xdev bin/xdev
COPY src src
COPY xdev.toml xdev.toml

RUN mkdir lib && XEDV_ROOT=`pwd` bin/xdev build -o lib/libxchain.a --compiler host --using-precompiled-sdk=false -s "xchain" -s "xchain/trust_operators"
