#!/bin/sh
#
# Spirit installer
# POSIX /bin/sh compatible
# Always installs ./spirit into the current working directory
# Strict checksum verification using bin/checksums.txt
#
# Recommended usage:
#   curl -fsSL https://raw.githubusercontent.com/theaog/spirit/master/script/install.sh | sh
#

set -eu

REPO="https://raw.githubusercontent.com/theaog/spirit/master/bin"
TMPDIR=""
CLEANUP_NEEDED=0

cleanup() {
    if [ "$CLEANUP_NEEDED" -eq 1 ] && [ -n "$TMPDIR" ] && [ -d "$TMPDIR" ]; then
        rm -rf "$TMPDIR"
    fi
}

trap cleanup EXIT INT TERM

die() {
    printf '%s\n' "$*" >&2
    exit 1
}

have_cmd() {
    command -v "$1" >/dev/null 2>&1
}

detect_pkg_manager() {
    if have_cmd apt-get; then
        PKG_MANAGER="apt"
        INSTALL_CMD="DEBIAN_FRONTEND=noninteractive apt-get install -yqq"
    elif have_cmd dnf; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="dnf install -y"
    elif have_cmd yum; then
        PKG_MANAGER="yum"
        INSTALL_CMD="yum install -y"
    elif have_cmd pacman; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="pacman --noconfirm -S"
    elif have_cmd apk; then
        PKG_MANAGER="apk"
        INSTALL_CMD="apk add --no-cache"
    else
        PKG_MANAGER=""
        INSTALL_CMD=""
    fi
}

ensure_tool() {
    tool="$1"
    if ! have_cmd "$tool"; then
        if [ -z "$PKG_MANAGER" ]; then
            die "Missing required tool: $tool and no supported package manager found"
        fi
        printf 'Installing missing tool: %s\n' "$tool"
        # shellcheck disable=SC2086
        $INSTALL_CMD "$tool" || die "Failed to install $tool"
    fi
}

ensure_dependencies() {
    detect_pkg_manager

    # Core tools we need
    ensure_tool curl
    ensure_tool tar

    # Checksum tool - prefer sha256sum, fall back to shasum
    if ! have_cmd sha256sum && ! have_cmd shasum; then
        if [ -n "$PKG_MANAGER" ]; then
            # Try to install coreutils (provides sha256sum on most systems)
            printf 'Installing checksum utilities...\n'
            case "$PKG_MANAGER" in
                apt)   $INSTALL_CMD coreutils || true ;;
                dnf|yum) $INSTALL_CMD coreutils || true ;;
                pacman) $INSTALL_CMD coreutils || true ;;
                apk)   $INSTALL_CMD coreutils || true ;;
            esac
        fi
    fi

    # Final check
    if ! have_cmd sha256sum && ! have_cmd shasum; then
        die "Neither sha256sum nor shasum is available. Cannot verify checksums."
    fi
}

detect_arch() {
    arch=$(uname -m 2>/dev/null || echo unknown)

    case "$arch" in
        x86_64|amd64)
            ASSET="spirit.tgz"
            ;;
        aarch64|arm64)
            ASSET="spirit-arm.tgz"
            ;;
        *)
            die "Unsupported architecture: $arch

Currently supported: x86_64, aarch64"
            ;;
    esac
}

create_temp_dir() {
    if have_cmd mktemp; then
        TMPDIR=$(mktemp -d 2>/dev/null || true)
    fi

    if [ -z "$TMPDIR" ] || [ ! -d "$TMPDIR" ]; then
        TMPDIR="/tmp/spirit_install_$$"
        mkdir -p "$TMPDIR" || die "Failed to create temporary directory"
    fi

    CLEANUP_NEEDED=1
}

download_file() {
    url="$1"
    dest="$2"

    printf 'Downloading %s\n' "$(basename "$url")"
    curl -fsSL "$url" -o "$dest" || die "Failed to download $(basename "$url")"
}

verify_checksums() {
    checksum_file="$1"
    target_file="$2"
    base_name=$(basename "$target_file")

    if have_cmd sha256sum; then
        actual=$(sha256sum "$target_file" | awk '{print $1}')
    elif have_cmd shasum; then
        actual=$(shasum -a 256 "$target_file" | awk '{print $1}')
    else
        die "No checksum tool available for verification"
    fi

    # Extract expected hash for this specific file (handles both "hash  file" and "hash  ./file")
    expected=$(awk -v f="$base_name" '
        $2 == f || $2 == "./" f { print $1; exit }
    ' "$checksum_file" 2>/dev/null || true)

    if [ -z "$expected" ]; then
        die "No checksum entry found for $base_name in checksums.txt"
    fi

    if [ "$actual" != "$expected" ]; then
        die "CHECKSUM MISMATCH for $base_name

Expected: $expected
Actual:   $actual"
    fi

    printf 'Checksum verified: %s\n' "$base_name"
}

install_spirit() {
    tgz="$1"

    printf 'Extracting Spirit...\n'

    tar -xzf "$tgz" -C "$TMPDIR" || die "Failed to extract archive"

    # Find the spirit binary inside the extracted tree
    spirit_bin=$(find "$TMPDIR" -type f -name spirit 2>/dev/null | head -n 1)

    if [ -z "$spirit_bin" ] || [ ! -f "$spirit_bin" ]; then
        die "Could not find 'spirit' binary inside the archive"
    fi

    # Install to current directory
    cp "$spirit_bin" ./spirit || die "Failed to copy spirit binary"
    chmod 0755 ./spirit || die "Failed to make ./spirit executable"

    printf 'Installed ./spirit (in current directory)\n'
}

main() {
    printf 'Spirit Installer (POSIX sh)\n'
    printf 'This will install ./spirit into the current directory.\n\n'

    ensure_dependencies
    detect_arch

    create_temp_dir

    checksums_url="$REPO/checksums.txt"
    asset_url="$REPO/$ASSET"

    download_file "$checksums_url" "$TMPDIR/checksums.txt"
    download_file "$asset_url" "$TMPDIR/$ASSET"

    verify_checksums "$TMPDIR/checksums.txt" "$TMPDIR/$ASSET"

    install_spirit "$TMPDIR/$ASSET"

    printf '\nInstallation complete.\n'
    printf 'Running: ./spirit --version\n\n'

    if ./spirit --version; then
        echo
    else
        printf 'Warning: ./spirit --version did not run successfully.\n'
        printf 'You can try: ./spirit --help\n'
    fi
}

main "$@"
