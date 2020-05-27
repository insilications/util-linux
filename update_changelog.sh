#!/usr/bin/bash

set -euo pipefail

fullver=$(< versions)

if [ -f ChangeLog ] && grep -qi "^util-linux $fullver Release Notes$" ChangeLog; then
  # file already updated
  exit 0
fi

basever=$(cut -d. -f1-2 <<< "$fullver")
new=$(mktemp)
trap "rm -f $new" EXIT

(
  curl -LsSf https://mirrors.kernel.org/pub/linux/utils/util-linux/v"$basever"/v"$fullver"-ReleaseNotes
  echo ""
  if [ -f ChangeLog ]; then
    cat ChangeLog
  fi
) > "$new"

mv "$new" ChangeLog
