FROM debian:stretch
RUN apt-get update
RUN apt-get install -y build-essential git python wget curl cmake libffi-dev
RUN git clone https://github.com/avr-rust/rust.git /usr/local/src/avr-rust
RUN cd /usr/local/src && mkdir build && cd build && ../avr-rust/configure --enable-debug \
  --disable-docs \
  --enable-llvm-assertions \
  --enable-debug-assertions \
  --enable-optimize \
  --prefix=/opt/avr-rust
RUN cd /usr/local/src/build && make
RUN cd /usr/local/src/build && make install

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN set -eux; \
    \
    url="https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init"; \
    wget "$url"; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --default-toolchain nightly-2017-09-24; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

RUN rustup install nightly

RUN apt-get update && apt-get install -y avr-libc
RUN rustup toolchain link avr-toolchain /opt/avr-rust
RUN cargo install xargo --vers 0.3.10
