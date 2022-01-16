# syntax=docker/dockerfile:1

FROM rust:1.58-alpine as base

RUN apk upgrade -U -a \
    && apk add \
    firefox-esr \
    curl \
    musl-dev
RUN apk add -X http://dl-cdn.alpinelinux.org/alpine/edge/testing geckodriver

RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

RUN rustup target add wasm32-unknown-unknown

WORKDIR /app

COPY Cargo.toml ./
COPY src ./src

RUN cargo check --target wasm32-unknown-unknown

FROM base as test
# CMD ["wasm-pack", "test", "--headless", "--firefox"]
RUN wasm-pack test --headless --firefox
