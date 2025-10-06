# 🧩 Webex (XWayland + AppArmor) Repack

This repository automatically repackages Cisco’s official **Webex .deb** into a modified version that:
- Forces **X11/XWayland mode** instead of Wayland
- Adds a simple **AppArmor profile** for sandboxing
- Is rebuilt automatically via **GitHub Actions**

---

## 🚀 Features
- **X11 Compatibility:**  
  The `.desktop` entry is patched to launch Webex under XWayland, avoiding rendering or input issues on Wayland.
  ```bash
  Exec=env WAYLAND_DISPLAY= XDG_SESSION_TYPE=x11 QT_QPA_PLATFORM=xcb GDK_BACKEND=x11 /opt/Webex/bin/CiscoCollabHost %U
  ```

- **AppArmor Support:**  
  Adds `/etc/apparmor.d/Webex`:

  ```text
  abi <abi/4.0>,
  include <tunables/global>

  profile Webex /opt/Webex/bin/CiscoCollabHost flags=(unconfined) {
    userns,

    include if exists <local/Webex>
  }
  ```

- **Automated Rebuilds:**  
  * Runs **every Monday at 6:00 AM (UTC)**
  * Can be triggered manually
  * Also runs automatically on every **push** to `master`

---

## 🛠️ Workflow Overview

GitHub Actions will:

1. Download the latest Webex `.deb` from Cisco:

   ```
   https://binaries.webex.com/WebexDesktop-Ubuntu-Official-Package/Webex.deb
   ```
2. Extract and patch it
3. Add the AppArmor profile
4. Repack into a new `.deb`
5. Upload it as an artifact (`Webex-fixed.deb`)

---

## 📦 Usage

After the workflow finishes, download the artifact from the **Actions tab**:

```
Webex-fixed-deb/Webex-fixed.deb
```

Then install it locally:

```bash
sudo apt install ./Webex-fixed.deb
```

---

## 🧰 Repository Structure

```
.github/workflows/main.yml   # GitHub Actions workflow
scripts/repack-webex.sh      # Repack and patch script
README.md                    # You are here
```

---

## 💡 Future Improvements

* Auto-publish the rebuilt `.deb` as a GitHub Release
* Add version tagging to match upstream Webex builds
* Integrate automatic checksum validation for extra safety

---

**Maintainer:** @silverhadch  
**License:** BSD 3-Clause
