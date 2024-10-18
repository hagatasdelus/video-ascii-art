FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    libopencv-dev \
    ffmpeg \
    zip \
    clang \
    clang-tools \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY AsciiVideoGenerator.cpp build.sh ./

CMD ["/bin/bash"]
