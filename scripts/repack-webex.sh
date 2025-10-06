#!/usr/bin/env bash
set -euxo pipefail

mkdir -p webex-deb
cd webex-deb

# Extract original .deb
ar x ../Webex.deb
tar xf data.tar.*
tar xf control.tar.*

# Add custom AppArmor profile
mkdir -p etc/apparmor.d
cat > etc/apparmor.d/Webex <<'EOF'
abi <abi/4.0>,
include <tunables/global>

profile Webex /opt/Webex/bin/CiscoCollabHost flags=(unconfined) {
  userns,

  # Site-specific additions and overrides. See local/README for details.
  include if exists <local/Webex>
}
EOF

# Patch .desktop file for XWayland
find . -type f -name '*.desktop' -exec sed -i \
  's|^Exec=.*|Exec=env WAYLAND_DISPLAY= XDG_SESSION_TYPE=x11 QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /opt/Webex/bin/CiscoCollabHost %U|' {} \;

# Repack .deb
fakeroot dpkg-deb -b . ../Webex-fixed.deb

echo "✅ Rebuilt Webex-fixed.deb ready!"

