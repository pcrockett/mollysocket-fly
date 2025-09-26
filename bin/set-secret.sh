#!/usr/bin/env bash
set -euo pipefail

# Interactively set a secret configuration value in your Fly.io app.
#
# Example usage:
#
#     ./bin/set-secret.sh MOLLY_FLY_HEALTHCHECK_URL
#
# This will prompt you to enter the secret MOLLY_FLY_HEALTHCHECK_URL and then restart
# your service with that environment variable set.

main() {
  local secret
  read -rp "Enter value for $1: " secret
  flyctl secrets import <<EOF
$1=${secret}
EOF
}

main "$@"
