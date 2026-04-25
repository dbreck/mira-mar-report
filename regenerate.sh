#!/usr/bin/env bash
# Mira Mar Marketing Report — On-Demand Regeneration
# Usage: ./regenerate.sh
#
# This script:
# 1. Opens the Looker Studio dashboard in Chrome (you may need to authenticate)
# 2. Starts a local preview server
# 3. Reminds you to invoke Claude Code with the generate-report.md prompt

set -e

DASHBOARD_URL="https://lookerstudio.google.com/reporting/67eab629-df7f-46eb-bc09-caeb2c79fc19"
REPORT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$REPORT_DIR"

# Open the Looker dashboard in the default browser
echo "→ Opening Looker dashboard…"
open "$DASHBOARD_URL"

# Start preview server in background
echo "→ Starting preview server on http://localhost:8765"
python3 -m http.server 8765 > /tmp/mira-mar-report-server.log 2>&1 &
SERVER_PID=$!
echo "  Preview PID: $SERVER_PID  (kill $SERVER_PID to stop)"

cat <<EOF

──────────────────────────────────────────────────────────────────────
  Next step: open Claude Code in this directory and ask:

  "Generate this period's Mira Mar marketing report."

  Claude will follow generate-report.md, extract data from the open
  Looker dashboard, and write the new archive entry under /reports/.
──────────────────────────────────────────────────────────────────────

EOF
