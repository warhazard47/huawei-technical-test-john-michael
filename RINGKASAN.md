# Ringkasan & Penjelasan (Bahasa Indonesia)

## 1. Backend (Node.js + Express)

**Apa itu:** Server sederhana yang bisa menerima data dari form, menyimpannya sementara
di memori (array), lalu mengembalikannya saat diminta.

**Kenapa begini:**
- Node.js = supaya JavaScript bisa jalan sebagai server, bukan cuma di browser.
- Express = mempermudah bikin endpoint (alamat API) tanpa nulis banyak kode dasar.
- Data disimpan di array biasa (bukan database) karena soal minta "penyimpanan sederhana."

**Langkah kemarin:**
1. Extract file zip ke folder di Desktop.
2. Buka folder `backend` lewat CMD/terminal.
3. `npm install` → install semua library yang dibutuhkan (Express, dll).
4. `npm start` → jalankan server, muncul "Server running on http://localhost:3000".
5. Buka terminal kedua, test pakai `curl`:
   - Kirim data (POST) → server balas data tersimpan dengan ID.
   - Ambil data (GET) → server balas semua data yang sudah disimpan.
6. Hasilnya sukses, artinya backend sudah bekerja sesuai kriteria soal.

---

## 2. Automation / Cron

**Apa itu:** Skrip yang jalan otomatis di jam-jam tertentu untuk mengambil data dan
menyimpannya sebagai file CSV, plus skrip kedua untuk menghapus file lama.

**Kenapa begini:**
- `cron` = fitur bawaan Linux untuk menjadwalkan tugas otomatis. Tidak ada di Windows,
  makanya kita butuh WSL.
- WSL = menjalankan Linux asli di dalam Windows, supaya `cron` dan `sudo` bisa dipakai.
- `sudo` = izin admin sementara, dibutuhkan untuk copy file ke folder sistem dan
  menyalakan service cron.

**Langkah kemarin:**
1. Sempat salah pakai Git Bash (bukan Linux asli) → banyak perintah gagal.
2. Install WSL lewat PowerShell (`wsl --install`), lalu buka aplikasi **Ubuntu** yang asli.
3. Di dalam Ubuntu:
   - `cd /mnt/c/...` → masuk ke folder project (file Windows bisa diakses lewat `/mnt/c/`).
   - `sudo mkdir -p /home/cron/scripts` → bikin folder tempat skrip akan disimpan.
   - `sudo cp collect_data.sh cleanup_data.sh /home/cron/scripts/` → copy skrip ke sana.
   - `sudo chmod +x ...` → kasih izin agar skrip bisa dieksekusi.
   - `sudo service cron start` → nyalakan layanan cron.
   - `crontab crontab.txt` → daftarkan jadwal (jam 08.00, 12.00, 15.00 untuk ambil data,
     dan 00.30 untuk hapus file lama).
   - `crontab -l` → cek jadwal berhasil terdaftar.
4. Supaya tidak perlu nunggu jam asli, kita tambah jadwal uji coba "tiap 1 menit" lewat
   `crontab -e`, tunggu 1-2 menit, cek file CSV baru muncul di `/home/cron` — terbukti
   otomatisasinya jalan. Setelah itu baris uji coba dihapus lagi.

---

## 3. SQL (SQLite + DBeaver)

**Apa itu:** Kumpulan perintah SQL untuk mengelola tabel `employees`: tambah data,
update data, dan beberapa query untuk analisis (total gaji, ranking pengalaman, dll).

**Kenapa begini:**
- SQLite dipilih karena paling simpel — cuma 1 file `.db`, tidak perlu install server
  database terpisah.
- DBeaver dipakai sebagai "tampilan" untuk menulis SQL dan melihat hasilnya dalam bentuk
  tabel, tidak perlu ketik manual di terminal.

**Langkah kemarin:**
1. Buat koneksi baru di DBeaver dengan tipe **SQLite**, bikin file `.db` baru.
2. Buka SQL Editor, paste isi `data_processing_sqlite.sql`, lalu run semua (Alt+X).
3. **Masalah yang sempat muncul:** script dijalankan lebih dari sekali, jadi data
   employee "Alano" ke-duplikat dan total gaji 2021 salah (3.250, seharusnya 650).
   - **Penyebab:** perintah `CREATE TABLE IF NOT EXISTS` tidak menghapus data lama,
     jadi tiap kali script dijalankan ulang, data lama + data baru numpuk jadi satu.
   - **Solusi:** tambahkan `DROP TABLE IF EXISTS employees;` di baris paling atas,
     supaya tabel selalu dibuat ulang dari kosong setiap kali script dijalankan —
     jadi aman dijalankan berkali-kali tanpa duplikat.
4. Setelah perbaikan, dicoba lagi dan hasilnya benar: total gaji 2021 = 650,
   top 3 pengalaman tidak ada duplikat.

---

## Kesimpulan Singkat
Tiga bagian ini meniru cara kerja backend sungguhan:
**(1)** server API untuk menerima/menyimpan data dari frontend,
**(2)** cron job untuk tugas otomatis terjadwal, dan
**(3)** database untuk menyimpan & menganalisis data secara terstruktur.
Ini alasan kenapa soal test ini mencakup ketiganya sekaligus.
