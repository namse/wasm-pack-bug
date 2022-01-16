# syntax=docker/dockerfile:1

FROM rust:1.58-alpine as base

RUN apk upgrade -U -a \
    && apk add \
    chromium \
    curl \
    musl-dev \
    nodejs 

RUN curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh

RUN rustup target add wasm32-unknown-unknown

WORKDIR /app

COPY Cargo.toml ./
COPY src ./src

RUN cargo check --target wasm32-unknown-unknown

FROM base as test
CMD ["wasm-pack", "test", "--headless", "--chrome"]
