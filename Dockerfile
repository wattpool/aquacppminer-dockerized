FROM debian:sid-slim as builder

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y libssl-dev libcurl4-gnutls-dev libgmp-dev git curl make gcc g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/aquachain/aquacppminer.git && \
    cd  /aquacppminer && bash ./build/setup_linux.sh && bash ./build/make_release_linux.sh && \
    cp bin/aquacppminer* /usr/local/bin/ && cd / && rm -rf /aquacppminer

FROM debian:sid-slim

RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y libssl-dev libcurl4-gnutls-dev libgmp-dev git curl make gcc g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY --from=builder /usr/local/bin/aquacppminer* /usr/local/bin/

CMD ["aquacppminer" "-t" "8" "-F" "http://aquachain.wattpool.net:8888/0x690506ba5dafed57dc05a0d99247af8c6a6e1241"]
