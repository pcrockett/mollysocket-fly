# hadolint ignore=DL3007
FROM ghcr.io/mollyim/mollysocket:latest

RUN touch key

ENV MOLLY_WEBSERVER=false \
    MOLLY_VAPID_KEY_FILE=key \
    RUST_LOG=info

CMD [ "server" ]
