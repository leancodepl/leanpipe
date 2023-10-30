#!/usr/bin/env bash

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$DIR/${1}/env.sh"

cat "$DIR/env_templates/${2}.tpl" | envsubst
