# hadolint ignore=DL3007
#
# We're going to pin to 1.6 for now, until I figure out this issue:
#
#     <https://github.com/mollyim/mollysocket/issues/111>
#
FROM ghcr.io/mollyim/mollysocket:1.6

# hadolint ignore=DL3008
RUN \
apt-get update && \
apt-get install --yes --no-install-recommends procps htop && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

ENV MOLLY_WEBSERVER=false \
    MOLLY_VAPID_KEY_FILE=vapid.key \
    RUST_LOG=info

COPY assets/*.sh /usr/local/bin/

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD [ "/usr/local/bin/mollysocket", "server" ]
