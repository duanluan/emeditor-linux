# emeditor-linux

Linux packaging for running EmEditor through Wine.

This project packages a launcher, desktop entry, icon, and build scripts for:

- Arch/AUR
- Debian/Ubuntu `.deb`
- Fedora/openSUSE-style `.rpm`
- AppImage launcher

It does not contain EmEditor itself. The launcher downloads the official MSI
from Emurasoft on first run if a package-local MSI is not installed, verifies
its SHA256, installs it into a dedicated Wine prefix, and applies the Wine
settings that make EmEditor usable on this machine.

## Install

### Arch Linux / AUR

Use an AUR helper:

```sh
yay -S emeditor-wine
# or
paru -S emeditor-wine
```

Manual AUR install:

```sh
git clone https://aur.archlinux.org/emeditor-wine.git
cd emeditor-wine
makepkg -si
```

The AUR package downloads the tagged launcher source from this repository and
the official EmEditor MSI during `makepkg`. The built local package keeps the
MSI under `/usr/share/emeditor-wine/`, so first launch does not need to download
the installer again.

### Release Packages

Download `.deb`, `.rpm`, or AppImage files from the
[GitHub Releases](https://github.com/duanluan/emeditor-linux/releases) page.

## What The Launcher Does

- Uses `~/.wine-emeditor` by default.
- Installs EmEditor 26.1.1 from the official MSI.
- Disables DirectWrite inside EmEditor to avoid Wine startup crashes.
- Supports refresh compatibility modes for Wine rendering/focus issues.
- Applies DPI settings based on `xrdb`/`xrandr`.
- Uses Noto CJK by default, and switches to Microsoft YaHei UI if available.
- Imports Windows UI fonts from existing local font directories when present.
- Fixes Wine-generated desktop launchers so they call `emeditor-wine`.

## Build

```sh
make deb
make rpm
make appimage
make aur-source
make docker-rpm
make docker-appimage
```

Artifacts are written to `dist/`.
The AUR source directory is written to `build/aur-source/`.
`make aur-source` expects the matching `v<version>` GitHub tag to exist because
the generated AUR package uses that tag tarball as its launcher source.

`docker-rpm` builds the RPM in a Fedora container. `docker-appimage` builds the
AppImage in an Ubuntu container and downloads `appimagetool` inside the
container.

The build scripts may download the official MSI into `build/cache/` to extract
the application icon. The generated `.deb`, `.rpm`, and AppImage packages do
not embed the EmEditor MSI by default; the launcher downloads it on first run.

## Overrides

```sh
EMEDITOR_WINEPREFIX="$HOME/.wine-emeditor-test" emeditor-wine
EMEDITOR_WINE_DPI=192 emeditor-wine
EMEDITOR_WINE_UI_FONT="Microsoft YaHei UI" emeditor-wine
EMEDITOR_WINE_FONTS_DIR="$HOME/win11-fonts:/mnt/windows/Windows/Fonts" emeditor-wine
EMEDITOR_WINE_LANG=en_US.UTF-8 emeditor-wine
EMEDITOR_WINE_MSI=/path/to/emed64_26.1.1.msi emeditor-wine
```

### Refresh Compatibility

The launcher uses `EMEDITOR_WINE_REFRESH_MODE=wm` by default. `wm` means
window manager mode: Wine lets the Linux window manager decorate and manage the
EmEditor window, which avoids delayed editor refreshes on KDE/X11. If needed,
try these launcher modes:

```sh
EMEDITOR_WINE_REFRESH_MODE=default emeditor-wine
EMEDITOR_WINE_REFRESH_MODE=focus emeditor-wine
EMEDITOR_WINE_REFRESH_MODE=desktop emeditor-wine
EMEDITOR_WINE_DIRECTWRITE=1 emeditor-wine
```

`default` keeps the old undecorated Wine window behavior. `focus` also disables
Wine's X11 take-focus handling. `desktop` runs EmEditor inside a Wine virtual
desktop; set `EMEDITOR_WINE_DESKTOP_SIZE`, such as `1920x1080`, to override the
detected size. DirectWrite stays disabled by default because it can crash
startup under Wine, but `EMEDITOR_WINE_DIRECTWRITE=1` is available for manual
rendering tests. The X11 driver settings are most useful on X11/XWayland; native
Wayland Wine sessions should still launch, but may need separate testing.

## Notes

EmEditor is proprietary software owned by Emurasoft. This repository is an
unofficial Linux/Wine launcher. Do not publish packages that include EmEditor
binaries unless you have permission to redistribute them.

The persistent trial notification indicator in EmEditor's status bar may still
render as square glyphs under Wine, even after Windows UI fonts are imported.
