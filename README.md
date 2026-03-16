# Mini Project 2 (Pemograman Aplikasi Bergerak) - Lapor Samarinda

## Apa itu Lapor Samarinda?
Pernah kamu merasa bahwa ingin melaporkan fasilitas umum yang sudah tidak memadai atau bahkan rusak, tapi bingung mau melaporkan ke mana?

Nah, Lapor Samarinda hadir untuk menjawab permasalahan tersebut. Sekarang **kamu bisa melaporkan fasilitas umum yang kurang memadai atau bahkan rusak itu ke dalam aplikasi mobile kami yaitu Lapor Samarinda.**

```
Nama: Zyrus Alfredo Randan Malinggato
NIM: 2409116120
```

---

# Lapor Samarinda 📍📝

**Lapor Samarinda** adalah aplikasi mobile berbasis Flutter yang dirancang untuk memudahkan warga kota Samarinda dalam melaporkan kerusakan atau ketidaklayakan fasilitas umum di sekitar mereka. 

Seringkali masyarakat merasa bingung ke mana harus mengadu ketika menemukan fasilitas publik yang rusak (seperti lampu jalan mati, jalan berlubang, atau jembatan yang tidak memadai). **Lapor Samarinda** hadir sebagai platform solusi untuk mendata dan memantau laporan-laporan tersebut secara digital, terstruktur, dan transparan.

## Tampilan Aplikasi Mobile Lapor Samarinda
<img width="1920" height="1080" alt="Tampilan" src="https://github.com/user-attachments/assets/4f5ead58-ae6e-496d-ac75-780ff54d9c9b" />

---

# Fitur Utama📱
Aplikasi ini memiliki fitur login, register, **CRUD** (*Create, Read, Update, Delete*) lengkap yang memungkinkan pengelolaan data secara *real-time* dan disimpan di dalam Supabase:

* **Tambah Laporan (Create):** Pengguna dapat menambahkan laporan baru dengan mengisi formulir yang terdiri dari Nama Infrastruktur, Lokasi, Deskripsi Kerusakan, dan mengupload foto.
* **Daftar Laporan (Read):** Menampilkan seluruh laporan yang telah dibuat.
* **Edit Laporan (Update):** Pengguna dapat memperbarui informasi pada laporan yang sudah ada jika terdapat kesalahan atau perubahan status.
* **Hapus Laporan (Delete):** Menghapus data laporan dari daftar dengan fitur konfirmasi untuk mencegah penghapusan yang tidak sengaja.
* **Sistem Notifikasi (Feedback):** Memberikan respon visual berupa *SnackBar* setiap kali pengguna berhasil menambah, mengedit, atau menghapus data.

---

# 🔶 Fitur Aplikasi

## 1. Login & Register
Pengguna dapat melakukan login jika memiliki akun, dan jika belum memiliki akun dapat melakukan pembuatan akun pada halaman register.\
<img width="1920" height="1080" alt="Tampilan 2" src="https://github.com/user-attachments/assets/d4653aee-b260-4bac-b89b-0e8673c60202" />

## 2. Fitur Home Page (Halaman Utama)
<img width="1920" height="1080" alt="Tampilan (1)" src="https://github.com/user-attachments/assets/926f2583-e866-455c-aa51-a2ccc8e02880" />

a. Pengguna dapat merubah theme dari mode gelap ke terang, atau dari terang ke gelap. Dengan menekan tombol 🌙 yang berada di pojok kanan atas.
b. Pengguna dapat melihat statistik laporan (total laporan, selesai, proses). Ini bersifat dinamis, jadi akan berubah seiring ditambah/dihapus laporan.
c. Pengguna dapat melihat laporan berdasarkan kategori nya pada menu Kategori Fasilitas (Filter).
<img width="1920" height="1080" alt="Tampilan 2 (1)" src="https://github.com/user-attachments/assets/d828e881-c7fb-43ad-8a7c-7d83f62c2243" />
d. Pengguna dapat melihat laporan pada laporan terbaru secara singkat.
<img width="1920" height="1080" alt="Tampilan (2)" src="https://github.com/user-attachments/assets/144b3b76-3b6a-49aa-a7e9-8231217ddd68" />

## 3. Melihat Laporan (Secara Lengkap)
Pengguna dapat melihat laporan secara lengkap, dengan cara menekan salah satu laporan lalu otomatis anda akan pindah ke halaman detail laporan untuk melihat laporan.
<img width="1920" height="1080" alt="Tampilan (4)" src="https://github.com/user-attachments/assets/d85789da-425e-4420-8278-a8e30e960c32" />

## 4. Fitur Menambahkan Laporan
Pengguna dapat menambahkan laporan, dengan cara menekan button/tombol di halaman home/utama. Lalu pengguna dapat memasukkan Nama Infrastruktur, Lokasi, Deskripsi Kerusakan, dan mengupload foto (Tanggal & Status terisi otomatis.)
<img width="1920" height="1080" alt="Tampilan (3)" src="https://github.com/user-attachments/assets/bf4887d5-a8b8-4581-9e05-e8a24e6956a2" />

## 5. Fitur Mengedit/Mengupdate Laporan
Pengguna dapat mengedit/mengupdate laporan, dengan cara menekan salah satu laporan lalu anda dapat mengubah termasuk status pada laporan tersebut.
<img width="1920" height="1080" alt="Tampilan (5)" src="https://github.com/user-attachments/assets/51183e28-5e33-4861-87f1-d13499493be8" />

## 6. Fitur Menghapus Laporan
Pengguna dapat menghapus laporan, dengan cara menekan salah satu laporan lalu anda dapat menghapus. Tapi akan dikonfirmasi terlebih dahulu, apakah anda yakin ingin menghapus atau tidak.
<img width="1920" height="1080" alt="Tampilan (6)" src="https://github.com/user-attachments/assets/22857bae-9551-4af4-b95c-aadc181dd3ca" />

## 7. Fitur Supabase
Sistem data ini disimpan ke dalam Supabase yang dapat menyimpan data secara realtime.
<img width="1920" height="1080" alt="Tampilan (7)" src="https://github.com/user-attachments/assets/21b03c7a-7fe5-4764-a9f4-b2038b58a3ec" />
