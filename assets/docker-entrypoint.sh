#!/usr/bin/env bash
set -Eeuo pipefail

gen_vapid_key() {
    echo "Generating VAPID key..."
    mollysocket vapid gen > "${MOLLY_VAPID_KEY_FILE}"
}

healthcheck() {
    while true; do
        curl -SsL "${MOLLY_FLY_HEALTHCHECK_URL}" || true
        sleep "${MOLLY_FLY_HEALTHCHECK_INTERVAL:-300}" # default 5 min
    done
}

supervise() {
    # inspired by <https://sirikon.me/posts/0009-pid-1-bash-script-docker-container.html>
    # see article for full line-by-line explanation
    trap 'true' SIGINT SIGTERM
    if [ "${MOLLY_FLY_HEALTHCHECK_URL:-}" != "" ]; then
        healthcheck &
    fi
    exec "${@}" &
    wait -n || true
    kill -s SIGINT -1
    wait
}

main() {
    test -f "${MOLLY_VAPID_KEY_FILE}" || gen_vapid_key

    if [ "${1:-}" == "$(command -v mollysocket)" ] && [ "${2:-}" == "server" ]; then
        # docker container is starting normally; run healthcheck and server together.
        # (assuming healthcheck is configured)
        supervise "${@}"
    else
        # docker container is probably being started interactively. just execute
        # whatever command it is without supervision.
        "${@}"
    fi
}

main "${@}"
