#!/bin/sh
# hyperai installer — detects OS/arch, downloads the matching release tarball,
# verifies its SHA-256, and installs the binary to $HOME/.local/bin.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/multigen-ai/hyperai-releases/main/install.sh | sh
#
# Overrides (environment variables):
#   PREFIX   install prefix (default: $HOME/.local; binary goes in $PREFIX/bin)
#   VERSION  specific release tag, e.g. v0.2.0 (default: latest)
set -eu

REPO="multigen-ai/hyperai-releases"
PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"
VERSION="${VERSION:-latest}"

err() { echo "✖ $*" >&2; exit 1; }

detect_os() {
  case "$(uname -s)" in
    Darwin) echo macOS ;;
    Linux)  echo linux ;;
    *)      err "unsupported OS: $(uname -s). Download manually from https://github.com/$REPO/releases" ;;
  esac
}

detect_arch() {
  case "$(uname -m)" in
    x86_64|amd64) echo x86_64 ;;
    arm64|aarch64) echo arm64 ;;
    *) err "unsupported arch: $(uname -m)" ;;
  esac
}

need() { command -v "$1" >/dev/null 2>&1 || err "missing required tool: $1"; }
need curl
need tar
need shasum

OS="$(detect_os)"
ARCH="$(detect_arch)"

if [ "$VERSION" = "latest" ]; then
  VERSION="$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest" \
    | grep -o '"tag_name": *"[^"]*"' | head -n1 | cut -d'"' -f4)"
  [ -n "$VERSION" ] || err "could not resolve latest version"
fi

ASSET="hyperai_${VERSION#v}_${OS}_${ARCH}.tar.gz"
URL="https://github.com/$REPO/releases/download/$VERSION/$ASSET"
SUMS_URL="https://github.com/$REPO/releases/download/$VERSION/checksums.txt"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "→ downloading $ASSET ($VERSION)"
curl -fSL -o "$TMP/$ASSET" "$URL" \
  || err "download failed. Not every release includes $OS/$ARCH — see https://github.com/$REPO/releases"
curl -fSL -o "$TMP/checksums.txt" "$SUMS_URL"

echo "→ verifying checksum"
( cd "$TMP" && grep " $ASSET\$" checksums.txt | shasum -a 256 -c - >/dev/null ) \
  || err "checksum verification failed"

echo "→ extracting"
tar -xzf "$TMP/$ASSET" -C "$TMP"

mkdir -p "$BIN_DIR"
install -m 0755 "$TMP/hyperai" "$BIN_DIR/hyperai"
echo "✔ installed $BIN_DIR/hyperai"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *)
    echo ""
    echo "⚠  $BIN_DIR is not on \$PATH. Add this to your shell rc:"
    echo "   export PATH=\"$BIN_DIR:\$PATH\""
    ;;
esac

"$BIN_DIR/hyperai" --version
