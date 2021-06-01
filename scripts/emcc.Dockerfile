FROM hub.baidubce.com/xchain/emcc:latest
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xf protobuf-cpp-3.7.1.tar.gz
RUN cd protobuf-3.7.1/ && emconfigure ./configure
RUN cd protobuf-3.7.1 && emmake make -j 4
RUN cd protobuf-3.7.1 && emmake make install

WORKDIR /opt/xchain

RUN HTTPS_PROXY=agent.baidu.com:8118 curl -LO https://github.com/xuperchain/xdev/releases/latest/download/xdev-linux-amd64.tar.gz
RUN tar xf xdev-linux-amd64.tar.gz


COPY . .

RUN bin/xdev build -o lib/libxchain.a --xdevRoot .