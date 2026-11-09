#!/usr/bin/env bash
# One-command launcher. Usage:  ./run.sh        (override any YTLF_* variable by setting it first)
cd "$(dirname "$0")"
[ -f venv/bin/activate ] && . venv/bin/activate

IP="$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)"
[ -z "$IP" ] && { echo "Could not detect LAN IP. Run: YTLF_PUBLIC_BASE=http://<ip>:8080 python server.py"; exit 1; }

export YTLF_PUBLIC_BASE="${YTLF_PUBLIC_BASE:-http://$IP:8080}"
# Old-app compatibility fixes (see START_HERE.md). Set a variable to "" to turn that fix off.
export YTLF_UA="${YTLF_UA-com.google.ios.youtube/19.29.1 (iPhone16,2; U; CPU iOS 17_5_1 like Mac OS X; en_US)}"
export YTLF_DROP_HEADERS="${YTLF_DROP_HEADERS-X-Goog-Device-Auth}"
export YTLF_PB_DROP_MS="${YTLF_PB_DROP_MS-1}"
export YTLF_PB_OSVER="${YTLF_PB_OSVER-17.5.1}"

echo "Serving on $YTLF_PUBLIC_BASE"
exec caffeinate -i python server.py
