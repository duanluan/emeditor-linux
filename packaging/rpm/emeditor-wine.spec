%global emeditor_version %{?emeditor_version}%{!?emeditor_version:26.1.1}

Name:           emeditor-wine
Version:        %{emeditor_version}
Release:        1%{?dist}
Summary:        EmEditor launcher for Wine
License:        MIT
URL:            https://www.emeditor.com/
BuildArch:      noarch

Requires:       bash
Requires:       wine
Requires:       curl
Requires:       ca-certificates
Requires:       google-noto-sans-cjk-fonts
Requires:       hicolor-icon-theme
Requires:       xrandr
Requires:       xrdb

Source0:        emeditor-wine
Source1:        emeditor-wine.desktop
Source2:        emeditor-wine.png
Source3:        LICENSE
Source4:        README.md

%description
Unofficial Linux launcher for running EmEditor through a dedicated Wine prefix.
The EmEditor MSI is downloaded from the official source on first run.

%prep
cp %{SOURCE3} LICENSE
cp %{SOURCE4} README.md

%build

%install
install -Dm755 %{SOURCE0} %{buildroot}%{_bindir}/emeditor-wine
install -Dm644 %{SOURCE1} %{buildroot}%{_datadir}/applications/emeditor-wine.desktop
install -Dm644 %{SOURCE2} %{buildroot}%{_datadir}/icons/hicolor/256x256/apps/emeditor-wine.png

%files
%license LICENSE
%doc README.md
%{_bindir}/emeditor-wine
%{_datadir}/applications/emeditor-wine.desktop
%{_datadir}/icons/hicolor/256x256/apps/emeditor-wine.png

%changelog
* Sun Jun 07 2026 duanluan <duanluan@outlook.com> - 26.1.1-1
- Initial RPM launcher package.
