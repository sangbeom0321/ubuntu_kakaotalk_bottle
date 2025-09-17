#!/usr/bin/env bash
set -euo pipefail

BOTTLE_NAME="KakaoTalk"
KAKAO_DL="${HOME}/Downloads/KakaoTalk_Setup.exe"

echo "[1/7] Ensure Flatpak + Flathub"
sudo apt update -y
sudo apt install -y flatpak
if ! flatpak remotes | grep -q flathub; then
  flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

echo "[2/7] Install Bottles (Flatpak)"
flatpak install -y flathub com.usebottles.bottles  # GUI app
# CLI lives inside the flatpak as 'bottles-cli' command:
CLI="flatpak run --command=bottles-cli com.usebottles.bottles" # docs show this usage

echo "[3/7] Create an 'application' Bottle named ${BOTTLE_NAME}"
# Idempotent: only create if not present
if ! ${CLI} list bottles | grep -Fxq "${BOTTLE_NAME}"; then
  ${CLI} new --bottle-name "${BOTTLE_NAME}" --environment application --arch win64
fi

echo "[4/7] Download KakaoTalk installer if missing"
if [ ! -f "${KAKAO_DL}" ]; then
  # Official PC installer URL sometimes redirects; open the service page and download manually if this fails.
  # You can replace the URL with the current direct .exe link if you have it.
  echo "  > Please download the KakaoTalk PC installer (.exe) to ${KAKAO_DL} and re-run if this step fails."
  # Best-effort fetch (may change frequently):
  wget -O "${KAKAO_DL}" "https://app-pc.kakaocdn.net/talk/win32/KakaoTalk_Setup.exe" || true
fi
if [ ! -f "${KAKAO_DL}" ]; then
  echo "ERROR: KakaoTalk_Setup.exe not found at ${KAKAO_DL}. Download it and run this script again."
  exit 1
fi

echo "[5/7] IME fix: set Wine X11 inputStyle=root in this Bottle"
${CLI} reg add -b "${BOTTLE_NAME}" \
  -k "HKEY_CURRENT_USER\\Software\\Wine\\X11 Driver" \
  -v "inputStyle" -d "root" -t REG_SZ

echo "[6/7] Install Korean fonts (system) and copy into the Bottle"
sudo apt install -y fonts-nanum
# Bottle Fonts dir (Flatpak path)
BOTTLE_ROOT="${HOME}/.var/app/com.usebottles.bottles/data/bottles/bottles/${BOTTLE_NAME}"
FONTS_DIR="${BOTTLE_ROOT}/drive_c/windows/Fonts"
mkdir -p "${FONTS_DIR}"
# Copy common Nanum TTFs if present
if [ -d "/usr/share/fonts/truetype/nanum" ]; then
  cp -f /usr/share/fonts/truetype/nanum/*.ttf "${FONTS_DIR}" || true
fi

echo "[7/7] Launch the KakaoTalk installer in the Bottle (GUI will appear)"
${CLI} run -b "${BOTTLE_NAME}" -e "${KAKAO_DL}"

echo ""
echo "Done."
echo "After install, KakaoTalk will show up under Bottles → ${BOTTLE_NAME} → Programs."
echo "Tip: if fonts look odd, open KakaoTalk settings and pick a Nanum font."

