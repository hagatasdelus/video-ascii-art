FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    libopencv-dev \
    ffmpeg \
    zip \
    clang \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY AsciiVideoGenerator.cpp MakefileDiver.sh ./

CMD ["/bin/bash"]
