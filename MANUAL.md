# Cara Menjalankan Project Ini

Ini panduan buat jalanin ketiga bagian test-nya. Ditulis santai biar gampang diikutin,
nggak kaku kayak dokumentasi teknis biasa.

---

## 1. Backend (Server buat nerima data form)

**Yang dibutuhin:** Node.js udah keinstall di komputer.

**Caranya:**
1. Buka folder `backend` lewat terminal/CMD.
2. Ketik `npm install` — ini bakal download semua library yang dibutuhin server.
   Tunggu sampai selesai (biasanya beberapa detik sampai 1 menit).
3. Ketik `npm start` — server bakal nyala. Kalau berhasil, bakal muncul tulisan
   "Server running on http://localhost:3000". Biarin jendela ini tetap kebuka.
4. Buka terminal baru (jendela kedua), buat nge-test:
   - Kirim data: `curl -X POST http://localhost:3000/api/form -H "Content-Type: application/json" -d "{\"name\":\"Budi\"}"`
   - Lihat semua data yang tersimpan: `curl http://localhost:3000/api/form`

**Kalau mau lebih visual**, tinggal buka file `backend/public/index.html` langsung
di browser — ada form kecil buat coba kirim & lihat data tanpa perlu ketik command.

---

## 2. Automation (Cron — ambil data otomatis + hapus file lama)

**Yang dibutuhin:** Karena cron itu fitur Linux, di Windows perlu WSL (Linux di dalam
Windows). Kalau belum ada, install dulu lewat PowerShell: `wsl --install`, terus restart
komputer, terus buka aplikasi **Ubuntu**.

**Caranya (di dalam Ubuntu):**
1. Masuk ke folder project: `cd /mnt/c/Users/NAMAKAMU/Desktop/huawei-technical-test/cron`
2. Siapin folder tempat skrip bakal disimpan:
   ```
   sudo mkdir -p /home/cron/scripts
   sudo cp collect_data.sh cleanup_data.sh /home/cron/scripts/
   sudo chmod +x /home/cron/scripts/*.sh
   ```
3. Nyalain cron: `sudo service cron start`
4. Daftarin jadwalnya: `crontab crontab.txt`
5. Cek jadwal udah kedaftar: `crontab -l`

Jadwalnya bakal ambil data jam 08.00, 12.00, 15.00 WIB tiap hari, dan hapus file yang
udah lebih dari 30 hari sekali sehari.

**Buat buktiin ini beneran jalan** (nggak usah nunggu jam asli), bisa tambah jadwal
percobaan tiap 1 menit lewat `crontab -e`, tambahin baris:
```
* * * * * /home/cron/scripts/collect_data.sh
```
Tunggu 1-2 menit, cek `ls /home/cron` — harusnya ada file CSV baru muncul. Kalau udah
kebukti jalan, baris percobaan ini dihapus lagi biar balik ke jadwal aslinya.

---

## 3. SQL (Kelola data karyawan)

**Yang dibutuhin:** DBeaver (aplikasi buat buka database), pilih tipe **SQLite** —
paling gampang karena nggak perlu install server database terpisah.

**Caranya:**
1. Buka DBeaver, bikin koneksi baru → pilih **SQLite** → bikin file `.db` baru
   (misal `huawei_test.db`).
2. Klik kanan koneksi tadi → **SQL Editor** → **New SQL Script**.
3. Buka file `sql/data_processing_sqlite.sql`, copy semua isinya, paste ke editor tadi.
4. Jalanin semua sekaligus pakai tombol **Alt+X**.
5. Cek hasilnya satu-satu (klik di tiap baris `SELECT`, tekan **Ctrl+Enter**):
   - Total gaji tahun 2021 → harusnya **650**
   - Top 3 paling berpengalaman → Alano, John, Jacky
   - Engineer dengan pengalaman ≤3 tahun → Aaron, Albert

**Catatan:** script ini aman dijalanin berkali-kali — di baris paling atas ada
`DROP TABLE IF EXISTS employees`, jadi tabelnya selalu dibikin ulang dari kosong,
nggak bakal numpuk data ganda kalau kejalanin dua kali.

---

## Kalau Ada yang Error
- **"npm not recognized"** → Node.js belum keinstall, download dulu dari nodejs.org
- **"cannot find path"** → posisi terminal kamu salah folder, cek lagi pakai `dir` atau `ls`
- **Data di SQL keliatan aneh/dobel** → biasanya karena script kejalanin berkali-kali
  tanpa `DROP TABLE`. Pastikan pakai file `data_processing_sqlite.sql` yang udah
  ada baris `DROP TABLE`-nya di paling atas.
