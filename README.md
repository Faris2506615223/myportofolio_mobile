# Portofolio Mobile - Faris Salman Azhari

**Nama:** Faris Salman Azhari

**NPM:** 2506615223

**Kelas:** PBP F

**Repositori:** [myportofolio_mobile](https://github.com/Faris2506615223/myportofolio_mobile)

---

## Deskripsi Proyek

Aplikasi portofolio pribadi berbasis Flutter yang dikembangkan untuk mata kuliah Pemrograman Berbasis Platform, Fakultas Ilmu Komputer, Universitas Indonesia, Semester Gasal 2026/2027. Proyek ini melanjutkan Tutorial 08, Tugas 7, dan Tutorial 09. Tugas 8 menambahkan formulir Pengalaman (Experience) berdasarkan bagian portofolio yang sudah tersedia pada aplikasi web Django.

Antarmuka menggunakan Material 3 dengan komponen yang dipisahkan agar mudah digunakan kembali. Fitur tambahan mencakup tema terang dan gelap, tata letak responsif, salin NPM, serta dialog informasi profil. Empat kartu aksi menampilkan SnackBar. Tambah Proyek membuka formulir dari Tutorial 09, sedangkan Tambah Pengalaman membuka formulir baru dengan validasi dan dialog ringkasan. Data formulir belum disimpan permanen; daftar data dan autentikasi belum diimplementasikan.

---

## Cara Menjalankan Proyek Secara Lokal

Prasyarat: Flutter SDK tersedia di `PATH`. Proyek menggunakan constraint Dart `^3.11.5` dan telah diverifikasi dengan **Flutter 3.41.9 stable** serta **Dart 3.11.5**. Untuk menjalankan aplikasi di web, siapkan Chrome; untuk Android, siapkan Android SDK dan emulator atau perangkat fisik.

1. **Clone repository:**

   ```bash
   git clone https://github.com/Faris2506615223/myportofolio_mobile.git
   cd myportofolio_mobile
   ```
2. **Periksa lingkungan pengembangan:**

   ```bash
   flutter doctor
   flutter devices
   ```
3. **Install dependencies:**

   ```bash
   flutter pub get
   ```
4. **Jalankan aplikasi:**

   ```bash
   flutter run -d chrome
   ```

   Untuk Android, gunakan ID perangkat yang ditampilkan oleh `flutter devices`:

   ```bash
   flutter run -d <device-id>
   ```

Jika folder proyek sudah tersedia, buka terminal di root `myportofolio_mobile` dan mulai dari pemeriksaan lingkungan. Aplikasi dapat dijalankan tanpa backend Django atau konfigurasi variabel lingkungan tambahan. Build iOS membutuhkan macOS dan Xcode.

### Kompatibilitas Material UI

PDF Tutorial 09 menggunakan impor `package:material_ui/material_ui.dart`. Proyek memakai **material_ui 0.0.1**, versi kompatibilitas resmi yang mengekspor `package:flutter/material.dart` dan mendukung SDK lokal Flutter 3.41.9 / Dart 3.11.5. Semua impor Material pada kode aplikasi dan tes sudah disesuaikan. Versi paket dikunci agar instalasi ulang tidak memilih versi yang memerlukan SDK lebih baru. Tidak diperlukan pembaruan SDK global. Referensi: [material_ui 0.0.1](https://pub.dev/packages/material_ui/versions/0.0.1).

---

## Progres Pengerjaan (Tutorial 08)

- [X] Inisialisasi proyek Flutter `myportofolio_mobile` beserta struktur platform bawaan.
- [X] Pemisahan entry point `main.dart` dan halaman utama `menu.dart`.
- [X] Penggunaan `StatelessWidget` pada `MyHomePage` serta komponen awal `InfoCard` dan `ItemCard`.

---

## Progres Pengerjaan (Tugas 7)

- [X] **Identitas Pemilik**: Mengganti data contoh tutorial dengan NPM `2506615223`, nama Faris Salman Azhari, dan kelas PBP F pada tiga `InfoCard` di bagian atas halaman.
- [X] **Halaman Utama Stateless**: Mempertahankan `MyHomePage` sebagai `StatelessWidget` pada `lib/menu.dart`; `main.dart` hanya menjadi entry point aplikasi.
- [X] **Model Aksi**: Membuat `ItemHomepage` dengan properti `name`, `icon`, `color`, dan `description` yang bersifat `final`, serta constructor `const`.
- [X] **Kartu Aksi**: Menampilkan Lihat Proyek, Tambah Proyek, dan Logout dengan ikon serta warna latar yang berbeda untuk setiap kartu.
- [X] **SnackBar Interaktif**: Menampilkan pesan sesuai nama tombol dan membersihkan antrean pesan agar tap cepat tidak menyisakan pesan lama.
- [X] **Tata Letak Responsif**: Menghitung lebar kartu berdasarkan constraints parent, menyesuaikan jumlah kolom, serta menyediakan scroll untuk layar kecil dan teks besar.
- [X] **Tema Terang dan Gelap**: Mengikuti tema sistem saat aplikasi dibuka dan menyediakan tombol penggantian tema pada AppBar. State tema dikelola oleh `MyApp`.
- [X] **Salin NPM**: Menyalin NPM ke clipboard, memberikan umpan balik hasil operasi, serta menangani kegagalan platform dan context yang sudah tidak mounted.
- [X] **Dialog Profil**: Menampilkan informasi pemilik melalui tombol Tentang portofolio pada AppBar.
- [X] **Modularisasi**: Memisahkan konfigurasi tema, data profil, model aksi, serta widget kartu ke berkas masing-masing.
- [X] **Pengujian Otomatis**: Menyediakan 14 tes widget untuk identitas, warna, SnackBar, tap cepat, clipboard, tema, dialog, dan layout.
- [X] **Verifikasi Kode**: Formatter Dart bersih, `flutter analyze` menghasilkan `No issues found!`, seluruh tes lulus, dan build web release berhasil.
- [X] **Dokumentasi**: Melengkapi setup, struktur proyek, enam jawaban reflektif Tugas 7, dan AI disclosure.

### Menu Aksi Portofolio

| Tombol        | Ikon                 | Warna Latar              | Pesan SnackBar                               |
| ------------- | -------------------- | ------------------------ | -------------------------------------------- |
| Lihat Proyek  | `Icons.folder`     | Biru (`#2457A7`)       | `Kamu telah menekan tombol Lihat Proyek!`  |
| Tambah Proyek | `Icons.add_circle` | Hijau (`#176B4F`)      | `Kamu telah menekan tombol Tambah Proyek!` |
| Logout        | `Icons.logout`     | Merah bata (`#B3452F`) | `Kamu telah menekan tombol Logout!`        |

Warna dibaca langsung dari `item.color`, sehingga tidak diperlukan percabangan berdasarkan nama tombol. Seluruh konfigurasi aksi disimpan pada `PortfolioData.items`.

### Fitur Tambahan

| Fitur             | Implementasi                                                                                                                                                                              |
| ----------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Layout adaptif    | Tiga kolom identitas dan dua kolom untuk empat aksi pada area minimal 780 logical pixels; satu kolom pada area lebih sempit atau teks besar. Lebar halaman dibatasi hingga 1120 logical pixels. |
| Tema terang/gelap | Menggunakan `theme`, `darkTheme`, dan `themeMode` pada `MaterialApp`, dengan kontrol pada AppBar. Pilihan berlaku selama sesi aplikasi.                                           |
| Salin NPM         | Tombol salin pada kartu NPM menggunakan `Clipboard.setData` dan menampilkan SnackBar berhasil/gagal.                                                                                    |
| Dialog profil     | `AlertDialog` berisi identitas dan ringkasan portofolio, dengan tombol Tutup.                                                                                                           |
| Interaksi kartu   | Ripple dan fokus keyboard melalui `InkWell`, serta deskripsi melalui `Tooltip`.                                                                                                       |

---

## Progres Pengerjaan (Tutorial 09)

- [X] **Drawer Navigasi**: Membuat `LeftDrawer` pada `lib/widgets/left_drawer.dart` dengan `Drawer`, `ListView`, `DrawerHeader`, serta menu Home dan Add Project.
- [X] **Navigasi Drawer**: Menutup drawer dan menggunakan `Navigator.pushReplacement` untuk mengganti halaman. Memilih halaman yang sudah aktif hanya menutup drawer agar draf tidak terbuang.
- [X] **Form Proyek**: Membuat `ProjectFormPage` sebagai `StatefulWidget` dengan `GlobalKey<FormState>`, `Form`, `SingleChildScrollView`, dan `Column`.
- [X] **Lima Elemen Input**: Menyediakan nama, deskripsi, kategori, teknologi, dan tautan proyek. Kategori menggunakan `DropdownButtonFormField` dengan `initialValue`, bukan properti `value` yang deprecated.
- [X] **Validasi**: Nama dan deskripsi wajib terisi setelah whitespace dihapus. Teknologi serta tautan bersifat opsional; tautan yang diisi harus berupa URL HTTP/HTTPS yang valid.
- [X] **Dialog Ringkasan**: Tombol Save menjalankan validasi dan menampilkan kelima nilai melalui `AlertDialog` dengan konten yang dapat digulir.
- [X] **Reset Form**: Tombol OK menutup dialog dengan `Navigator.pop`, mereset seluruh field, dan mengembalikan kategori ke Web Development. Dismiss melalui Back atau area luar dialog mempertahankan draf.
- [X] **Navigasi Kartu**: Tombol Tambah Proyek mempertahankan SnackBar dan membuka formulir melalui `Navigator.push` serta `MaterialPageRoute`. Tombol Back mengembalikan pengguna ke menu sebelumnya.
- [X] **Refactoring**: Memindahkan halaman ke `lib/screens/`, menempatkan `ItemCard` pada `lib/widgets/project_card.dart`, dan memperbarui seluruh impor aplikasi serta tes.
- [X] **Kompatibilitas SDK**: Menggunakan paket `material_ui` versi 0.0.1 yang kompatibel dengan Flutter dan Dart terpasang.
- [X] **Regresi Fitur**: Mempertahankan profil, kartu berwarna, clipboard, dan tema Tugas 7, termasuk kontrol tema setelah perpindahan halaman melalui drawer.
- [X] **Pengujian**: Seluruh 27 tes widget lulus (14 tes regresi Tugas 7 dan 13 tes navigasi/form Tutorial 09); analyzer tidak menemukan isu.

### Field Form Proyek

| Field                    | Widget                                   | Aturan                                                                                                            |
| ------------------------ | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------- |
| Nama Proyek              | `TextFormField`                        | Wajib diisi; input yang hanya berisi spasi ditolak.                                                               |
| Deskripsi Proyek         | `TextFormField` dengan `maxLines: 5` | Wajib diisi; input kosong atau whitespace ditolak.                                                                |
| Kategori Proyek          | `DropdownButtonFormField<String>`      | Pilihan: Web Development, Mobile Development, Machine Learning, Data Science, dan Other. Default Web Development. |
| Teknologi yang Digunakan | `TextFormField`                        | Opsional, misalnya Flutter, Django, Figma.                                                                        |
| Tautan Proyek            | `TextFormField` dengan keyboard URL    | Opsional; jika diisi harus berupa URL HTTP/HTTPS dengan host yang valid dan tanpa whitespace.                     |

### Perbedaan Navigasi yang Diterapkan

| Interaksi                 | Method                                   | Perilaku                                                                                    |
| ------------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------- |
| Kartu Tambah Proyek       | `Navigator.push`                       | Menambahkan formulir ke atas stack dan mempertahankan menu untuk kembali dengan Back.       |
| Drawer Home / Add Project | `Navigator.pushReplacement`            | Mengganti route paling atas setelah drawer ditutup; tidak menghapus route lain di bawahnya. |
| Tombol Back pada formulir | `Navigator.pop` melalui `BackButton` | Menghapus formulir yang dibuka dari kartu, lalu kembali ke menu yang sama.                  |
| Tombol OK pada dialog     | `Navigator.pop`                        | Menutup dialog; setelah dikonfirmasi, state dan field formulir direset.                     |

`DropdownButtonFormField` memakai nilai awal yang tetap. Nilai kategori yang dipilih disimpan terpisah agar `FormState.reset()` benar-benar kembali ke default, termasuk pada submit kedua. Tinggi item dropdown dapat mengikuti teks. Judul dan isi dialog juga dapat digulir agar tetap dapat digunakan pada layar kecil dengan teks sistem yang diperbesar. Tidak ada penyimpanan database pada tahap tutorial ini.

---

## Progres Pengerjaan (Tugas 8)

Bagian yang dipilih adalah **Pengalaman (Experience)**. Field mengikuti `Experience`, `ExperienceForm`, dan `ExperienceSerializer` pada proyek web `myportofolio`, dengan empat field yang dapat diedit: `title`, `description`, `category`, dan `thumbnail`.

- [X] **Halaman Baru**: Membuat `lib/screens/experience_form.dart` dengan `ExperienceFormPage` sebagai `StatefulWidget`, `Form`, dan `GlobalKey<FormState>` yang disimpan pada `State`.
- [X] **Empat Input**: Menyediakan posisi/kegiatan, deskripsi pengalaman, kategori dengan enam pilihan, dan URL thumbnail opsional.
- [X] **Validasi Model**: Menolak isian wajib kosong/whitespace, judul lebih dari 255 karakter, markup HTML pada field teks biasa, kategori kosong, serta thumbnail dengan panjang atau format yang tidak valid.
- [X] **Navigasi Kartu**: Menambahkan Tambah Pengalaman dengan ikon pekerjaan dan latar ungu. Kartu membuka formulir melalui `Navigator.push` sehingga Back dapat kembali ke menu sebelumnya.
- [X] **Drawer Bersama**: Menambahkan Add Experience pada `LeftDrawer`, mempertahankan Home dan Add Project, serta menggunakan drawer yang sama pada kedua formulir.
- [X] **Dialog Ringkasan**: Tombol Simpan memanggil `validate()`. Hanya data valid yang dibentuk menjadi snapshot `Experience` dan ditampilkan lengkap melalui `showDialog`/`AlertDialog`.
- [X] **Kembali ke Form**: Tombol Tutup menutup dialog tanpa membuang isian. Simpan berikutnya membaca input terbaru; tombol Reset tersedia untuk mengosongkan field secara eksplisit.
- [X] **UI/UX Tambahan**: Menyediakan Isi contoh, penghitung karakter judul, validasi ulang setelah percobaan submit, tombol aksi yang membungkus pada layar sempit, serta dialog yang dapat digulir dengan teks besar.
- [X] **Struktur Modular**: Memisahkan model dan kategori, validator, serta `PortfolioFormScaffold` yang dipakai kedua formulir agar AppBar, drawer, inset, dan tema konsisten.
- [X] **Aksi Bertipe**: Menggunakan `HomepageAction` untuk menentukan tujuan kartu tanpa bergantung pada perbandingan nama tombol. Empat kartu disusun menjadi dua kolom pada desktop; tiga kartu identitas tetap memakai tiga kolom.
- [X] **Pengujian**: Seluruh 49 tes lulus, terdiri dari 27 tes regresi, 14 tes widget Pengalaman, dan delapan tes kontrak validator/model. `flutter analyze` tidak menemukan isu.
- [X] **Dokumentasi**: Menambahkan progres, pemetaan field, empat jawaban reflektif, dan kelanjutan AI disclosure tanpa mengganti keterangan model atau menghapus jawaban tugas sebelumnya.

### Pemetaan Field Experience

| Field Model | Label dan Jenis Input | Aturan |
| --- | --- | --- |
| `title` | Posisi / Kegiatan, `TextFormField` | Wajib, teks biasa, trim whitespace, maksimal 255 Unicode code point sesuai `CharField(max_length=255)`. |
| `description` | Deskripsi Pengalaman, `TextFormField` multiline | Wajib dan teks biasa; tanpa batas panjang tambahan karena model memakai `TextField`. |
| `category` | Kategori, `DropdownButtonFormField<ExperienceCategory>` | Internship (`internship`), Research (`research`), Volunteer (`volunteer`), Part-Time (`part-time`), Full-Time (`full-time`), dan Freelance (`freelance`). Default Full-Time. |
| `thumbnail` | URL Thumbnail, `TextFormField` dengan keyboard URL | Opsional; jika diisi maksimal 200 karakter, skema HTTP/HTTPS, host tidak kosong, dan tidak mengandung whitespace. |

Batas 200 karakter thumbnail mengikuti nilai bawaan [Django URLField](https://docs.djangoproject.com/en/5.2/ref/models/fields/#urlfield). Teks dengan tag HTML ditolak agar pengguna memasukkan teks biasa, sedangkan formulir web membersihkan tag sebelum validasi. Pemeriksaan ini bukan sanitizer HTML; ringkasan Flutter menggunakan widget `Text`.

`id`, tanggal, dan metadata star tidak menjadi input form. `started_at` diisi otomatis pada model web; `started_at` dan `ended_at` bersifat read-only pada serializer yang ada. Karena tidak ada tanggal yang dapat diedit pada form ini, tidak ditambahkan date picker atau aturan urutan tanggal yang tidak berlaku. Model Dart hanya menyimpan empat nilai isian untuk ringkasan lokal, bukan keseluruhan objek API.

### Alur Menggunakan Form Pengalaman

1. Tekan **Tambah Pengalaman** di halaman utama, atau buka drawer lalu pilih **Add Experience**.
2. Lengkapi posisi/kegiatan dan deskripsi, lalu pilih kategori. URL thumbnail boleh dikosongkan. Tombol **Isi contoh** mengisi data demonstrasi yang dapat diedit.
3. Tekan **Simpan**. Pesan kesalahan muncul pada field yang belum valid; ringkasan baru muncul setelah semua validator lulus.
4. Periksa keempat isian, lalu tekan **Tutup** untuk kembali ke formulir. Isian dipertahankan agar dapat diperbaiki. **Reset** mengosongkan teks, mengembalikan kategori ke Full-Time, dan membersihkan pesan validasi.
5. Gunakan Back jika formulir dibuka dari kartu. Untuk menguji alur kembali pada Chrome, pilih **Home** dari drawer. Opsi **Add Project** tetap membuka formulir Tutorial 09.

### Pemenuhan Rubrik

| Aspek | Bukti |
| --- | --- |
| Fungsionalitas dan topik | Form baru, empat input sesuai model, validator per field, kartu/drawer, dialog lengkap, dan alur Home/Back. Bonus: isi contoh, reset, counter, serta adaptasi layar/keyboard/teks besar. |
| Kualitas kode | Model immutable dan enum kategori, validator terpisah, tujuan kartu bertipe, kerangka form reusable, disposal controller, docstring alasan desain, dan analyzer bersih. |
| Dokumentasi dan AI | Setup yang sama, progres mingguan, kontrak field, alur penggunaan, empat jawaban reflektif, log instruksi, serta analisis keterbatasan dan koreksi. |
| Git dan pengumpulan | Perintah branch/staging/commit diberikan terpisah untuk dijalankan pemilik. Tidak ada commit atau push yang dijalankan pada pengerjaan ini. |

Tutorial 09 merupakan prasyarat dengan tenggat **18 November 2026 pukul 23.59 WIB**. Tugas 8 dikumpulkan sebagai tautan commit GitHub melalui SCELE paling lambat **23 November 2026 pukul 23.59 WIB**. Status pengumpulan dan nilai akhir ditentukan oleh pelaksanaan pengumpulan serta penilai.

---

## Struktur Proyek

```text
lib/
|-- main.dart                       # Entry point dan runApp
|-- app.dart                        # MaterialApp dan state tema
|-- theme.dart                      # Konfigurasi tema terang dan gelap
|-- data/
|   `-- portfolio_data.dart         # Identitas dan daftar aksi
|-- models/
|   |-- experience.dart             # Snapshot isian dan enum kategori
|   `-- item_homepage.dart          # Model kartu dan HomepageAction
|-- screens/
|   |-- menu.dart                   # MyHomePage: StatelessWidget
|   |-- project_form.dart           # Form Tutorial 09
|   `-- experience_form.dart        # Form Pengalaman Tugas 8
|-- validators/
|   `-- experience_validators.dart  # Kontrak validasi input Pengalaman
`-- widgets/
    |-- info_card.dart              # Kartu identitas
    |-- left_drawer.dart            # Navigasi Home dan dua formulir
    |-- portfolio_form_scaffold.dart # Kerangka kedua formulir
    |-- project_card.dart           # ItemCard, SnackBar, dan navigasi
    `-- responsive_card_wrap.dart   # Layout kartu adaptif

test/
|-- widget_test.dart                # Regresi menu, profil, dan interaksi
|-- navigation_form_test.dart       # Regresi Tutorial 09
|-- experience_form_test.dart       # UI, navigasi, dialog, dan layout Tugas 8
`-- experience_validators_test.dart # Batas field dan kategori model
```

Identitas dan daftar aksi dipusatkan dalam `PortfolioData`. Untuk menambahkan menu, tambahkan konfigurasi `ItemHomepage` pada `PortfolioData.items`. Tujuan halaman ditentukan melalui `HomepageAction`, sehingga perubahan label tidak mengubah routing. `ResponsiveCardWrap` mengatur lebar kartu berdasarkan ruang yang tersedia, sedangkan masing-masing komponen kartu menangani tampilan dan interaksinya sendiri.

---

## Pengujian dan Verifikasi

Jalankan perintah berikut dari root proyek:

```bash
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test --reporter expanded
flutter build web --release

# Opsional: tes navigasi/form pada target browser
flutter test --platform chrome test/navigation_form_test.dart --reporter expanded
```

Hasil verifikasi pada 16 November 2026:

| Pemeriksaan                          | Hasil                                                                                                 |
| ------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| Formatter Dart                       | Seluruh berkas `lib/` dan `test/` sudah sesuai format.                                            |
| `flutter analyze`                  | **No issues found!**                                                                            |
| `flutter test --reporter expanded` | **49 tes lulus.**                                                                               |
| `flutter build web --release`      | **Berhasil**, dengan output pada `build/web`. Wasm dry run juga berhasil.                     |
| Tes navigasi/form pada Chrome        | Belum selesai: suite tetap pada tahap `loading` setelah sekitar lima menit, lalu proses dihentikan. |

Cakupan tes meliputi identitas pemilik, menu stateless, warna kartu yang dirender, pesan keempat tombol, penggantian pesan saat tap cepat, clipboard berhasil/gagal, tema sistem dan penggantian dua arah, serta buka/tutup dialog profil. Layout diuji pada ukuran 320 x 568, 390 x 844, 768 x 1024, 1024 x 600, dan 1440 x 900 logical pixels, ditambah teks 200% pada layar 320 x 568.

Tes Tutorial 09 memeriksa perubahan stack (`push` vs `pushReplacement`), kembali dengan Back, kelima isian dialog, kategori default dan reset, submit kedua tanpa data lama, validasi whitespace/URL, draf ketika dialog dibatalkan atau menu aktif dipilih, serta tema setelah navigasi. Form, dialog, dan drawer diperiksa pada layar kecil dan teks 200%; keyboard juga disimulasikan agar tombol Save tetap terjangkau.

Tes Tugas 8 mencakup required/whitespace, teks biasa, batas judul 255/256 termasuk Unicode, batas thumbnail 200/201, enam kategori, data terbaru pada dialog, isian opsional, isi contoh, reset tanpa error tertinggal, serta action kartu yang tetap benar ketika label diubah. Form diuji pada 320 x 568, 390 x 844, 844 x 390 (landscape), dan 1440 x 900, termasuk teks 200% dan keyboard dengan inset 300 logical pixels. Akses dari kartu, drawer, Back, serta Home diverifikasi lewat tes widget.

Tes clipboard menggunakan mock platform. Hasil tersebut memverifikasi data dan penanganan error, tetapi belum menguji izin clipboard nyata pada setiap perangkat. Tes target Chrome belum melewati tahap loading pada lingkungan ini. Pemeriksaan visual browser belum selesai; build Android dan iOS belum diverifikasi.

### Alur Verifikasi Manual

1. Jalankan aplikasi dan cocokkan tiga kartu identitas dengan data pemilik.
2. Tekan Lihat Proyek dan Logout untuk memeriksa SnackBar. Tekan Tambah Proyek, periksa SnackBar serta formulir yang terbuka, lalu gunakan Back untuk kembali ke menu.
3. Tekan Salin NPM, lalu tempelkan hasilnya ke kolom teks untuk memastikan nilainya `2506615223`.
4. Ganti tema melalui AppBar, kemudian buka dan tutup dialog Tentang portofolio.
5. Coba layar kecil, orientasi landscape, dan teks yang diperbesar; pastikan seluruh konten dapat digulir dan tombol tetap dapat dijangkau.
6. Buka drawer, pilih Add Project, lalu kembali lewat Home. Bandingkan perilakunya dengan navigasi dari kartu Tambah Proyek.
7. Tekan Save dengan nama/deskripsi kosong atau hanya spasi; pastikan pesan validasi muncul. Isi tautan dengan format yang salah untuk memeriksa validasi URL opsional.
8. Isi kelima field dan pilih kategori selain default. Tekan Save, cocokkan isi dialog, lalu tekan OK dan pastikan seluruh field kosong serta kategori kembali ke Web Development.
9. Submit kembali dengan hanya nama dan deskripsi; pastikan teknologi/tautan pada dialog tidak memakai nilai submit sebelumnya. Coba tutup dialog melalui Back untuk mempertahankan draf.

---

## Pertanyaan Reflektif

Jawaban Tugas 7 mendokumentasikan implementasi pada minggu tersebut. Refactoring Tutorial 09 memindahkan halaman utama ke `lib/screens/menu.dart` dan menambahkan widget navigasi serta form sebagaimana dijelaskan pada progres Tutorial 09.

### Tugas 7

1. **Apa yang dimaksud dengan widget tree pada Flutter, dan bagaimana hubungan parent-child bekerja?**

   Widget tree adalah susunan hierarkis widget yang mendeskripsikan antarmuka. Parent membungkus atau menata child; widget dengan satu anak biasanya memakai properti `child`, sedangkan widget dengan beberapa anak memakai `children`. Contohnya, `Padding` membungkus `Column`, lalu `Column` menyusun kartu identitas, sambutan, dan menu secara vertikal. Satu widget custom juga dapat membangun subtree melalui `build`.

   Parent meneruskan konfigurasi kepada child. Dalam layout Flutter, constraints mengalir ke bawah, ukuran hasil layout mengalir ke atas, lalu parent menentukan posisi child. `ResponsiveCardWrap` menerima batas lebar dari parent melalui `LayoutBuilder`, menghitung lebar kartu, lalu memasang `SizedBox` untuk masing-masing anak. Karena itu perhitungannya tetap benar setelah padding dan batas lebar halaman diterapkan.

   Sebagian struktur proyek dapat digambarkan sebagai berikut; framework menambahkan widget internal di antara lapisan-lapisan ini:

   ```text
   MyApp
   └── MaterialApp
       └── MyHomePage
           └── Scaffold
               ├── AppBar
               └── SafeArea
                   └── SingleChildScrollView
                       └── Align → ConstrainedBox → Padding → Column
                           ├── ResponsiveCardWrap → InfoCard × 3
                           ├── Container → Column → Text
                           └── ResponsiveCardWrap → ItemCard × 3
   ```

   Widget merupakan konfigurasi immutable. Saat konfigurasi atau state berubah, framework memperbarui tree yang diperlukan dan mempertahankan/mengganti element sesuai tipe dan key; membangun ulang widget tidak berarti seluruh layar selalu digambar ulang. Referensi: [pengantar UI Flutter](https://docs.flutter.dev/ui).
2. **Widget apa saja yang digunakan dalam proyek ini dan apa fungsi masing-masing?**

   Berikut seluruh tipe widget yang diinstansiasi langsung pada kode aplikasi `lib/`, termasuk widget custom. Widget internal yang dibuat otomatis oleh framework tidak dihitung sebagai widget yang ditulis langsung.

   | Widget                    | Fungsi pada proyek                                                     |
   | ------------------------- | ---------------------------------------------------------------------- |
   | `MyApp`                 | Root custom yang menyimpan pilihan tema dalam `State`.               |
   | `MaterialApp`           | Menyediakan konfigurasi aplikasi Material, tema, dan halaman awal.     |
   | `MyHomePage`            | Halaman menu stateless yang menyusun profil, sambutan, dan aksi.       |
   | `Scaffold`              | Kerangka halaman untuk AppBar, body, dan tempat SnackBar tampil.       |
   | `AppBar`                | Menampilkan judul serta akses penggantian tema dan dialog profil.      |
   | `IconButton`            | Tombol berikon untuk tema, informasi profil, dan salin NPM.            |
   | `Text`                  | Menampilkan judul, identitas, deskripsi, serta pesan.                  |
   | `Icon`                  | Menampilkan simbol profil, aksi, tema, dan arah.                       |
   | `SafeArea`              | Menghindarkan body dari area sistem, seperti notch dan inset bawah.    |
   | `SingleChildScrollView` | Menggulir halaman atau isi dialog saat konten lebih tinggi dari ruang. |
   | `Align`                 | Memusatkan area konten secara horizontal di bagian atas.               |
   | `ConstrainedBox`        | Membatasi lebar maksimum area halaman.                                 |
   | `Padding`               | Memberi ruang di dalam halaman dan kartu.                              |
   | `Column`                | Menyusun komponen dan teks secara vertikal.                            |
   | `Row`                   | Menyusun ikon, teks identitas, serta tombol salin secara horizontal.   |
   | `Expanded`              | Memberi teks identitas sisa lebar Row agar bisa membungkus.            |
   | `Spacer`                | Mendorong ikon arah ke sisi kanan kartu aksi.                          |
   | `SizedBox`              | Memberi jarak dan menetapkan lebar kartu hasil perhitungan layout.     |
   | `Container`             | Membentuk panel sambutan berwarna, berpading, dan bersudut membulat.   |
   | `ResponsiveCardWrap`    | Komponen custom untuk memilih jumlah kolom dan lebar kartu.            |
   | `LayoutBuilder`         | Membaca constraints parent ketika menghitung layout kartu.             |
   | `Wrap`                  | Menata kartu dan memindahkannya ke baris baru bila diperlukan.         |
   | `InfoCard`              | Komponen custom yang menyajikan satu informasi identitas.              |
   | `Card`                  | Permukaan kartu identitas dengan bentuk dan batas sesuai tema.         |
   | `ItemCard`              | Komponen custom aksi yang membaca model dan memicu SnackBar.           |
   | `Tooltip`               | Memberi keterangan tambahan ketika kartu di-hover atau ditekan lama.   |
   | `Material`              | Permukaan berwarna unik tempat efek tinta kartu aksi digambar.         |
   | `InkWell`               | Menangani aktivasi kartu dan memberikan ripple/fokus interaksi.        |
   | `SnackBar`              | Pesan sementara untuk tombol aksi dan hasil penyalinan NPM.            |
   | `AlertDialog`           | Dialog ringkasan profil yang dibuka dari AppBar.                       |
   | `TextButton`            | Menutup dialog melalui tombol Tutup.                                   |

   `ThemeData`, `ColorScheme`, `TextStyle`, `BoxDecoration`, `BoxConstraints`, `ItemHomepage`, dan `PortfolioData` adalah konfigurasi/model, bukan widget. `Theme.of`, `MediaQuery.textScalerOf`, `ScaffoldMessenger.of`, serta `Navigator.of` mengakses layanan/ancestor yang disediakan framework. `showDialog` adalah fungsi, bukan widget. Pada tes, `MediaQuery` juga diinstansiasi untuk menyimulasikan teks 200%.
3. **Apa fungsi `MaterialApp`, dan mengapa umumnya digunakan sebagai root widget?**

   `MaterialApp` menggabungkan konfigurasi yang lazim diperlukan aplikasi Material, termasuk tema, navigasi, judul aplikasi, dan dukungan lokalisasi. Dengan menempatkannya dekat root, widget di halaman bawah dapat menggunakan tema dan layanan aplikasi yang konsisten tanpa meneruskan semua konfigurasi melalui parameter secara manual.

   Pada proyek ini, root yang diberikan ke `runApp` adalah `MyApp`; `build` milik `MyApp` menghasilkan `MaterialApp` dengan `theme`, `darkTheme`, `themeMode`, dan `home: MyHomePage(...)`. Komponen halaman membaca warna dari `Theme.of(context)`. Perubahan mode tema di root memperbarui tampilan turunannya. `MaterialApp` tidak wajib menjadi objek paling luar, dan aplikasi dengan sistem desain lain dapat menggunakan root seperti `CupertinoApp` atau `WidgetsApp`. Referensi: [MaterialApp API](https://api.flutter.dev/flutter/material/MaterialApp-class.html).
4. **Apa perbedaan `StatelessWidget` dan `StatefulWidget`, serta kapan masing-masing dipilih?**

   `StatelessWidget` tidak mempunyai objek `State` mutable miliknya sendiri. Hasil `build` ditentukan konfigurasi constructor dan data dari ancestor. Widget ini tetap dapat dibangun ulang saat parent memberi konfigurasi baru atau dependensi seperti tema berubah; stateless bukan berarti hanya dirender sekali atau tidak boleh memiliki tombol.

   `StatefulWidget` juga memiliki konfigurasi immutable, tetapi dipasangkan dengan objek `State` yang bertahan selama element terkait dipertahankan. Data di `State` dapat berubah. Pemanggilan `setState` memberi tahu framework bahwa subtree perlu dibangun ulang. Resource yang dimiliki state, misalnya controller atau subscription, perlu dibersihkan melalui lifecycle yang sesuai.

   `MyHomePage`, `InfoCard`, `ItemCard`, dan `ResponsiveCardWrap` menggunakan `StatelessWidget` karena cukup membaca data dan menjalankan callback. Menampilkan SnackBar tidak mengharuskan `ItemCard` menyimpan state lokal: pengelolaan pesannya ditangani `ScaffoldMessenger`. `MyApp` menggunakan `StatefulWidget` karena pilihan `ThemeMode` harus bertahan antarpemanggilan `build` dan berubah saat pengguna menekan tombol tema. Form dengan input lokal, animasi terkelola, atau status pemuatan yang dimiliki komponen juga merupakan contoh penggunaan stateful. Referensi: [StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html) dan [StatefulWidget](https://api.flutter.dev/flutter/widgets/StatefulWidget-class.html).
5. **Apa itu `BuildContext`, mengapa penting, dan bagaimana penggunaannya dalam `build`?**

   `BuildContext` adalah antarmuka yang merujuk posisi suatu widget di tree; implementasinya berkaitan dengan `Element`. Melalui posisi itu, Flutter dapat mencari ancestor atau dependensi, misalnya tema terdekat, ukuran media, navigator, dan scaffold messenger. Context bukan wadah state global.

   Di dalam `build(BuildContext context)`, proyek ini menggunakan `Theme.of(context)` untuk warna/typography dan `MediaQuery.textScalerOf(context)` untuk menyesuaikan layout dengan ukuran teks. Saat kartu ditekan, `ScaffoldMessenger.of(context)` mengakses messenger ancestor untuk menampilkan SnackBar. Dialog menggunakan `dialogContext` milik builder saat memanggil `Navigator.of(dialogContext).pop()`.

   Posisi context menentukan ancestor yang dapat ditemukan: context dari widget yang sedang membangun suatu child tidak otomatis berada di bawah child tersebut. Jika perlu mengakses layanan yang baru diletakkan di subtree, gunakan context dari builder/anak yang benar. Pada `_copyNpm`, operasi clipboard bersifat asynchronous; kode memeriksa `context.mounted` setelah `await` agar tidak mengakses tree menggunakan context halaman yang sudah dilepas. Referensi: [BuildContext API](https://api.flutter.dev/flutter/widgets/BuildContext-class.html).
6. **Apa itu hot reload, apa bedanya dengan hot restart, dan kapan perlu restart lebih jauh?**

   Hot reload memasukkan perubahan kode Dart ke aplikasi debug yang berjalan lalu membangun ulang widget terkait sambil mempertahankan state. Contohnya, perubahan padding atau warna dapat langsung dilihat tanpa mengulang interaksi. Hot reload tidak menjalankan ulang `main()` atau `initState()`. Di terminal `flutter run`, gunakan `r` jika target mendukungnya.

   Hot restart memulai ulang aplikasi Flutter dan membuang state sesi, sehingga `main()` dan lifecycle inisialisasi berjalan lagi. Gunakan `R` pada terminal. Pada proyek ini, perubahan logika inisialisasi tema yang perlu dijalankan ulang lebih tepat diperiksa dengan hot restart; pilihan tema pengguna kembali ke nilai awal yang mengikuti sistem.

   | Kondisi perubahan                                                                                             | Tindakan yang sesuai                                                                                                      |
   | ------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
   | Teks, padding, warna, atau susunan widget pada `build`                                                      | Hot reload biasanya cukup.                                                                                                |
   | Logika `main()`, inisialisasi `State`, atau initializer global/static yang harus dieksekusi kembali       | Hot restart. State lama yang dipertahankan reload tidak otomatis menjalankan inisialisasi ulang.                          |
   | Perubahan struktur tipe yang ditolak hot reload, misalnya bentuk enum atau parameter generic                  | Hot restart.                                                                                                              |
   | Kode native Kotlin/Java/Swift/Objective-C, konfigurasi platform, atau plugin yang memerlukan kompilasi native | Hentikan aplikasi lalu jalankan kembali untuk full restart/rebuild. Jalankan `flutter pub get` jika dependensi berubah. |
   | Ada error kompilasi                                                                                           | Perbaiki kode terlebih dahulu; restart tidak menggantikan perbaikan error.                                                |

   Hot restart berbeda dengan full restart: yang terakhir meluncurkan ulang aplikasi beserta build bagian platform yang diperlukan, sehingga biasanya lebih lama. Hot reload/restart merupakan fasilitas pengembangan debug, bukan mekanisme pembaruan aplikasi release pengguna. Referensi: [hot reload, restart, dan batasannya](https://docs.flutter.dev/tools/hot-reload).

---

### Tugas 8

1. **Apa perbedaan `Navigator.push()`, `Navigator.pushReplacement()`, dan `Navigator.pop()`? Bagaimana formulir dibuka dari kartu dan bagaimana Home pada drawer bekerja?**

   `push()` menambahkan route ke bagian atas stack sambil mempertahankan route sebelumnya. `pushReplacement()` mengganti route paling atas; route lain di bawahnya tetap ada. `pop()` menghapus route paling atas, misalnya menutup dialog atau kembali dari formulir ke halaman sebelumnya.

   Kartu Tambah Pengalaman pada `project_card.dart` memilih `ExperienceFormPage` melalui `HomepageAction.addExperience`, kemudian membuka `MaterialPageRoute` menggunakan `Navigator.push()`. Jika stack semula `[Home]`, hasilnya menjadi `[Home, ExperienceForm]`; Back menghapus form sehingga menu yang sama tampil kembali.

   `LeftDrawer` menutup drawer terlebih dahulu dengan `pop()` terhadap local history drawer, lalu memakai `pushReplacement()` untuk Home atau formulir tujuan. Opsi Home membangun `MyHomePage` dengan callback tema yang sama. Home dapat dipilih ketika menjalankan aplikasi di Chrome tanpa mengandalkan tombol Back browser. Mengganti route tersebut tidak berarti mengosongkan seluruh stack. Jika opsi yang dipilih sudah aktif, drawer cukup ditutup agar draf tidak hilang.

2. **Bagaimana `Scaffold`, `AppBar`, dan `Drawer` menjaga konsistensi halaman? Berikan contoh penggunaan warna tema pada lebih dari satu halaman.**

   `Scaffold` menyediakan kerangka halaman, termasuk body, area AppBar, drawer, dan penyesuaian ruang saat keyboard muncul. `AppBar` memberi judul serta akses navigasi dan tema. `LeftDrawer` yang sama dipasang pada halaman utama, form Proyek, dan form Pengalaman, sehingga Home, Add Project, dan Add Experience selalu tersedia.

   Kedua formulir menggunakan `PortfolioFormScaffold` untuk menghindari duplikasi AppBar, BackButton, tombol pembuka drawer, kontrol tema, dan SafeArea. Semua halaman memperoleh `ThemeData` dari `MaterialApp`. Contohnya, header drawer dan tombol Save pada form Proyek maupun Simpan pada form Pengalaman membaca `Theme.of(context).colorScheme.primary`; warna teks tombol memakai `onPrimary`. Dengan begitu, pergantian tema terang/gelap memperbarui warna pada kedua halaman secara konsisten, bukan hanya pada halaman awal.

3. **Mengapa layout formulir tersebut dipilih? Apa peran widget pengatur jarak dan penggulir ketika ruang layar terbatas?**

   Form memakai satu `Column` karena urutan input mudah diikuti: posisi, deskripsi, kategori, lalu URL thumbnail. `ConstrainedBox(maxWidth: 760)` menjaga field tidak terlalu lebar pada desktop, sementara `Align` memusatkan area form. `Padding` memberi ruang dari tepi layar, dan `SizedBox` memisahkan field agar label, helper, counter, serta pesan error tidak berdesakan.

   `SingleChildScrollView` membuat seluruh input dan tombol Simpan tetap dapat dijangkau ketika viewport pendek, perangkat landscape, atau keyboard mengambil ruang. `Scaffold` menyesuaikan body terhadap keyboard, dan pengguna juga dapat menutup keyboard dengan drag. Tombol Simpan/Reset disusun memakai `Wrap`, sehingga turun ke baris berikutnya ketika tidak cukup lebar. `SafeArea` menghindari area sistem. Dialog memakai `scrollable: true` dan konten yang dapat digulir agar judul atau deskripsi panjang tidak meluap pada teks 200%. Layout diuji dengan ukuran ponsel, landscape, teks besar, dan simulasi inset keyboard.

4. **Apa peran `GlobalKey<FormState>`, `validator`, dan `validate()` saat Simpan ditekan? Mengapa jenis input atau keyboard saja belum cukup?**

   `GlobalKey<FormState>` disimpan sekali pada objek `State` untuk mengakses state Form yang sama ketika tombol Simpan ditekan. Setiap field mempunyai validator yang mengembalikan pesan error jika input tidak sah, atau `null` jika valid. `_formKey.currentState!.validate()` menjalankan validator dan menampilkan pesan pada field terkait. Jika hasilnya `false`, proses berhenti sebelum dialog dibuka; jika `true`, controller dibaca dan di-trim untuk membentuk snapshot `Experience` yang ditampilkan melalui `showDialog()`.

   Contohnya, posisi berisi tiga spasi ditolak karena kosong setelah `trim()`, judul 256 karakter melampaui batas model 255, dan `javascript:alert(1)` ditolak sebagai thumbnail karena skemanya bukan HTTP/HTTPS. Kategori juga diperiksa, sementara thumbnail kosong diperbolehkan. Validasi dipisahkan pada `ExperienceValidators` sehingga batas model dapat diuji tanpa membangun UI. Setelah percobaan submit, perubahan input divalidasi ulang untuk membantu koreksi.

   `TextInputType.url` hanya meminta susunan keyboard yang sesuai; pengguna masih dapat menempelkan string tidak valid. Dropdown mempersempit pilihan tetapi bukan pengganti pemeriksaan nilai dan kontrak data. Ketika integrasi API ditambahkan, server tetap perlu menjalankan validasi dan otorisasinya sendiri. Referensi: [form dan validasi Flutter](https://docs.flutter.dev/cookbook/forms/validation).

---

## AI Disclosure

### 1. Tools yang Digunakan

- **antigravity 3.8 flash**.

### 2. Bagian yang Dibantu AI

- **Analisis Tugas**: Membaca instruksi dan rubrik Tugas 7, memeriksa implementasi Tutorial 08, serta memetakan perubahan yang diperlukan.
- **UI/UX**: Membantu menyusun layout responsif, tema terang/gelap, tooltip, serta penyesuaian untuk teks besar.
- **Pengujian**: Membantu menyusun tes widget untuk identitas, warna, interaksi, clipboard, tema, dan layout pada beberapa ukuran layar.
- **Dokumentasi**: Membantu merapikan setup, progres pengerjaan, struktur proyek, serta jawaban reflektif yang dikaitkan dengan implementasi aplikasi.
- **Tutorial 09**: Membantu menerapkan drawer dan stack navigasi, form proyek, validasi, dialog ringkasan, reset data, migrasi impor Material, refactoring screens/widgets, serta tes regresinya.
- **Tugas 8**: Membaca rubrik, mencocokkan field dengan Experience pada proyek Django, membuat form Pengalaman dan validator, menambahkan navigasi, mengekstrak kerangka form bersama, serta menyusun pengujian dan empat jawaban reflektif.

### 3. Strategi Prompting

- Memberikan PDF tugas dan rubrik sebagai acuan utama sebelum perubahan kode dilakukan.
- Meminta implementasi sesuai materi dasar Flutter, kemudian memeriksa fitur tambahan yang relevan untuk interaktivitas dan kenyamanan penggunaan.
- Memberikan revisi terarah pada dokumentasi: menghapus folder tambahan dan memusatkan penjelasan pada README.
- Untuk Tutorial 09, menggunakan PDF sebagai acuan, melanjutkan hasil merge Tugas 7, mempertahankan perubahan manual README, dan membedakan implementasi lokal dari perintah commit yang hanya diberikan sebagai teks.
- Untuk Tugas 8, melanjutkan kode Tutorial 09, memilih bagian portofolio berdasarkan model yang benar-benar ada, memeriksa field editable/read-only, mempertahankan nama model pada disclosure, dan menyiapkan perintah Git tanpa menjalankannya.

### 4. Analisis Kritis dan Perbaikan

**Keterbatasan AI dan hasil pengujian:**

- AI dapat memakai data contoh atau menebak identitas. Data profil perlu dicocokkan dengan sumber yang sudah tersedia pada proyek pemilik.
- Kode layout yang tampak benar pada desktop dapat overflow pada layar kecil atau ketika ukuran teks diperbesar.
- Operasi clipboard bergantung pada platform dan izin browser; keberhasilan pada mock tidak membuktikan semua perangkat mendukung perilaku yang sama.
- Kode asynchronous perlu memeriksa lifecycle widget sebelum memakai `BuildContext` kembali.
- Dokumentasi dapat mencantumkan kemampuan yang belum tersedia. Form Tutorial 09 hanya menampilkan ringkasan dan tidak menyimpan data permanen; pilihan tema hanya berlaku selama sesi aplikasi.

**Koreksi yang diterapkan:**

- Mengganti identitas Burhan dengan Faris Salman Azhari, NPM `2506615223`, kelas PBP F, berdasarkan data pada proyek portofolio.
- Memindahkan warna ke model `ItemHomepage` agar tidak ada logika pewarnaan berulang di komponen kartu.
- Menghitung ukuran kartu dari constraints parent dan menggunakan satu kolom saat ruang sempit atau teks besar.
- Membersihkan antrean SnackBar saat tombol baru ditekan agar pesan lama tidak tampil belakangan.
- Menambahkan pemeriksaan `context.mounted` dan penanganan `PlatformException` pada proses salin NPM.
- Menempatkan state tema pada `MyApp` agar `MyHomePage` tetap stateless, sesuai materi tugas.
- Memeriksa hasil melalui formatter, analyzer, 14 tes widget, dan build web release. Pengujian tersebut tidak menggantikan pemeriksaan langsung pada seluruh perangkat target.
- Pada Tutorial 09, memakai nilai awal dropdown yang tetap, mereset variabel ringkasan bersama field, mempertahankan callback tema saat navigasi, dan menyesuaikan tinggi dropdown untuk teks besar. Versi Material diperiksa terhadap SDK lokal sebelum penambahan dependensi.
- Pada Tugas 8, mencocokkan enam kategori dan batas 255/200 dengan model, form, serta serializer web; tanggal read-only tidak diubah menjadi input tambahan yang tidak sesuai kontrak.
- Memisahkan validator dari UI dan memakai snapshot immutable untuk dialog agar ringkasan tidak membaca state lama atau controller yang kemudian berubah. Tujuan kartu ditentukan oleh enum, bukan teks label.
- Mengekstrak kerangka formulir bersama, mereset controller dan mode validasi secara eksplisit, serta melepaskan controller melalui `dispose()`. Penghitung dan validator panjang judul mengikuti jumlah Unicode code point.
- Perbaikan dicatat berdasarkan pemeriksaan kode dan hasil tes; tidak ada klaim pengujian manual pengguna, penyimpanan permanen, kelulusan di semua perangkat, atau jaminan nilai maksimal. Validasi frontend memeriksa kontrak lokal dan tidak menggantikan validasi backend.

### 5. Log Prompt Utama

Kutipan instruksi utama pada pengerjaan Tugas 7:

1. *"Periksa kelengkapan Tugas 7 Flutter di workspace VS Code berdasarkan tugas-7.pdf. Verifikasi kelanjutan Tutorial 08, pemisahan lib/menu.dart dari main.dart, MyHomePage sebagai StatelessWidget, serta tiga InfoCard berisi NPM, nama lengkap, dan kelas. Uji minimal tiga ItemCard untuk melihat portofolio, menambah item, dan logout beserta ikon, warna kontras, dan SnackBar sesuai nama tombol. Jalankan flutter analyze. Periksa README.md, termasuk enam jawaban reflektif, petunjuk setup, dan pengungkapan penggunaan AI. Untuk setiap syarat, tuliskan status, bukti berupa lokasi kode atau hasil pengujian, serta perbaikan yang diperlukan tanpa mengubah berkas."*


**Log permintaan Tugas 8 (ringkasan):** Terapkan `tugas-8.pdf` pada proyek mobile, kerjakan kode dan jawaban reflektif sesuai rubrik, lanjutkan AI disclosure tanpa mengubah keterangan model, jangan melakukan commit, lalu berikan teks perintah `git switch -c`, `git add`, dan `git commit`.

Kutipan batasan pengguna: *"Jangan melakukan commit apapun."* dan *"lanjutkan ai disclosure tanpa mengubah keterangan model"*.
