# https://github.com/shinh/maloader/blob/0759503416e14051ecbd15c8707a0a15f268ad27/Dockerfile
FROM ubuntu:latest

RUN apt-get update && apt-get install -y build-essential uuid-dev libz-dev
RUN apt-get install -y git

RUN git clone --depth 1 https://github.com/shinh/maloader.git /src
WORKDIR /src

RUN make release

ENV PATH="/src:$PATH"

RUN mkdir /workdir
WORKDIR /workdir
