#!/usr/bin/env bash

set -euo pipefail

for d in javascript; do
    (
        cd "$d"
        ./rebuild.sh
    )
done
