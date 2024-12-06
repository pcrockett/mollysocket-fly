# hadolint ignore=DL3007
FROM ghcr.io/mollyim/mollysocket:latest

ENV MOLLY_WEBSERVER=false \
    MOLLY_VAPID_KEY_FILE=vapid.key \
    RUST_LOG=info

COPY assets/docker-entrypoint.sh /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/mollysocket", "server" ]
