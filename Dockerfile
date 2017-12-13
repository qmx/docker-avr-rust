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

FROM rustlang/rust:nightly
COPY --from=0 /opt/avr-rust /opt/avr-rust
COPY --from=0 /usr/local/src/avr-rust /usr/local/src/avr-rust
RUN apt-get update && apt-get install -y avr-libc
RUN rustup toolchain link avr-toolchain /opt/avr-rust
RUN cargo install xargo
