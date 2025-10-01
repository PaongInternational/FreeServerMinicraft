#!/bin/bash
# Skrip Mulai Server Minecraft (PaperMC & Ngrok) dengan AUTO SHUTDOWN 12 Jam
PAPER_JAR="paper.jar"
API_URL="http://127.0.0.1:4040/api/tunnels"
IP_PUBLIC=""
MAX_RETRIES=10
RUN_DURATION_SECONDS=43200 # 12 jam
WARNING_TIME=300 # Peringatan 5 menit sebelum mati
SCREEN_SESSION="xipsercloud"

# --- 0. Konfigurasi RAM dan Randomize MOTD ---
# Mengambil variabel RAM dari environment (Termux). Default ke 4G jika tidak disetel.
RAM_ALLOCATION=${SERVER_RAM:-4G}

RANDOM_SUFFIX=$((RANDOM % 9000 + 1000))
NEW_MOTD="motd=§6⭐ XipserCloud${RANDOM_SUFFIX} Server §f| §aMarathon 12H - RAM: ${RAM_ALLOCATION}"
echo "Mengatur nama server acak: XipserCloud${RANDOM_SUFFIX}"
# Mengganti baris MOTD di server.properties
sed -i "s/^motd=.*$/${NEW_MOTD}/" server.properties

# --- Optimasi Java (RAM dan Flags Anti-Lag) ---
JAVA_OPTS="-Xms${RAM_ALLOCATION} -Xmx${RAM_ALLOCATION} -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:G1HeapRegionSize=16M -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:+AlwaysPreTouch -jar ${PAPER_JAR} nogui"

# --- Fungsi Peringatan Shutdown dan Timer (Berjalan di background) ---
auto_shutdown_timer() {
    echo "---------------------------------------------------------"
    echo "  ⚠️ TIMER SHUTDOWN AKTIF: Server akan mati otomatis dalam 12 jam."
    echo "---------------------------------------------------------"
    
    SLEEP_BEFORE_WARNING=$((RUN_DURATION_SECONDS - WARNING_TIME))
    sleep $SLEEP_BEFORE_WARNING

    # --- Peringatan Dalam Game (5 Menit Terakhir) ---
    echo "---------------------------------------------------------"
    echo "  🚨 MENGIRIM PERINGATAN SHUTDOWN DALAM GAME..."
    # Mengirim pesan ke sesi screen server
    screen -S $SCREEN_SESSION -X stuff "say §cSERVER AKAN MATI DALAM 5 MENIT UNTUK ISTIRAHAT & STABILITAS!§r^M"
    sleep $((WARNING_TIME - 10))

    # --- Shutdown Terakhir (10 Detik Terakhir) ---
    screen -S $SCREEN_SESSION -X stuff "say §4[PENTING] SERVER SHUTDOWN SEKARANG! §cTolong Handphone Jangan Di Gunakan Selama 1 jam buat istirahat dan stabilitas. §r^M"
    sleep 10
    
    # --- Safe Shutdown ---
    echo "========================================================="
    echo "  ⏳ WAKTU HABIS. Mengirim perintah 'stop' ke server..."
    echo "  Dunia XipserWorld sedang disimpan. Mohon tunggu..."
    echo "========================================================="
    
    # Mengirim perintah 'stop' ke konsol PaperMC
    screen -S $SCREEN_SESSION -X stuff "stop^M"
    # Biarkan server mati, skrip utama akan mendeteksi ketika screen keluar
}

# --- Fungsi untuk Mendapatkan IP Ngrok dari API ---
get_ngrok_ip() {
    echo "Mencari Alamat Publik Ngrok..."
    for i in $(seq 1 $MAX_RETRIES); do
        NGROK_STATUS=$(curl -s $API_URL)
        IP_PUBLIC=$(echo "$NGROK_STATUS" | grep -o 'tcp://[^"]*' | head -1)

        if [ ! -z "$IP_PUBLIC" ]; then
            echo "---------------------------------------------------------"
            echo "   ✅ ALAMAT PUBLIK SERVER XIPSERCLOUD (Ngrok)"
            echo "   BAGIKAN ALAMAT INI KE TEMAN ANDA:"
            echo "   $IP_PUBLIC"
            echo "   RAM ALLOCATED: ${RAM_ALLOCATION}"
            echo "---------------------------------------------------------"
            return 0
        fi
        echo "Menunggu koneksi Ngrok... ($i/$MAX_RETRIES)"
        sleep 2
    done
    
    echo "========================================================="
    echo "  ⚠️ GAGAL MENDAPATKAN IP NGROK. Cek token atau koneksi Anda."
    echo "========================================================="
    return 1
}

# --- Skrip Utama ---

echo "====================================================="
echo "       MEMULAI SERVER XIPSERCLOUD (PAPERMC & NGROK)"
echo "====================================================="

# --- 1. Mulai Ngrok di Background ---
echo "1. Memulai Ngrok di background..."
./ngrok start --all --config ngrok.yml > /dev/null 2>&1 &
NGROK_PID=$!
sleep 3

# --- 2. Dapatkan IP Ngrok ---
get_ngrok_ip

# --- 3. Mulai Timer Auto Shutdown di Background ---
auto_shutdown_timer &
TIMER_PID=$!

# --- 4. Mulai Server PaperMC dalam Sesi Screen ---
echo "2. Memulai Server PaperMC dalam sesi screen: ${SCREEN_SESSION}"
echo "KETIK 'stop' DI KONSOL UNTUK MENYIMPAN DUNIA DENGAN AMAN."

# Menjalankan Java di sesi screen bernama 'xipsercloud'
screen -dmS $SCREEN_SESSION bash -c "java ${JAVA_OPTS}"

# Melampirkan (attach) ke sesi screen agar user bisa melihat konsol
echo "Melampirkan ke konsol server. Tekan Ctrl+A lalu D untuk detach dan kembali ke Termux."
screen -r $SCREEN_SESSION

# --- 5. Setelah Sesi Screen Selesai (Server Mati), Matikan Proses Lain ---
echo "Server mati. Mematikan Timer Shutdown (PID: ${TIMER_PID}) dan Ngrok (PID: ${NGROK_PID})..."
kill ${TIMER_PID} 2>/dev/null
kill ${NGROK_PID} 2>/dev/null

echo "Proses XipserCloud dihentikan. Selesai."
