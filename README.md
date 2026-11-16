# Portofolio Mobile - Faris Salman Azhari

**Nama:** Faris Salman Azhari

**NPM:** 2506615223

**Kelas:** PBP F

**Repositori:** [myportofolio_mobile](https://github.com/Faris2506615223/myportofolio_mobile)

---

## Deskripsi Proyek

Aplikasi portofolio pribadi berbasis Flutter yang dikembangkan untuk mata kuliah Pemrograman Berbasis Platform, Fakultas Ilmu Komputer, Universitas Indonesia, Semester Gasal 2026/2027. Proyek ini melanjutkan Tutorial 08 dan Tugas 7, kemudian menambahkan navigasi, drawer, layout, dan formulir proyek melalui Tutorial 09.

Antarmuka menggunakan Material 3 dengan komponen yang dipisahkan agar mudah digunakan kembali. Fitur tambahan mencakup tema terang dan gelap, tata letak responsif, salin NPM, serta dialog informasi profil. Ketiga tombol utama tetap menampilkan SnackBar. Tombol Tambah Proyek juga membuka formulir dengan lima field, validasi, dan dialog ringkasan. Data formulir belum disimpan permanen; daftar proyek dan autentikasi belum diimplementasikan.

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
| Layout adaptif    | Tiga kolom saat lebar area kartu minimal 780 logical pixels dan ukuran teks normal; satu kolom pada area lebih sempit atau teks besar. Lebar halaman dibatasi hingga 1120 logical pixels. |
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

| Field | Widget | Aturan |
| --- | --- | --- |
| Nama Proyek | `TextFormField` | Wajib diisi; input yang hanya berisi spasi ditolak. |
| Deskripsi Proyek | `TextFormField` dengan `maxLines: 5` | Wajib diisi; input kosong atau whitespace ditolak. |
| Kategori Proyek | `DropdownButtonFormField<String>` | Pilihan: Web Development, Mobile Development, Machine Learning, Data Science, dan Other. Default Web Development. |
| Teknologi yang Digunakan | `TextFormField` | Opsional, misalnya Flutter, Django, Figma. |
| Tautan Proyek | `TextFormField` dengan keyboard URL | Opsional; jika diisi harus berupa URL HTTP/HTTPS dengan host yang valid dan tanpa whitespace. |

### Perbedaan Navigasi yang Diterapkan

| Interaksi | Method | Perilaku |
| --- | --- | --- |
| Kartu Tambah Proyek | `Navigator.push` | Menambahkan formulir ke atas stack dan mempertahankan menu untuk kembali dengan Back. |
| Drawer Home / Add Project | `Navigator.pushReplacement` | Mengganti route paling atas setelah drawer ditutup; tidak menghapus route lain di bawahnya. |
| Tombol Back pada formulir | `Navigator.pop` melalui `BackButton` | Menghapus formulir yang dibuka dari kartu, lalu kembali ke menu yang sama. |
| Tombol OK pada dialog | `Navigator.pop` | Menutup dialog; setelah dikonfirmasi, state dan field formulir direset. |

`DropdownButtonFormField` memakai nilai awal yang tetap. Nilai kategori yang dipilih disimpan terpisah agar `FormState.reset()` benar-benar kembali ke default, termasuk pada submit kedua. Tinggi item dropdown dapat mengikuti teks. Judul dan isi dialog juga dapat digulir agar tetap dapat digunakan pada layar kecil dengan teks sistem yang diperbesar. Tidak ada penyimpanan database pada tahap tutorial ini.

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
|   `-- item_homepage.dart          # Model aksi immutable
|-- screens/
|   |-- menu.dart                   # MyHomePage: StatelessWidget
|   `-- project_form.dart           # Form, validasi, dialog, dan reset
`-- widgets/
    |-- info_card.dart              # Kartu identitas
    |-- left_drawer.dart            # Drawer Home dan Add Project
    |-- project_card.dart           # ItemCard, SnackBar, dan navigasi
    `-- responsive_card_wrap.dart   # Layout kartu adaptif

test/
|-- widget_test.dart                # Tes regresi fitur Tugas 7
`-- navigation_form_test.dart       # Tes drawer, form, reset, dan layout
```

Identitas dan daftar aksi dipusatkan dalam `PortfolioData`. Untuk menambahkan menu, cukup tambahkan konfigurasi `ItemHomepage` pada `PortfolioData.items`. `ResponsiveCardWrap` mengatur lebar kartu berdasarkan ruang yang tersedia, sedangkan masing-masing komponen kartu menangani tampilan dan interaksinya sendiri.

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

| Pemeriksaan                          | Hasil                                                                             |
| ------------------------------------ | --------------------------------------------------------------------------------- |
| Formatter Dart                       | Seluruh berkas `lib/` dan `test/` sudah sesuai format.                        |
| `flutter analyze`                  | **No issues found!**                                                        |
| `flutter test --reporter expanded` | **27 tes lulus.**                                                           |
| `flutter build web --release`      | **Berhasil**, dengan output pada `build/web`. Wasm dry run juga berhasil. |
| Tes navigasi/form pada Chrome | Belum selesai: suite tetap pada tahap `loading` setelah sekitar lima menit, lalu proses dihentikan. |

Cakupan tes meliputi identitas pemilik, menu stateless, warna kartu yang dirender, pesan ketiga tombol, penggantian pesan saat tap cepat, clipboard berhasil/gagal, tema sistem dan penggantian dua arah, serta buka/tutup dialog profil. Layout diuji pada ukuran 320 x 568, 390 x 844, 768 x 1024, 1024 x 600, dan 1440 x 900 logical pixels, ditambah teks 200% pada layar 320 x 568.

Tes Tutorial 09 memeriksa perubahan stack (`push` vs `pushReplacement`), kembali dengan Back, kelima isian dialog, kategori default dan reset, submit kedua tanpa data lama, validasi whitespace/URL, draf ketika dialog dibatalkan atau menu aktif dipilih, serta tema setelah navigasi. Form, dialog, dan drawer diperiksa pada layar kecil dan teks 200%; keyboard juga disimulasikan agar tombol Save tetap terjangkau.

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

## AI Disclosure

### 1. Tools yang Digunakan

- **antigravity 3.8 flash**.

### 2. Bagian yang Dibantu AI

- **Analisis Tugas**: Membaca instruksi dan rubrik Tugas 7, memeriksa implementasi Tutorial 08, serta memetakan perubahan yang diperlukan.
- **UI/UX**: Membantu menyusun layout responsif, tema terang/gelap, tooltip, serta penyesuaian untuk teks besar.
- **Pengujian**: Membantu menyusun tes widget untuk identitas, warna, interaksi, clipboard, tema, dan layout pada beberapa ukuran layar.
- **Dokumentasi**: Membantu merapikan setup, progres pengerjaan, struktur proyek, serta jawaban reflektif yang dikaitkan dengan implementasi aplikasi.
- **Tutorial 09**: Membantu menerapkan drawer dan stack navigasi, form proyek, validasi, dialog ringkasan, reset data, migrasi impor Material, refactoring screens/widgets, serta tes regresinya.

### 3. Strategi Prompting

- Memberikan PDF tugas dan rubrik sebagai acuan utama sebelum perubahan kode dilakukan.
- Meminta implementasi sesuai materi dasar Flutter, kemudian memeriksa fitur tambahan yang relevan untuk interaktivitas dan kenyamanan penggunaan.
- Memberikan revisi terarah pada dokumentasi: menghapus folder tambahan dan memusatkan penjelasan pada README.
- Untuk Tutorial 09, menggunakan PDF sebagai acuan, melanjutkan hasil merge Tugas 7, mempertahankan perubahan manual README, dan membedakan implementasi lokal dari perintah commit yang hanya diberikan sebagai teks.

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

### 5. Log Prompt Utama

Kutipan instruksi utama pada pengerjaan Tugas 7:

1. *"Periksa kelengkapan Tugas 7 Flutter di workspace VS Code berdasarkan tugas-7.pdf. Verifikasi kelanjutan Tutorial 08, pemisahan lib/menu.dart dari main.dart, MyHomePage sebagai StatelessWidget, serta tiga InfoCard berisi NPM, nama lengkap, dan kelas. Uji minimal tiga ItemCard untuk melihat portofolio, menambah item, dan logout beserta ikon, warna kontras, dan SnackBar sesuai nama tombol. Jalankan flutter analyze. Periksa README.md, termasuk enam jawaban reflektif, petunjuk setup, dan pengungkapan penggunaan AI. Untuk setiap syarat, tuliskan status, bukti berupa lokasi kode atau hasil pengujian, serta perbaikan yang diperlukan tanpa mengubah berkas."*

**Tutorial 09:** Permintaan berikutnya adalah melanjutkan hasil merge Tugas 7 dengan seluruh implementasi `tutorial-9.pdf`, tanpa melakukan commit, kemudian memberikan perintah `git add` dan `git commit` untuk dijalankan pengguna.
