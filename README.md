# myportofolio_mobile

Aplikasi mobile Flutter untuk portofolio pribadi Faiz Yusuf Elriki, dikembangkan untuk mata kuliah Pemrograman Berbasis Platform (CSGE602022), Fakultas Ilmu Komputer Universitas Indonesia, Semester Gasal 2026/2027. Aplikasi ini adalah pendamping mobile dari situs portofolio Django `myportofolio`.

Status saat ini (Tugas 7): halaman utama menampilkan tiga kartu identitas (`InfoCard`) dan tiga kartu aksi berwarna (`ItemCard`) yang memunculkan `SnackBar` saat ditekan.

## Menjalankan Proyek

Prasyarat: Flutter SDK terpasang dan `flutter doctor` tidak menunjukkan masalah pada Flutter, Android toolchain, dan Chrome.

```bash
git clone https://github.com/<username>/myportofolio_mobile.git
cd myportofolio_mobile
flutter pub get
flutter run -d chrome
flutter analyze
```

## AI Disclosure — Tugas 6

Dalam pengerjaan Tugas Individu 6 ini, saya memanfaatkan AI (Claude) untuk menganalisis materi Tutorial 07 serta instruksi spesifikasi tugas 06. AI membimbing saya secara bertahap dalam memahami konsep REST API, DRF, Serializer, serta mekanisme keamanan autentikasi dan CSRF.

Saya tidak pernah menyalin dan menempelkan kode yang diberikan AI begitu saja. Pendekatan yang digunakan AI berupa bimbingan instruksional bertahap: AI menjelaskan konsep atau menunjukkan letak kesalahan pada alur logika/test, kemudian saya menulis sendiri perbaikan kodenya sebelum dievaluasi ulang.

### Tugas 7
1. Widget tree adalah struktur hierarki tempat seluruh antarmuka Flutter disusun. Hampir semuanya adalah widget, dan widget saling bersarang dengan satu akar. Pada proyek ini, akarnya `MyApp` yang membungkus `MaterialApp`, lalu `MyHomePage`, `Scaffold`, `Column`, `Row`, sampai widget daun seperti `Text` dan `Icon`. Hubungan induk-anak (parent-child) berarti induk memuat anak melalui properti `child` atau `children`. Induk memberi batasan ukuran (constraint) ke anak, anak menentukan ukurannya dalam batasan itu, lalu induk menentukan posisinya. Jika induk dibangun ulang, anak-anaknya ikut dibangun ulang. Contohnya, `Row` adalah induk dari tiga `InfoCard`.
2. Widget yang digunakan:
   - `MyApp`, `MyHomePage`, `InfoCard`, `ItemCard`: widget buatan sendiri untuk aplikasi, halaman utama, kartu identitas, dan kartu aksi.
   - `MaterialApp`: akar aplikasi berbasis Material Design yang mengatur tema dan navigasi.
   - `Scaffold`: kerangka halaman (AppBar, body, tempat `SnackBar`).
   - `AppBar`: bar judul di bagian atas halaman.
   - `Padding`: memberi jarak di sekeliling widget lain.
   - `Column` dan `Row`: menyusun anak secara vertikal dan horizontal.
   - `Center`: menempatkan anak di tengah.
   - `SizedBox`: memberi jarak kosong dengan ukuran tetap.
   - `Card`: kartu dengan bayangan untuk `InfoCard`.
   - `Container`: kotak dengan lebar, padding, dan dekorasi.
   - `GridView.count`: menata `ItemCard` dalam kisi tiga kolom.
   - `Material`: permukaan Material yang menyediakan warna latar dan sudut membulat untuk `ItemCard`.
   - `InkWell`: area yang dapat ditekan dengan efek riak dan menjalankan `onTap`.
   - `Icon`: menampilkan ikon.
   - `Text`: menampilkan teks.
   - `SnackBar`: pesan singkat di bagian bawah layar, ditampilkan melalui `ScaffoldMessenger`.
3. `MaterialApp` adalah widget yang menyiapkan fondasi aplikasi Material Design: tema (`ThemeData`), judul, halaman awal (`home`), `Navigator` beserta rute, dan `ScaffoldMessenger` untuk `SnackBar`. Widget ini umumnya menjadi root karena banyak widget Material seperti `Scaffold`, `AppBar`, dan `SnackBar` membutuhkan tema dan layanan tersebut di atasnya, sehingga seluruh halaman di bawahnya otomatis mendapat gaya dan navigasi yang konsisten.
4. `StatelessWidget` tidak menyimpan state yang berubah. Tampilannya hanya bergantung pada properti yang diberikan lewat konstruktor, sehingga ia hanya berubah jika induknya membangunnya ulang dengan data baru. `StatefulWidget` memiliki objek `State` terpisah yang menyimpan data yang dapat berubah selama aplikasi berjalan, dan tampilan diperbarui dengan memanggil `setState`. Pilih `StatelessWidget` untuk tampilan statis seperti halaman menu ini. Pilih `StatefulWidget` saat tampilan harus berubah karena interaksi atau data, misalnya penghitung, isi form, atau hasil permintaan jaringan.
5. `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree. Lewat `BuildContext`, widget dapat mencari widget leluhur dan mengambil data darinya. Pada metode `build`, contohnya `Theme.of(context)` untuk membaca tema, `MediaQuery.of(context)` untuk membaca ukuran layar, dan `ScaffoldMessenger.of(context)` untuk menampilkan `SnackBar`. Karena posisinya berbeda-beda, hasil pencarian itu juga bergantung pada context yang dipakai.
6. Hot reload menyuntikkan kode Dart yang telah diubah ke aplikasi yang sedang berjalan dan membangun ulang widget tree tanpa memulai ulang aplikasi, sehingga state yang ada dipertahankan. Hot restart memulai ulang aplikasi dari awal, menjalankan ulang `main()`, dan menghapus state, tetapi lebih cepat daripada menjalankan ulang total. Hot reload tidak cukup, dan kita harus melakukan hot restart, ketika yang berubah adalah `main()`, inisialisasi variabel global atau statik, atau logika yang hanya berjalan sekali seperti `initState`. Full restart (berhenti lalu `flutter run` lagi) diperlukan ketika menambah atau mengubah dependensi di `pubspec.yaml`, mengubah kode native Android atau iOS, atau mengubah konfigurasi platform seperti `AndroidManifest.xml`.