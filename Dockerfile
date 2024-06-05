FROM python:3.11.9-slim-bullseye as builder

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        wget \
        make \
        cmake \
        gcc \
        g++ \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app

RUN  pip install cmake

RUN git clone https://github.com/k2-fsa/sherpa-onnx

RUN cd sherpa-onnx && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release .. \
    && make -j6


FROM python:3.11.9-slim-bullseye as prod

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=0 /app/sherpa-onnx/build/bin .
