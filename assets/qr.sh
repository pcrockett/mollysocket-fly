#!/usr/bin/env bash
set -Eeuo pipefail

RESET='\033[0m'
BLACK_FOREGROUND='\033[47m'
WHITE_BACKGROUND='\033[0;30m'

main() {
    echo -e "
${WHITE_BACKGROUND}${BLACK_FOREGROUND}
$(mollysocket qr airgapped)
${RESET}
"
}

main
