#!/usr/bin/env bash
set -Eeuo pipefail

gen_vapid_key() {
    echo "Generating VAPID key..."
    mollysocket vapid gen > "${MOLLY_VAPID_KEY_FILE}"
}

healthcheck() {
    # periodically ping a healthcheck URL. this should stop running if the mollysocket
    # process stops running, since `supervise` kills processes after the first one
    # exits.

    # we don't want to ping right away; let mollysocket run for a minute before
    # starting the loop.
    sleep 60

    while true; do

        # make sure all connections have "forbidden: false"
        forbidden_status="$(
            mollysocket connection list --anonymized 2>&1 \
            | grep --perl-regexp --only-matching "forbidden: \w+" \
            | awk '{print $2}' \
            | sort \
            | uniq
        )" || true  # don't want this to crash the healthcheck

        if [ "${forbidden_status}" == "false" ]; then
            ping_result="$(
                wget \
                    --timeout 10 \
                    --no-verbose \
                    --output-document - \
                    "${MOLLY_FLY_HEALTHCHECK_URL}" 2>/dev/null || true
            )"
            test "${ping_result}" == "OK" || echo "healthcheck: ${ping_result}"
        else
            echo "healthcheck: unhealthy connection detected"
        fi

        sleep "${MOLLY_FLY_HEALTHCHECK_INTERVAL:-300}" # default 5 min
    done
}

supervise() {
    # inspired by <https://sirikon.me/posts/0009-pid-1-bash-script-docker-container.html>
    # see article for full line-by-line explanation
    trap 'true' SIGINT SIGTERM
    if [ "${MOLLY_FLY_HEALTHCHECK_URL:-}" != "" ]; then
        echo "starting healthcheck..."
        healthcheck &
    fi

    exec "${@}" &
    wait -n || true
    echo "shutting down..."

    # send SIGINT to all processes in this process group
    pkill -SIGINT --pgroup $$

    wait
    return 1  # non-zero exit code makes fly restart the container
}

main() {
    test -f "${MOLLY_VAPID_KEY_FILE}" || gen_vapid_key

    if [ "${1:-}" == "mollysocket" ] && [ "${2:-}" == "server" ]; then
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
