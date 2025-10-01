#!/bin/bash
# Skrip Setup Server Minecraft XipserCloud (PaperMC, Ngrok, Plugins, Config Otomatis)

echo "--- Memulai Setup Server XipserCloud (Otomatisasi Plugin) ---"

# --- 1. Konfigurasi Ngrok ---
NGROK_TOKEN="33RKXoLi8mLMccvpJbo1LoN3fCg_4AEGykdpBZeXx2TFHaCQj"

echo "Membuat konfigurasi Ngrok (ngrok.yml)..."
cat << EOF > ngrok.yml
version: "2"
authtoken: ${NGROK_TOKEN}
tunnels:
  minecraft:
    proto: tcp
    addr: 25565
    region: ap
EOF

# --- 2. Unduh Ngrok ---
NGROK_ARCH=$(uname -m)
if [ "$NGROK_ARCH" == "aarch64" ]; then
    NGROK_ZIP="ngrok-stable-linux-arm64.zip" 
else
    # Fallback for other architectures, adjust if necessary
    NGROK_ZIP="ngrok-stable-linux-amd64.zip"
fi

echo "Mengunduh Ngrok untuk arsitektur Anda ($NGROK_ARCH)..."
wget https://bin.equinox.io/c/4VmDzA7iaHb/${NGROK_ZIP} -O ${NGROK_ZIP}
unzip -o ${NGROK_ZIP}
rm ${NGROK_ZIP}
chmod +x ngrok
echo "Ngrok berhasil diunduh dan dikonfigurasi."

# --- 3. Unduh PaperMC dan Plugins ---
PAPER_JAR="paper.jar"
PAPER_VERSION="1.20.4"
echo "Mengunduh PaperMC (${PAPER_VERSION})..."
# Menggunakan link build terakhir yang stabil
wget -O ${PAPER_JAR} https://api.papermc.io/v2/projects/paper/versions/${PAPER_VERSION}/builds/514/downloads/paper-1.20.4-514.jar

PLUGINS_DIR="plugins"
mkdir -p $PLUGINS_DIR
echo "Mengunduh Plugin EssentialsX dan GriefPrevention..."
wget -O ${PLUGINS_DIR}/EssentialsX.jar https://github.com/EssentialsX/Essentials/releases/download/2.20.1/EssentialsX-2.20.1.jar
wget -O ${PLUGINS_DIR}/GriefPrevention.jar https://github.com/TechFortress/GriefPrevention/releases/download/v16.18/GriefPrevention-16.18.jar

# --- 4. Persetujuan EULA ---
echo "Menyetujui Minecraft EULA..."
echo "eula=true" > eula.txt

# --- 5. Konfigurasi Plugin Otomatis (Untuk Kit Awal Golden Shovel) ---
echo "Membuat file konfigurasi EssentialX kustom untuk Kit Awal..."
mkdir -p plugins/Essentials

# Membuat config.yml EssentialsX yang sudah dimodifikasi untuk Kit Awal (Golden Shovel)
# Perhatian: YAML sangat sensitif terhadap spasi!
cat << 'EOF' > plugins/Essentials/config.yml
# XipserCloud EssentialsX Configuration (Customized)
# Bagian ini hanya berisi perubahan yang diperlukan untuk fitur kustom.

# --- Kit Otomatis untuk Pemain Baru (Alat Claim) ---
teleport-safety: true
starting-balance: 0.0

kits:
  tools:
    delay: 10
    items:
      - 284 1 name:&6Sekop_Emas_CLAIM # Golden Shovel (284) untuk Claim
      - 294 1 name:&6Cangkul_Emas_AUTHORIZE # Golden Hoe (294) untuk Otorisasi Pukul
      - 280 1 name:&fTongkat_Pengecek_Wilayah # Stick (280) untuk cek batas claim
  initial-kit: tools # AKTIF: Memberikan kit 'tools' saat pemain pertama kali masuk
  
# --- Perintah Lainnya ---
tpa-cooldown: 5 # Cooldown TPA 5 detik
homes:
  max-homes: 3 # Maksimal 3 home

# Sisa konfigurasi EssentialsX akan dibuat otomatis oleh plugin saat dijalankan pertama kali.
EOF

# --- 6. Penerapan Optimasi PaperMC (paper-optimization.yml) ---
# Kami langsung menyalin file optimasi PaperMC ke tempat yang benar
mkdir -p config
cp paper-optimization.yml config/paper-global.yml
echo "Konfigurasi Anti-XRay dan Anti-Lag PaperMC telah diterapkan."

echo "--- Setup Selesai! Lanjut ke INSTALLATION_GUIDE.md ---"
