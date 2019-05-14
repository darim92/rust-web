# ------------------------------------------------------------------------------
# Cargo Build Stage
# ------------------------------------------------------------------------------

FROM rust:latest as cargo-build

RUN apt-get update

RUN apt-get install musl-tools -y

RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /usr/src/hello-rocket

COPY Cargo.toml Cargo.toml

RUN mkdir src/

RUN echo "fn main() {println!(\"if you see this, the build broke\")}" > src/main.rs

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

RUN rm -f target/x86_64-unknown-linux-musl/release/deps/hello-rocket*

COPY . .

RUN RUSTFLAGS=-Clinker=musl-gcc cargo build --release --target=x86_64-unknown-linux-musl

# ------------------------------------------------------------------------------
# Final Stage
# ------------------------------------------------------------------------------

FROM alpine:latest

RUN addgroup -g 1000 hello-rocket

RUN adduser -D -s /bin/sh -u 1000 -G hello-rocket hello-rocket

WORKDIR /home/hello-rocket/bin/

COPY --from=cargo-build /usr/src/hello-rocket/target/x86_64-unknown-linux-musl/release/hello-rocket .

RUN chown hello-rocket:hello-rocket hello-rocket

USER hello-rocket

CMD ["./hello-rocket"]