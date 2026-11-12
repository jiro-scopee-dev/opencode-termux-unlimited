# SakiCode — OpenCode for Windows

A Windows launcher for the OpenCode CLI, with the free-model gateway hooked up and ready to go. Installs into `%LOCALAPPDATA%\SakiCode`, leaves the rest of your system alone, and gives you one command: `sakscode`.

---

## Requirements

- Windows 10/11
- Node.js LTS (npm included)

Open a **new terminal** after installing so the PATH change takes effect.

---

## Install

One line in PowerShell — no clone needed:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/jiro-scopee-dev/opencode-termux-unlimited/main/windows/install.ps1 | iex"
```

Or from a clone, in the `windows/` folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-SakiCode.ps1
```

This installs OpenCode `1.19.5`, downloads the Windows gateway binary, enables the WARP egress pool, and adds `sakscode` to your user PATH.

---

## Usage

```powershell
sakscode            # start OpenCode
sakscode --help     # normal OpenCode arguments work
sakscode models
```

Paths used by the install:

| Path | What it is |
| :--- | :--- |
| `%LOCALAPPDATA%\SakiCode\` | install root |
| `...\bin\sakscode.cmd` | the `sakscode` command |
| `...\proxy\config.json` | gateway config (WARP pool, web UI) |
| `...\opencode.windows.jsonc` | OpenCode provider config |

Web dashboard: `http://127.0.0.1:8081`. The installer replaces the default admin password with a random one — read it from `...\proxy\config.json`.

---

## Gateway commands

```powershell
powershell -File "$env:LOCALAPPDATA\SakiCode\bin\opencode-proxy.ps1" start
```

| Action | What it does |
| :--- | :--- |
| `start` / `stop` / `restart` | run the local gateway on `127.0.0.1:8080` |
| `status` / `test` | show process state and `/healthz` output |
| `logs` | tail proxy logs |
| `kill` | force-stop the proxy |

---

## Notes

- The Android/Termux gateway does **not** run on Windows. This add-on installs the Windows-compatible OpenCode CLI plus the Windows gateway build only.
- Don't run `npm install -g opencode` afterwards — it overwrites the version this launcher expects.

---

## Credits

- Windows launcher and install flow: [JiroDev](https://github.com/jiro-scopee-dev).
- Upstream Termux project this repo is forked from: [leangtg123-art/opencode-termux-unlimited](https://github.com/leangtg123-art/opencode-termux-unlimited), with architecture and reverse-engineering work by Discord user **leanianstudio**.
- OpenCode itself: [opencode.ai](https://opencode.ai).

---

## License

[MIT](LICENSE) — © 2026 leangtg123-art, © 2026 JiroDev for the Windows add-on.
