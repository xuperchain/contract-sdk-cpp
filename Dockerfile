FROM trzeci/emscripten:1.38.48
RUN curl -LO https://github.com/protocolbuffers/protobuf/releases/download/v3.7.1/protobuf-cpp-3.7.1.tar.gz
RUN tar xf protobuf-cpp-3.7.1.tar.gz
RUN cd protobuf-3.7.1/ && emconfigure ./configure
RUN cd protobuf-3.7.1 && emmake make -j 4
RUN cd protobuf-3.7.1 && emmake make install

COPY . .
RUN mkdir build && cd build && emconfigure cmake .. && emmake make
RUN cd build && emmake make install