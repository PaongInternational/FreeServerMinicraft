Panduan Instalasi Final Server Minecraft XipserCloud
Server XipserCloud kini dilengkapi dengan:
 * Maraton Mode (12 Jam) dengan Pesan Peringatan Istirahat.
 * Upgrade RAM yang dapat diubah dari Termux.
 * Claim Wilayah Otomatis (Golden Shovel), Anti-Lag, dan Anti-X-Ray.
A. Prasyarat & Setup Awal
 * Persiapan Termux (Wajib!): Instal utilitas yang diperlukan (termasuk screen untuk mengirim pesan shutdown):
   pkg install openjdk-17 wget unzip curl termux-api screen

 * Buat folder Server:
   mkdir XipserCloud-Server
cd XipserCloud-Server

 * Simpan 5 File: Salin dan simpan semua 5 file ini di folder XipserCloud-Server.
 * Beri Izin Eksekusi:
   chmod +x setup_plugins.sh start.sh

 * Jalankan Skrip Setup (Wajib Sekali): Skrip ini mengunduh semua yang diperlukan dan mengisi konfigurasi plugin secara otomatis.
   ./setup_plugins.sh

B. Konfigurasi Upgrade RAM (Penting!)
Server default menggunakan RAM 4GB. Anda HARUS menjalankan perintah export ini SEBELUM menjalankan ./start.sh jika ingin meningkatkan RAM:
Cara Upgrade RAM (Contoh ke 6GB):
Di Termux, ketik perintah berikut sesuai dengan jumlah RAM yang Anda inginkan (misalnya, 6G):
export SERVER_RAM=6G

 * Catatan: Jika Anda tidak menetapkan SERVER_RAM, server akan menggunakan alokasi default 4G.
C. Eksekusi Maraton Mode (12 Jam)
 * Aktifkan Wake Lock (Wajib di Termux):
   Di jendela Termux terpisah (JANGAN ditutup), jalankan:
   termux-wake-lock

 * Mulai Server Latar Belakang:
   Di folder server (XipserCloud-Server), jalankan:
   nohup ./start.sh &

   Ini akan menampilkan IP Ngrok yang update dan menjalankan server dengan timer 12 jam.
Shutdown Otomatis
 * Pada jam ke-11:55 (5 menit sebelum mati), server akan menampilkan pesan peringatan di game.
 * Pada jam ke-12:00, server akan Safe Shutdown, menyimpan dunia, dan menampilkan pesan istirahat.
D. Mekanisme Kustom Lainnya
 * Hak Operator (OP): Gunakan op [NamaAkun] setelah masuk server.
 * Sistem Claim: Gunakan Sekop Emas (Golden Shovel, diberikan otomatis di Kit Awal).
 * Gelar Emas Event: Setelah menyelesaikan Tiga Pilar Ujian, berikan gelar:
   /essentials:nick [NamaPemain] §6[NamaPemain] ✅

