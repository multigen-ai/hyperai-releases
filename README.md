# hyperai-releases

Public release artifacts for the [`hyperai`](https://hyperfx.ai) CLI.

The CLI source lives in a private monorepo (`multigen-ai/hyperai-clients`).
Tagged binary releases are pushed here so anyone can `curl` them without
needing access to the source.

## Install

Pick your platform and download from the latest release:

```bash
# macOS arm64
curl -fsSL -o /usr/local/bin/hyperai \
  https://github.com/multigen-ai/hyperai-releases/releases/latest/download/hyperai-darwin-arm64
chmod +x /usr/local/bin/hyperai

# macOS x64
curl -fsSL -o /usr/local/bin/hyperai \
  https://github.com/multigen-ai/hyperai-releases/releases/latest/download/hyperai-darwin-x64
chmod +x /usr/local/bin/hyperai

# Linux x64
curl -fsSL -o /usr/local/bin/hyperai \
  https://github.com/multigen-ai/hyperai-releases/releases/latest/download/hyperai-linux-x64
chmod +x /usr/local/bin/hyperai

# Linux arm64
curl -fsSL -o /usr/local/bin/hyperai \
  https://github.com/multigen-ai/hyperai-releases/releases/latest/download/hyperai-linux-arm64
chmod +x /usr/local/bin/hyperai
```

Windows: download `hyperai-windows-x64.exe` from the latest release.

## Verify

```bash
hyperai --help
hyperai --version
```

## Other install channels

- Python: `uv tool install hyperai-cli` or `pipx install hyperai-cli`
- TypeScript / Node: `npm install -g @hyperai/cli`

All channels ship the same `hyperai` command from the same source.
