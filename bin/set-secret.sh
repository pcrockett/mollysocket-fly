#!/usr/bin/env bash
set -euo pipefail

main() {
    local secret
    read -rp "Enter value for $1: " secret
    flyctl secrets import <<EOF
$1=${secret}
EOF
}

main "$@"
