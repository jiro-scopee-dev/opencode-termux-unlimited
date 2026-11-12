# Windows launcher (SakiCode)

This add-on leaves the Termux installation unchanged. It installs the upstream OpenCode CLI for Windows and exposes it as `sakicode`.

Requirements: Windows 10/11 and Node.js LTS (npm included). From this folder, run in PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\Install-SakiCode.ps1
```

Open a new terminal, then use `sakicode` followed by normal OpenCode arguments, for example `sakicode --help`.

The Android-specific `opencode2api` binary and WARP egress pool in the parent installer are Linux/Termux components and are not installed by this Windows launcher. This version installs the Windows-compatible OpenCode CLI only; it does not claim Windows support for that Android gateway.
