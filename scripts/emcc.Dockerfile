FROM golang:1.13.1 AS builder
WORKDIR /data/apps
RUN apt update && apt install git
RUN git clone https://github.com/xuperchain/xdev.git
RUN cd xdev && make


# ---
FROM hub.baidubce.com/xchain/emcc:latest
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xf protobuf-cpp-3.7.1.tar.gz
RUN cd protobuf-3.7.1/ && emconfigure ./configure
RUN cd protobuf-3.7.1 && emmake make -j 4
RUN cd protobuf-3.7.1 && emmake make install

WORKDIR /opt/xchain
COPY --from=builder /data/apps/xdev/bin/xdev bin/xdev
COPY . .

RUN mkdir lib && bin/xdev build -o lib/libxchain.a --compiler host  --xdev-root . -s "xchain" -s "xchain/trust_operators"
