# hadolint ignore=DL3007
FROM ghcr.io/mollyim/mollysocket:latest

# technically right now the Dockerfile isn't necessary; i could just tell fly to run the
# `mollysocket` image above.
#
# but i do think it's very likely that i'll add to this some day.

CMD [ "server" ]
