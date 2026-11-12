# Windows setup

This Windows add-on keeps the original Termux files unchanged. It installs the native Windows OpenCode CLI, the `opencode2api` Windows gateway, and a six-exit userspace Cloudflare WARP pool.

## Install

Requirements: Windows 10/11 and Node.js LTS.

No clone needed — run this one line in PowerShell:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/jiro-scopee-dev/opencode-termux-unlimited/main/windows/install.ps1 | iex"
```

Or, from this folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-SakiCode.ps1
```

Open a new terminal, then start it with:

```powershell
sakicode
```

The local gateway uses `127.0.0.1:8080`; its management page is `http://127.0.0.1:8081`.

## Notes

WARP improves reliability for eligible free-model traffic. It does not remove upstream rate limits, grant access to paid models, or guarantee unlimited usage. Model availability remains controlled by the upstream provider.

## Credits

- The Windows launcher: [JiroDev](https://github.com/jiro-scopee-dev).
- The original Termux project and installer design: [leangtg123-art/opencode-termux-unlimited](https://github.com/leangtg123-art/opencode-termux-unlimited), maintained by leangtg123-art, with architectural contributions credited by that project to leanianstudio.
- The Windows-compatible local gateway: [jasonxu114514/opencode2api](https://github.com/jasonxu114514/opencode2api), licensed under GPL-3.0-or-later.
- The OpenCode CLI: [anomalyco/opencode](https://github.com/anomalyco/opencode).
- Cloudflare WARP provides the optional userspace egress capability used by the gateway.
