# hadolint ignore=DL3007
FROM ghcr.io/mollyim/mollysocket:latest

ENV MOLLY_WEBSERVER=false \
    RUST_LOG=info

CMD [ "server" ]
