#!/usr/bin/env bash
set -Eeuo pipefail

gen_vapid_key() {
    echo "Generating VAPID key..."
    mollysocket vapid gen > "${MOLLY_VAPID_KEY_FILE}"
}

main() {
    test -f "${MOLLY_VAPID_KEY_FILE}" || gen_vapid_key
    "${@}"
}

main "${@}"
