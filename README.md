# avr-rust dockerized build toolchain

```
RUN git clone https://github.com/avr-rust/blink.git /tmp/blink
RUN cd /tmp/blink && XARGO_RUST_SRC=/usr/local/src/avr-rust rustup run avr-toolchain xargo build --target avr-atmega328p --release
```
