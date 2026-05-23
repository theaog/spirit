#!/usr/bin/env bash
#
# Spirit Quick Start
# Simple, professional wrapper for zone-based masscan + banner + brute pipeline.
#
# Usage:
#   ./go.sh --zone zone.lst --ports 22,23,2222 [--rate 30000]
#
# The script will:
#   - Auto-install ./spirit (via official installer) if missing
#   - Ensure masscan is available (installs via apt/dnf/yum/pacman/apk when possible)
#   - Backup previous artifacts into ./bak/
#   - Run the full pipeline using spirit subcommands
#
# Must be run with root privileges (sudo ./go.sh ...) because masscan requires raw sockets.
#

set -euo pipefail

# -----------------------------------------------------------------------------
# Colors (only when stdout is a tty)
# -----------------------------------------------------------------------------
if [ -t 1 ]; then
  RED=$'\033[31m'
  GREEN=$'\033[32m'
  YELLOW=$'\033[33m'
  BOLD=$'\033[1m'
  NC=$'\033[0m'
else
  RED='' GREEN='' YELLOW='' BOLD='' NC=''
fi

die() {
  printf '%s\n' "${RED}${BOLD}ERROR:${NC} $*" >&2
  exit 1
}

info() {
  printf '%s\n' "${GREEN}${BOLD}==>${NC} $*"
}

warn() {
  printf '%s\n' "${YELLOW}${BOLD}WARN:${NC} $*"
}

have_cmd() {
  command -v "$1" >/dev/null 2>&1
}

usage() {
  cat <<'EOF'
Usage: ./go.sh --zone FILE --ports LIST [--rate N]

Required:
  -z, --zone FILE      Zone file containing CIDR ranges (one per line)
  -p, --ports LIST     Comma-separated list of ports (e.g. 22,23,2222)

Optional:
  -r, --rate N         Packets per second for masscan (default: 30000)

Examples:
  ./go.sh -z zone.lst -p 22,23,2222
  ./go.sh --zone zone.lst --ports 22 --rate 100000
EOF
  exit 2
}

# -----------------------------------------------------------------------------
# Argument parsing (fail fast)
# -----------------------------------------------------------------------------
ZONE=""
PORTS=""
RATE=30000

while [[ $# -gt 0 ]]; do
  case "$1" in
    -z|--zone)
      [[ $# -ge 2 ]] || die "--zone requires a value"
      ZONE="$2"
      shift 2
      ;;
    -p|--ports)
      [[ $# -ge 2 ]] || die "--ports requires a value"
      PORTS="$2"
      shift 2
      ;;
    -r|--rate)
      [[ $# -ge 2 ]] || die "--rate requires a value"
      RATE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      ;;
    *)
      die "Unknown argument: $1 (use --help for usage)"
      ;;
  esac
done

[[ -n "$ZONE" ]] || usage
[[ -n "$PORTS" ]] || usage
[[ -f "$ZONE" ]] || die "Zone file not found: $ZONE"
[[ "$RATE" =~ ^[0-9]+$ && "$RATE" -gt 0 ]] || die "Rate must be a positive integer"

# -----------------------------------------------------------------------------
# Ensure Spirit binary (downloads via official installer if missing)
# -----------------------------------------------------------------------------
ensure_spirit() {
  if [[ -x ./spirit ]]; then
    return 0
  fi

  info "Spirit binary not found in current directory — downloading..."
  curl -fsSL https://raw.githubusercontent.com/theaog/spirit/master/script/install.sh | sh

  if [[ ! -x ./spirit ]]; then
    die "Failed to install ./spirit. Please run the installer manually or check your network."
  fi

  info "Spirit installed successfully."
}

# -----------------------------------------------------------------------------
# Ensure masscan is available
# -----------------------------------------------------------------------------
ensure_masscan() {
  if ! have_cmd masscan; then
    die "masscan is not installed.

Please install it first, then re-run this script with sudo:
  sudo ./go.sh --zone ... --ports ..."
  fi
}

# -----------------------------------------------------------------------------
# Backup previous run artifacts into ./bak/
# -----------------------------------------------------------------------------
backup_artifacts() {
  local ts
  ts=$(date +%Y%m%d-%H%M%S)

  mkdir -p bak

  local files=(
    open.lst
    h.lst
    b.lst
    found.ssh
    found.login
    found.lst
    found.errors
    found.nologin
  )

  local f backed_up=0
  for f in "${files[@]}"; do
    if [[ -f "$f" ]]; then
      mv "$f" "bak/${f}-${ts}" 2>/dev/null || true
      backed_up=1
    fi
  done

  if [[ $backed_up -eq 1 ]]; then
    info "Previous artifacts backed up to bak/ (timestamp: $ts)"
  fi
}

# -----------------------------------------------------------------------------
# Run the full pipeline
# -----------------------------------------------------------------------------
run_pipeline() {
  info "Starting masscan (zone: $ZONE, ports: $PORTS, rate: $RATE)"
  ./spirit masscan --zone "$ZONE" --ports "$PORTS" --rate "$RATE"

  info "Parsing masscan output..."
  ./spirit parse

  info "Grabbing SSH banners..."
  ./spirit banner

  info "Starting brute-force..."
  ./spirit brute

  info "Pipeline finished."

  if [[ -f found.ssh ]]; then
    printf '\n%s\n' "${BOLD}Top findings (found.ssh):${NC}"
    head -n 20 found.ssh || true
    printf '\n%s\n' "Full results are in: found.ssh, found.login, found.lst"
  else
    echo "No successful logins recorded."
  fi
}

# -----------------------------------------------------------------------------
# Main
# -----------------------------------------------------------------------------
main() {
  info "Spirit Quick Start — zone scan + banner + brute"
  ensure_spirit
  ensure_masscan
  backup_artifacts
  run_pipeline
}

main "$@"
