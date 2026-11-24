# Sunviz

**Sunviz is an unofficial fork / modification of the original FLP In Video (FLP to Video) script.**
It preserves the original FL Studio-to-VEGAS workflow and adds ZIP project discovery, safer temporary
extraction, language selection, a Sunviz icon, and other workflow improvements.

## Requirements

- Windows
- VEGAS Pro 16 or newer
- .NET Framework 4.8 recommended
- `flp2json.exe` (included)

## Install

1. For the simplest install, run `install.ps1` in PowerShell. It copies `Sunviz.cs`, its matching `Sunviz.cs.png` icon, `Sunviz.ico`, and `flp2json.exe` to `%USERPROFILE%\Documents\Vegas Script Menu`.
2. In VEGAS, choose **Tools > Scripting > Rescan Script Menu Folder**, or restart VEGAS.
3. Launch `Sunviz` from **Tools > Scripting**. If you prefer the compiled DLL, build it with `build.ps1` and keep `Sunviz.dll.png` beside `Sunviz.dll`.

## Use

1. Select a video event on the VEGAS timeline, or prepare Project Media subclips named after
   FL Studio channels / samples.
2. Run Sunviz.
3. Choose an `.flp` file or a `.zip` archive containing one or more `.flp` files.
4. If the ZIP contains multiple FLP projects, select the project in the selection dialog.
5. Choose channels and generation options, then press **Generate**.
6. Generated video tracks are inserted at the top of the VEGAS track stack. Use Ctrl+Z to undo
   the complete generation operation.

## ZIP handling

ZIP files are extracted without external tools and without a dependency on
`System.IO.Compression.FileSystem`:

1. Primary path uses `System.IO.Compression.ZipArchive` via reflection (pure managed code).
2. If that fails for any reason, Sunviz falls back to the built-in Windows Explorer
   `Shell.Application` ZIP support (the same mechanism Explorer uses for .zip folders).

Entries are written into a unique temporary directory with path-traversal checks.
The extracted FLP and temporary JSON are removed after parsing. The original ZIP is never modified.

## Languages

The main window includes a language selector for **English**, **Русский**, and **Español**.
The selected language is saved in `%APPDATA%\Sunviz\settings.txt`.
Most UI labels, tabs, segmented buttons (Placement / Timing / Notes options) and common messages
are translated. A few advanced tooltips may still appear in English.

## Icon in VEGAS Script Menu

VEGAS does **not** use the Windows icon embedded in a DLL for the script-menu button. It looks for a 16×16, 32-bit RGBA PNG beside the script, with the script filename plus `.png`. This package includes:

- `Sunviz.cs.png` — icon for `Sunviz.cs` (recommended if running the source script).
- `Sunviz.dll.png` — icon for `Sunviz.dll` (if running the compiled script).

Keep the matching PNG in the **same folder** as the script. For example, `Sunviz.cs` and `Sunviz.cs.png` must sit side by side. Then use **Tools → Scripting → Rescan Script Menu Folder** or restart VEGAS. The main window uses `Sunviz.ico` separately.

## Build / edit with Visual Studio Code

This is a VEGAS C# script, not a standalone application. VEGAS provides the `ScriptPortal.Vegas`
API at runtime.

1. Open this folder in Visual Studio Code.
2. Open **Terminal > New Terminal**.
3. Run:

   ```powershell
   Set-ExecutionPolicy -Scope Process Bypass
   .\build.ps1
   ```

4. The build helper searches under `%ProgramFiles%\VEGAS` for `ScriptPortal.Vegas.dll`.
   If it asks for the path, paste the full path. The script trims surrounding quotes automatically.
5. The output is written to `bin\Sunviz.dll`; `flp2json.exe` and `Sunviz.ico` are copied alongside it.

The ZIP extractor intentionally avoids a compile-time dependency on `System.IO.Compression.FileSystem`.
The VEGAS host still needs the .NET Framework `System.IO.Compression` assembly, available in supported
.NET Framework 4.5+ environments.

## Files

| File | Purpose |
|---|---|
| `Sunviz.cs` | Main VEGAS Pro script |
| `Sunviz.ico` | Sunviz main-window icon |
| `Sunviz.cs.png` | 16×16 VEGAS menu/toolbar icon for `Sunviz.cs` |
| `Sunviz.dll.png` | 16×16 VEGAS menu/toolbar icon for `Sunviz.dll` |
| `install.ps1` | Installs the source script and matching icon |
| `Sunviz.png` | High-resolution icon source |
| `flp2json.exe` | FL Studio project parser |
| `source/flp2json.py` | Python source for the parser |
| `build.ps1` | Windows C# compilation helper |

## Credits and scope

Sunviz is an unofficial fork / modification of the original **FLP In Video / FLP to Video** script.
It is intended to improve selected parts of the original workflow; it is not affiliated with Image-Line
or MAGIX. The original project's parsing and placement logic is retained where possible.
