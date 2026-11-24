[![CI](https://github.com/DeCorbeau/myportofolio_mobile/actions/workflows/main.yaml/badge.svg)](https://github.com/DeCorbeau/myportofolio_mobile/actions/workflows/main.yaml)

Nama : Faiz Yusuf Elriki

NPM : 2506607921

Kelas : PBP A

## Tentang Proyek

Repositori aplikasi mobile Flutter yang menjadi pendamping dari website portofolio pribadi saya ([myportofolio](https://github.com/DeCorbeau/myportofolio), dibangun dengan Django). Aplikasi ini dibangun bertahap untuk memenuhi tugas individu mata kuliah Pemrograman Berbasis Platform (PBP) pada paruh kedua semester ini.

Pada tahap Tugas 7, halaman utama aplikasi berisi tiga bagian:
- **Kartu identitas (`InfoCard`)**: tiga kartu yang menampilkan NPM, nama lengkap, dan kelas saya.
- **Menu aksi portofolio (`ItemCard`)**: tiga tombol berbentuk kartu, yaitu View Skills, Add Skill, dan Logout. Setiap tombol memiliki warna latar berbeda yang diambil dari model `ItemHomepage`, dan memunculkan `SnackBar` saat ditekan.
- **Tema visual**: tema gelap dengan aksen ungu, logo "Faiz.", dan font Space Grotesk yang mengikuti tampilan website portofolio saya.

Pada tahap Tugas 9 (dengan Tutorial 10 sebagai prasyarat), aplikasi terhubung ke API Django REST Framework milik website:
- **Model JSON**: `Skill` (Tutorial 10) dan `Experience` (Tugas 9) memakai `@JsonSerializable`, dengan berkas `*.g.dart` yang dihasilkan `build_runner`.
- **`ApiClient` dan `ApiException`**: `GET` publik dan `POST` terautentikasi dengan header `Authorization: Token <key>`.
- **`AuthState` dan `MultiProvider`**: menyimpan token di memori, dengan `ensureLoggedIn(context)` sebagai penjaga halaman yang memerlukan login.
- **Layar daftar dan detail** untuk Skill dan Experience menggunakan `FutureBuilder` dan `RefreshIndicator`, lengkap dengan status loading, error (tombol Retry), dan kosong.
- **Form terautentikasi**: form Skill dan Experience mengirim `POST` ke API, menangani `401` (sesi dihapus dan login ulang) dan `403` (bukan pemilik portofolio).
- **CI/CD**: GitHub Actions dengan `very_good_workflows` dan unggahan artefak APK release.

Halaman utama kini berisi kartu View Skills, View Experiences, Add Experience, Add Skill, dan Logout. Struktur kode:

```
lib/
  config.dart          # API_BASE_URL
  main.dart            # MultiProvider (ApiClient, AuthState)
  models/              # skill.dart, experience.dart (+ *.g.dart hasil generate)
  services/            # api_client.dart, auth_state.dart
  screens/             # menu, login, daftar/detail, form
  widgets/             # drawer, kartu, auth_guard, helper form
```

## Cara Menjalankan Proyek Secara Lokal

Prasyarat: Flutter SDK, Android Studio (untuk Android SDK), dan VS Code dengan ekstensi Flutter sudah terpasang. Pastikan `flutter doctor` tidak menunjukkan masalah pada Flutter, Android toolchain, dan Chrome. Untuk menjalankan backend secara lokal, diperlukan juga Python.

### Backend (Django REST Framework)

Aplikasi ini membaca dan menulis data ke backend website portofolio saya:

- **API yang telah di-deploy:** https://faiz-yusuf51-myportofolio.pws.cs.ui.ac.id. Endpoint berada di bawah `/api/v1/`, misalnya `/api/v1/skills/` dan `/api/v1/experiences/`.
- **Repositori backend:** [DeCorbeau/myportofolio](https://github.com/DeCorbeau/myportofolio). Untuk menjalankannya lokal, ikuti README repositori tersebut, lalu jalankan `python manage.py migrate` dan `python manage.py runserver` (server berjalan di `http://localhost:8000`).
- **Hak akses:** operasi baca (`GET`) bersifat publik. Operasi tulis (`POST`) memerlukan token dari `POST /api/v1/auth/token/` dan hanya diizinkan untuk pemilik portofolio (superuser). Untuk mencoba penambahan data di backend lokal, buat akun dengan `python manage.py createsuperuser`.

### Aplikasi Flutter

1. Clone repository ini, lalu masuk ke foldernya.
2. Ambil dependensi:
   ```
   flutter pub get
   ```
3. Hasilkan berkas `*.g.dart` untuk model JSON. Berkas ini tidak di-commit (ada di `.gitignore`), jadi langkah ini wajib setelah clone dan setiap kali model berubah:
   ```
   dart run build_runner build --delete-conflicting-outputs
   ```
4. Jalankan aplikasi dengan menentukan alamat backend lewat `--dart-define=API_BASE_URL=...` (tanpa garis miring di akhir):
   - Chrome dengan Django lokal:
     ```
     flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
     ```
   - Chrome dengan backend yang telah di-deploy:
     ```
     flutter run -d chrome --dart-define=API_BASE_URL=https://faiz-yusuf51-myportofolio.pws.cs.ui.ac.id
     ```
   - Emulator Android dengan Django lokal: cukup `flutter run`. Nilai bawaan `API_BASE_URL` adalah `http://10.0.2.2:8000`, yaitu alamat komputer host dari sudut pandang emulator.
5. Periksa kualitas kode (sama dengan yang dijalankan CI):
   ```
   dart format --set-exit-if-changed lib test
   flutter analyze
   flutter test
   ```
6. APK release dibangun otomatis oleh GitHub Actions. Unduh artefak `app-release-apk` dari halaman run pada tab Actions, atau bangun sendiri:
   ```
   flutter build apk --release --dart-define=API_BASE_URL=https://faiz-yusuf51-myportofolio.pws.cs.ui.ac.id
   ```

## Assets & Credits

- Font **Space Grotesk** dari Google Fonts, disertakan sebagai aset pada folder `assets/fonts/`.
- Palet warna dan identitas visual mengikuti website portofolio saya (`static/css/style.css` pada repositori myportofolio).

## Progres Tugas Mingguan

### Tugas 7

1. **Jelaskan apa yang dimaksud dengan widget tree pada Flutter dan bagaimana hubungan induk-anak (parent-child) bekerja antar-widget!**

   Widget tree adalah struktur hierarki tempat seluruh antarmuka Flutter disusun. Hampir semua elemen tampilan adalah widget dan widget-widget tersebut saling bersarang dengan satu akar. Pada proyek ini, akarnya adalah `MyApp` yang mengembalikan `MaterialApp`, lalu `MyHomePage`, `Scaffold`, `Column`, `Row`, hingga widget daun seperti `Text` dan `Icon`.

   Pada hubungan induk-anak (parent-child), parent memuat child melalui properti `child` atau `children`. Parent memberikan batasan ukuran (constraint) kepada child, child menentukan ukurannya sendiri di dalam batasan tersebut, lalu parent menentukan posisinya. Contohnya, `Row` adalah parent dari tiga `InfoCard`, dan `GridView.count` adalah parent dari `ItemCard`. Ketika sebuah parent dibangun ulang, child-nya ikut dibangun ulang. Data juga mengalir dari parent ke child melalui konstruktor, misalnya `ItemCard(item)` menerima objek `ItemHomepage` dari parent-nya dan memakai `item.color` serta `item.name` dari objek tersebut.

2. **Sebutkan semua widget yang kamu gunakan dalam proyek ini dan jelaskan fungsinya masing-masing!**

   Widget buatan sendiri:
   - `MyApp`: widget akar aplikasi yang mengembalikan `MaterialApp`.
   - `MyHomePage`: halaman utama berupa `StatelessWidget`, berisi kartu identitas dan menu aksi.
   - `InfoCard`: kartu yang menampilkan judul dan isi, dipakai untuk NPM, Name, dan Class.
   - `ItemCard`: kartu tombol aksi berwarna yang memunculkan `SnackBar` saat ditekan.

   Widget bawaan Flutter:
   - `MaterialApp`: akar aplikasi berbasis Material Design yang mengatur tema, judul, halaman awal, dan navigasi.
   - `Scaffold`: kerangka dasar halaman (AppBar, body, dan tempat tampil `SnackBar`).
   - `AppBar`: bar judul di bagian atas halaman.
   - `Text`: menampilkan teks, termasuk `Text.rich` untuk logo "Faiz." dengan titik berwarna ungu.
   - `Padding`: memberi jarak di sekeliling widget lain.
   - `Column` dan `Row`: menyusun anak secara vertikal dan horizontal.
   - `Center`: menempatkan anak di tengah.
   - `SizedBox`: memberi jarak kosong dengan ukuran tetap.
   - `Card`: kartu bersudut membulat yang menjadi dasar `InfoCard`.
   - `Container`: kotak dengan lebar, padding, dan dekorasi.
   - `GridView.count`: menata `ItemCard` dalam kisi tiga kolom.
   - `Material`: permukaan Material yang menyediakan warna latar dan sudut membulat untuk `ItemCard`.
   - `InkWell`: area yang dapat ditekan, dengan efek riak dan callback `onTap`.
   - `Icon`: menampilkan ikon pada setiap `ItemCard`.
   - `SnackBar`: pesan singkat di bagian bawah layar, ditampilkan melalui `ScaffoldMessenger`.

3. **Apa fungsi dari widget `MaterialApp`? Jelaskan mengapa widget ini umumnya digunakan sebagai root widget pada aplikasi Flutter!**

   `MaterialApp` adalah widget yang menyiapkan fondasi aplikasi Material Design, yaitu tema (`ThemeData`), judul aplikasi, halaman awal (`home`), `Navigator` beserta rute, dan `ScaffoldMessenger` yang mengelola `SnackBar`. Pada proyek ini, tema gelap beserta warna aksen dan font didefinisikan sekali pada `MaterialApp`, lalu berlaku untuk seluruh halaman di bawahnya.

   Widget ini umumnya menjadi root karena banyak widget Material seperti `Scaffold`, `AppBar`, dan `SnackBar` membutuhkan tema dan layanan tersebut pada leluhurnya agar dapat berfungsi. Dengan menempatkannya di akar, semua halaman otomatis memperoleh gaya dan navigasi yang konsisten.

4. **Jelaskan perbedaan antara `StatelessWidget` dan `StatefulWidget`! Kapan kita sebaiknya memilih `StatelessWidget` dan kapan harus menggunakan `StatefulWidget`?**

   `StatelessWidget` tidak menyimpan state yang berubah. Tampilannya hanya bergantung pada properti yang diberikan melalui konstruktor sehingga ia hanya berubah jika parent-nya membangunnya ulang dengan data baru. `StatefulWidget` memiliki objek `State` terpisah yang menyimpan data yang dapat berubah selama aplikasi berjalan dan tampilannya diperbarui dengan memanggil `setState`.

   Saya memilih `StatelessWidget` untuk `MyHomePage`, `InfoCard`, dan `ItemCard` karena isinya statis. Data identitas dan daftar menu tidak berubah, dan penekanan tombol hanya memunculkan `SnackBar` tanpa mengubah tampilan widget itu sendiri. `StatefulWidget` baru diperlukan ketika tampilan harus berubah akibat interaksi atau data, misalnya penghitung pada proyek bawaan Flutter, isian form, atau hasil permintaan jaringan.

5. **Apa itu `BuildContext` dan mengapa penting di Flutter? Bagaimana penggunaannya di dalam metode `build`?**

   `BuildContext` adalah penanda posisi sebuah widget di dalam widget tree. Melalui `BuildContext`, sebuah widget dapat mencari widget leluhurnya dan mengambil data darinya. Hal ini penting karena data seperti tema, ukuran layar, dan `ScaffoldMessenger` tidak dikirim lewat konstruktor, melainkan dicari ke atas pohon dari posisi widget tersebut.

   Pada metode `build` proyek ini, `MediaQuery.of(context)` pada `InfoCard` membaca lebar layar untuk menentukan lebar kartu, dan `ScaffoldMessenger.of(context)` pada `ItemCard` mengambil pengelola `SnackBar` yang disediakan `MaterialApp`. Karena hasil pencarian bergantung pada posisi, context yang berbeda dapat menghasilkan data yang berbeda.

6. **Jelaskan konsep hot reload di Flutter dan apa perbedaannya dengan hot restart! Kapan kita tidak bisa hanya mengandalkan hot reload dan harus melakukan hot restart atau full restart?**

   Hot reload mengirimkan kode Dart yang telah diubah ke aplikasi yang sedang berjalan, lalu membangun ulang widget tree tanpa memulai ulang aplikasi sehingga state yang ada dipertahankan. Hot restart memulai ulang aplikasi dari awal, menjalankan ulang `main()`, dan menghapus state, tetapi lebih cepat daripada menjalankan ulang aplikasi secara total.

   Hot reload tidak cukup, dan kita harus melakukan hot restart, ketika yang berubah adalah `main()`, inisialisasi variabel global atau statik, atau logika yang hanya berjalan sekali seperti `initState`. Full restart (berhenti, lalu `flutter run` lagi) diperlukan ketika kita mengubah `pubspec.yaml` seperti menambah dependensi atau aset, mengubah kode native Android atau iOS, atau mengubah konfigurasi platform seperti `AndroidManifest.xml`.

**AI Disclosure — Tugas 7**

Dalam pengerjaan Tugas Individu 7 dan Tutorial 08 ini, saya memanfaatkan AI (Claude) sebagai asisten belajar untuk menganalisis spesifikasi tugas serta berkas tutorial. AI membimbing saya secara bertahap mulai dari konfigurasi lingkungan pengembangan Flutter dari nol, pemahaman hierarki *widget tree*, hingga penyesuaian tema visual aplikasi.

Saya tidak menerima kode yang diberikan AI begitu saja. Meskipun AI sempat memberikan potongan kode untuk tutorial dan penyesuaian tema, saya tetap mengevaluasinya secara mandiri dengan menguji aplikasi di browser Chrome dan memastikan flutter analyze bersih tanpa error. Selain itu, saya juga aktif mengoreksi AI ketika instruksi penyiapan environment-nya sempat melenceng dari berkas tutorial.

### 1. Strategi Prompting & Ranah Bantuan AI
* **Konfigurasi Environment & Tutorial:** Mengunggah instruksi `.md` dan meminta panduan langkah demi langkah (termasuk perintah terminal) untuk instalasi SDK, setup IDE, hingga pembuatan *project* Flutter awal.
* **Pemahaman Spesifikasi:** Meminta AI meluruskan cakupan Tugas 7 agar tidak salah mengira bahwa tugas ini adalah menyalin seluruh repositori website Django ke Flutter.
* **Kustomisasi Tema:** Mengunggah berkas `style.css` untuk menerjemahkan variabel warna menjadi kelas `AppColors` dan `ThemeData` berbasis *dark mode*.

### 2. Evaluasi Kritis, Keterbatasan AI, & Perbaikan Manual
Saya tidak menerima keluaran kode dari AI begitu saja. Selama proses pengerjaan, saya menemukan beberapa keterbatasan AI dan melakukan perbaikan mandiri:
* **Pengabaian Instruksi Awal:** Pada *prompt* instalasi pertama, AI sempat menyingkat alur penyiapan dan mengubah bahasa istilah tutorial. Saya mengoreksi AI agar kembali mengikuti langkah-langkah asli berkas tutorial secara presisi.
* **Asumsi Lingkungan:** AI langsung berasumsi saya menggunakan OS Windows tanpa mengonfirmasinya terlebih dahulu, serta gagal mengidentifikasi penyebab pasti *error* paket `google_fonts` (`argument_type_not_assignable`).
* **Verifikasi Mandiri:** Saya mengevaluasi seluruh kode keluaran AI dengan menguji aplikasi di peramban Chrome, memverifikasi kontras warna tampilan secara visual, serta memastikan perintah `flutter analyze` berjalan bersih tanpa *error* maupun *warning*.

### Tugas 8

1. **Jelaskan perbedaan antara Navigator.push(), Navigator.pushReplacement(), dan Navigator.pop(). Metode apa yang digunakan untuk membuka formulir dari kartu aksi? Jelaskan juga bagaimana opsi Home di drawer membawa pengguna kembali ke halaman utama**

   `Navigator.push()` menambahkan route baru di atas stack sehingga halaman sebelumnya tetap ada di bawahnya dan pengguna bisa kembali. `Navigator.pop()` menghapus route teratas dan menampilkan route di bawahnya. `Navigator.pushReplacement()` mengganti route teratas dengan route baru sehingga route lama tidak bisa dikembali-i. Formulir dari kartu aksi dibuka dengan `Navigator.push()` agar tombol back tetap berfungsi. Opsi Home di drawer memakai `pushReplacement()` ke `MyHomePage` sehingga halaman formulir digantikan oleh halaman utama baru tanpa menumpuk halaman.

2. **Bagaimana susunan Scaffold, AppBar, dan Drawer membantu menjaga struktur halaman tetap konsisten? Berikan satu contoh penggunaan warna tema portofolio di lebih dari satu halaman.**

   `Scaffold` menyediakan kerangka tetap (`appBar`, `drawer`, `body`) yang dipakai di setiap halaman, dan `LeftDrawer` adalah satu widget yang dipasang di halaman utama maupun kedua formulir sehingga navigasi selalu konsisten. Warna tema ada di `AppColors`: `bgMain` dipakai sebagai latar AppBar dan Scaffold di halaman utama dan formulir, sedangkan `accentPurple` dipakai pada titik di logo "Faiz.", ikon drawer, dan tombol simpan.

3. **Mengapa tata letak tersebut dipilih untuk formulir? Jelaskan peran widget pengatur jarak dan widget penggulir ketika ruang layar terbatas.**

   Formulir disusun dalam `Column` di dalam `SingleChildScrollView` dan dibatasi `ConstrainedBox` selebar 600 px. `Padding` dan `SizedBox` memberi jarak antar label dan input agar tidak berdempetan. `SingleChildScrollView` membuat seluruh input dan tombol Simpan tetap bisa dijangkau di layar sempit atau saat papan ketik muncul dan batas lebar menjaga tampilan tetap seperti layar ponsel di Chrome.

4. **Apa peran GlobalKey<FormState>, validator, dan validate() saat tombol Simpan ditekan? Berikan satu contoh nilai yang ditolak oleh validasi dan jelaskan mengapa memilih jenis input atau papan ketik saja belum cukup.**

   `GlobalKey<FormState>` dipasang pada `Form` sehingga tombol Simpan bisa mengakses `FormState` dari luar. `validator` pada tiap field menghasilkan pesan error (atau `null` jika valid), dan `validate()` menjalankan semua validator sekaligus, menampilkan pesan error di field yang bermasalah, dan mengembalikan `false` jika ada yang gagal sehingga dialog tidak muncul. Contoh nilai yang ditolak: End Date yang lebih awal dari Start Date, atau link `abc` pada field Reference Link. Memilih jenis input atau papan ketik saja tidak cukup karena `keyboardType` hanya mengatur tampilan papan ketik. Akibatnya, pengguna tetap bisa menempel teks apa saja atau mengetik spasi sehingga aturan seperti format URL dan urutan tanggal harus dicek oleh validator.

**AI Disclosure — Tugas 8**

Dalam pengerjaan Tugas Individu 8 dan Tutorial 09 ini, saya memanfaatkan AI (Claude) sebagai asisten belajar untuk menganalisis berkas panduan tutorial serta spesifikasi tugas. AI membimbing saya secara bertahap mulai dari penerapan navigasi antarhalaman menggunakan `Navigator`, pembuatan *drawer menu*, penyusunan elemen *form* beserta validasinya, hingga merapikan struktur proyek (*refactoring*) ke dalam direktori `screens/` dan `widgets/`.

Saya tidak menerima kode yang diberikan AI begitu saja. Meskipun AI membantu menyusun kerangka awal kode untuk halaman formulir dan navigasi, saya tetap mengevaluasi dan memodifikasinya secara mandiri—termasuk menyesuaikan *field* dan aturan validasi pada formulir baru saya, menguji alur navigasi di peramban Chrome, serta memastikan `flutter analyze` berjalan bersih tanpa *error* maupun *warning*.

### 1. Strategi Prompting & Ranah Bantuan AI
- **Pemahaman Tutorial & Impor Flutter 3.50:** Mengunggah berkas `.md` Tutorial 09 dan meminta AI memandu langkah pengerjaan, termasuk menyesuaikan transisi pustaka impor ke paket `material_ui` agar kompatibel dengan versi Flutter terbaru.
- **Navigasi & Refactoring Struktur:** Meminta panduan pemisahan komponen *widget* (`LeftDrawer`, `ItemCard`) dan halaman (`MyHomePage`, `ProjectFormPage`) ke dalam folder `lib/widgets/` dan `lib/screens/`, sekaligus memastikan *routing* `push()` dan `pushReplacement()` berjalan sesuai kebutuhan.
- **Pembuatan & Validasi Form Tugas 8:** Mengunggah spesifikasi Tugas 8 untuk mendiskusikan rancangan formulir baru (penentuan tipe *input widget*, penggunaan `GlobalKey<FormState>`, validasi input wajib/format, serta penampilan ringkasan data via `AlertDialog`).

### 2. Evaluasi Kritis, Keterbatasan AI, & Perbaikan Manual
Saya tidak menggunakan keluaran kode dari AI tanpa pengujian. Selama proses pengerjaan, saya menemukan beberapa keterbatasan AI dan melakukan perbaikan manual:
- **Penyesuaian Impor & Referensi Path:** Saat proses *refactoring* pemindahan file ke direktori `screens/` dan `widgets/`, AI sempat menyertakan jalur impor lama (`flutter/material.dart` maupun *path* relatif yang belum diperbarui) sehingga menimbulkan peringatan *deprecated* dan *error* referensi. Saya memperbaikinya secara manual menggunakan fitur *auto-refactor* di VS Code dan menyeragamkannya ke `package:material_ui/material_ui.dart`.
- **Validasi Input & Konsistensi Tema:** Kode contoh dari AI masih menggunakan warna *hardcoded* (`Colors.indigo`) yang bertabrakan dengan tema gelap portofolio saya dari Tugas 7, serta validasi yang terlalu generik. Saya menyesuaikan sendiri skema warnanya agar menyatu dengan `ThemeData` aplikasi dan memperketat logika `validator` (seperti menolak *string* yang hanya berisi spasi dan memeriksa format input).
- **Pengujian Mandiri:** Saya melakukan pengujian menyeluruh pada layar sempit (mode responsif) di Chrome untuk memastikan form dapat di-*scroll* dengan `SingleChildScrollView`, tombol simpan tetap terjangkau, serta menguji skenario input valid, input kosong, dan perpindahan *drawer*.

### Tugas 9

1. **Mengapa kita menggunakan `@JsonSerializable(fieldRename: FieldRename.snake)` dan `@JsonKey(includeToJson: false)` alih-alih mengirim objek `Map<String, dynamic>` mentah langsung dari widget? Jelaskan satu bug yang dicegah atau dapat dicegah oleh pendekatan ini pada model bagianmu.**

   Dengan `Map` mentah, setiap widget harus mengingat sendiri nama kunci JSON (`'started_at'`, `'thumbnail'`, dan seterusnya) dan field mana yang boleh dikirim. Salah ketik pada kunci tidak ditangkap compiler dan baru muncul sebagai respons `400` saat dijalankan. `@JsonSerializable` memindahkan pengetahuan itu ke satu tempat, yaitu kelas model. `fieldRename: FieldRename.snake` mengubah nama properti Dart (`startedAt`, `thumbnailUrl`, `descriptionPoints`) menjadi kunci DRF (`started_at`, `thumbnail_url`, `description_points`) secara otomatis, dan `fromJson` serta `toJson` dihasilkan `build_runner` sehingga kesalahan pemetaan muncul saat kompilasi. `@JsonKey(includeToJson: false)` menandai field yang hanya dihitung server (`id`, `category_display`, `is_ongoing`, `date_range_display`, `description_points`, `like_count`, `is_liked`, `liked_by_names`, `thumbnail_url`, `thumbnail_image`) agar tidak ikut terkirim pada `POST`.

   Satu bug yang dicegah pada model `Experience` terkait `ended_at`. Field itu opsional dan `null` berarti pengalaman masih berjalan (tampil sebagai "Present"). Jika form menyusun `Map` mentah dari `TextEditingController`, End Date yang dikosongkan menjadi string kosong `''`, dan `DateTimeField` milik DRF akan menolaknya dengan error format tanggal, padahal seharusnya field itu tidak dikirim sama sekali. Pada model, `endedAt` bertipe `String?` dan kelas memakai `includeIfNull: false` sehingga nilai `null` dihilangkan dari JSON dan server menyimpan `null`. Bug serupa dicegah oleh `includeToJson: false` pada `thumbnail_image`. Field itu adalah `ImageField` yang dapat ditulis di serializer, jadi bila objek hasil `GET` dikirim balik utuh, URL gambar yang berupa string akan ditolak karena DRF mengharapkan berkas. Tanpa `fieldRename`, kunci `thumbnail_url` juga tidak akan terbaca oleh properti `thumbnailUrl`, dan thumbnail diam-diam tidak pernah tampil.

2. **Mengapa `Future` yang diteruskan ke `FutureBuilder` harus diinisialisasi di dalam `initState()` alih-alih langsung di dalam `build()`, dan mengapa `ApiClient` sebaiknya melempar `ApiException` daripada mengembalikan `null` pada respons HTTP non-2xx?**

   `build()` dapat dipanggil berkali-kali tanpa kendali kita, misalnya saat `setState`, drawer dibuka, papan ketik muncul, ukuran layar berubah, atau parent dibangun ulang. Jika `getExperiences()` dipanggil di dalam `build()`, setiap pembangunan ulang membuat `Future` baru. `FutureBuilder` melihatnya sebagai `Future` yang berbeda, kembali ke status `waiting`, dan memicu permintaan jaringan lagi sehingga layar berkedip dan jaringan terbebani. `initState()` hanya berjalan satu kali per objek `State`, jadi `Future` dibuat sekali dan disimpan di `_experiencesFuture`. Penggantian `Future` hanya terjadi sengaja di `_reload()` lewat `setState`, yaitu saat pengguna menarik layar untuk menyegarkan atau menekan Retry.

   `ApiClient` melempar `ApiException(statusCode, message)` karena `null` membuang informasi yang dibutuhkan pemanggil. Dengan `null`, kegagalan `401`, `403`, `400`, dan `500` tidak dapat dibedakan, bahkan tidak dapat dibedakan dari "tidak ada data". `FutureBuilder` akan menganggap `Future` yang selesai dengan `null` sebagai sukses dan menampilkan layar kosong, bukan error. Dengan pengecualian, `snapshot.hasError` memunculkan pesan error dengan tombol Retry, dan form dapat bereaksi sesuai kode status: pada `401` sesi dihapus dan pengguna diminta login lagi, pada `403` ditampilkan pesan bahwa hanya pemilik yang boleh menambah entri, dan galat jaringan ditangani terpisah sebagai "Cannot reach the server". Tipe kembaliannya juga tetap non-nullable (`Future<List<Experience>>`) sehingga pemanggil tidak perlu memeriksa `null` di setiap tempat.

3. **Bandingkan `SessionAuthentication` milik Django (dari Tutorial 04/07) dengan `TokenAuthentication` milik DRF (dari Tutorial 10). Mengapa `myportfolio_mobile` menggunakan `TokenAuthentication` sementara `SessionAuthentication` tetap diaktifkan pada backend Django?**

   `SessionAuthentication` menyimpan status login di server (tabel session) dan browser membawa ID sesi lewat cookie `sessionid` secara otomatis pada setiap permintaan. Karena cookie dikirim otomatis, permintaan yang mengubah data wajib dilindungi token CSRF. Mekanisme ini cocok untuk website Django yang dibuka di browser. `TokenAuthentication` memakai tabel `authtoken`, yaitu satu token per pengguna yang didapat lewat `POST /api/v1/auth/token/` dan dikirim secara eksplisit pada header `Authorization: Token <key>`. Karena tidak ada cookie, tidak ada risiko CSRF dan klien tidak perlu mengelola cookie jar. Aplikasi Flutter bukan browser: paket `http` tidak menyimpan cookie otomatis, dan saat dijalankan di Chrome dari origin berbeda, cookie lintas origin tidak dapat dipakai bersama `CORS_ALLOW_ALL_ORIGINS = True`. Token di header menghindari semua itu. Konsekuensinya, token bersifat bearer dan tidak kedaluwarsa dengan sendirinya sehingga ada endpoint `POST /api/v1/auth/logout/` yang menghapus token di server, dan aplikasi hanya menyimpannya di memori (`AuthState`), tidak di penyimpanan permanen.

   `SessionAuthentication` tetap aktif karena website portofolio memakai login berbasis sesi dari Tutorial 04/07, dan tombol Like, Endorse, serta halaman admin bergantung padanya. Menghapusnya akan merusak website. Urutan di `REST_FRAMEWORK` juga penting: `TokenAuthentication` harus pertama karena DRF memakai `authenticate_header` dari authenticator pertama untuk memilih status permintaan tanpa kredensial. Dengan Token di depan hasilnya `401`, dan aplikasi Flutter memakai `401` itu untuk menghapus sesi lalu meminta login ulang. Jika Session di depan, hasilnya `403`. Pada proyek ini ada bug nyata terkait hal tersebut: setiap view di `api_views.py` memiliki `@authentication_classes([SessionAuthentication])` yang menimpa default di `settings.py` sehingga header `Token` ditolak. Dekorator itu saya hapus dari semua view. Selain itu, endpoint tulis dibatasi oleh permission `IsPortfolioOwnerOrReadOnly` dan `CanManageSkill` sehingga pengguna yang sudah login tetapi bukan superuser mendapat `403`, bukan `401`.

4. **Jelaskan peran job `build` (`very_good_workflows`) dan `build_apk` dalam pipeline `.github/workflows/main.yaml` milikmu (termasuk pemeriksaan apa saja yang dijalankan `very_good_workflows` di balik layar). Mengapa berkas `*.g.dart` dimasukkan ke `.gitignore` meskipun CI membutuhkannya untuk menganalisis dan membangun aplikasi?**

   Job `build` memanggil workflow `flutter_package.yml` dari `VeryGoodOpenSource/very_good_workflows` sebagai reusable workflow. Job ini berperan sebagai gerbang kualitas: ia memasang Flutter, mengambil dependensi, menjalankan perintah `setup` yang saya berikan (`dart run build_runner build --delete-conflicting-outputs`, supaya `*.g.dart` dibuat dulu), lalu memeriksa format kode dengan `dart format`, menjalankan analisis statis dengan `flutter analyze`, dan menjalankan `flutter test` beserta pengukuran coverage. Berkas `*.g.dart` dikecualikan dari coverage melalui `coverage_excludes`. Ambang `min_coverage` saya atur 0 karena saat ini baru ada satu widget test, jadi gerbang coverage belum aktif. Karena itu kode harus sudah terformat (`dart format .`) dan bersih dari isu analyzer sebelum di-push. Blok `concurrency` membatalkan run lama pada branch yang sama bila ada push baru.

   Job `build_apk` baru berjalan setelah `build` lulus (`needs: build`). Job ini mengambil kode, memasang Flutter versi stable, menjalankan `pub get` dan `build_runner`, membangun `flutter build apk --release` dengan `--dart-define=API_BASE_URL` yang menunjuk ke backend yang sudah di-deploy, lalu mengunggah `app-release-apk` sebagai artefak yang dapat diunduh dari halaman run.

   `*.g.dart` dimasukkan ke `.gitignore` karena berkas itu turunan: sumber kebenarannya adalah kelas model, dan `build_runner` dapat membuatnya ulang kapan saja. Jika di-commit, setiap perubahan model menghasilkan diff yang bising, berpotensi konflik, dan berkas hasil generate bisa tidak sinkron dengan modelnya. CI tetap bisa berjalan karena ia tidak mengambilnya dari repositori, tetapi membuatnya sendiri lewat langkah `setup` sebelum analisis, test, dan build. `*.g.dart` juga dikecualikan dari `analyzer` dan dari coverage agar kode hasil generate tidak memunculkan peringatan atau menurunkan angka coverage. Konsekuensinya, setelah `git clone` pengguna wajib menjalankan `build_runner` dulu (tercantum di bagian setup), karena tanpa itu proyek tidak dapat dikompilasi.

**AI Disclosure — Tugas 9**

Dalam pengerjaan Tutorial 10 dan Tugas Individu 9 ini, saya memanfaatkan AI (Claude) sebagai asisten belajar dan pendamping pemrograman. AI membantu menganalisis berkas tutorial serta spesifikasi tugas, menyusun langkah kerja bertahap beserta pesan commit-nya, dan membimbing saya secara bertahap mulai dari konfigurasi token authentication dan CORS di Django, pembuatan model JSON, implementasi ApiClient dan AuthState, pembangunan layar daftar dan detail untuk Skill dan Experience, refactoring form untuk pengiriman data terautentikasi, penyusunan workflow GitHub Actions, hingga penulisan kerangka README ini.

Saya tidak menerima kode yang diberikan AI begitu saja. Kode saya jalankan terhadap server Django lokal dan backend yang telah di-deploy, saya periksa dengan `dart format`, `flutter analyze`, dan `flutter test`, dan saya perbaiki sendiri ketika pipeline CI gagal.

### 1. Strategi Prompting & Ranah Bantuan AI
- **Meminta daftar berkas dan bukti status:** Meminta AI mendaftar berkas yang dibutuhkan, lalu mengirim keluaran `git status`, `git log`, dan tangkapan layar halaman web sehingga progres dan perbedaan tampilan web dengan mobile dinilai dari bukti.
- **Langkah bertahap dengan commit terpisah:** Meminta pekerjaan dipecah per perubahan dengan pesan commit konvensional, sesuai rubrik Git.
- **Pemetaan tutorial ke proyek:** Meminta AI memetakan `Project` pada tutorial ke `Skill` (Tutorial 10), lalu menerapkan pola yang sama ke `Experience` untuk Tugas 9.

### 2. Evaluasi Kritis, Keterbatasan AI, & Perbaikan Manual
Saya tidak menggunakan keluaran AI tanpa pengujian. Selama pengerjaan, saya menemukan beberapa keterbatasan AI dan melakukan perbaikan:
- **AI tidak dapat menebak skema API:** AI tidak menulis model sebelum melihat serializer saya. Setelah berkas dikirim, terlihat hal yang tidak ada di tutorial: `ended_at` bertipe `DateTimeField` padahal form memilih tanggal, `thumbnail_url` dapat berupa path relatif, dan `thumbnail_image` dapat ditulis sehingga tidak boleh ikut dikirim. Ketiganya ditangani pada model dan form `Experience`.
- **Bug yang tidak terlihat dari tutorial:** Tutorial mengasumsikan view memakai autentikasi bawaan, sedangkan `api_views.py` saya memasang `@authentication_classes([SessionAuthentication])` pada setiap view sehingga header `Token` ditolak. Bug ini baru ketahuan setelah membaca berkas asli dan saya perbaiki dengan menghapus dekorator tersebut.
- **Rencana awal AI hanya memikirkan 401:** Setelah `permissions.py` dibaca, ternyata penulisan hanya boleh dilakukan superuser sehingga pengguna biasa mendapat `403`. Penanganan `403` ditambahkan pada form.
- **CI tidak langsung hijau:** Workflow yang disarankan AI gagal pada tiga run pertama sebelum hijau di run #4. Perbaikannya mencakup pemformatan kode, widget test bawaan yang tidak cocok lagi dengan `MyApp`, dan pembaruan versi Android Gradle Plugin agar APK release dapat dibangun. AI tidak dapat melihat log Actions, jadi saya yang membaca log dan memperbaikinya.
- **Keterbatasan yang masih ada:** Tampilan Skills dan Experience di mobile lebih sederhana daripada website: belum ada pengelompokan per kategori, Like/Endorse, Edit, Delete, maupun pencarian, karena di luar checklist tugas. AI juga tidak dapat memverifikasi status pengumpulan di SCELE.
- **Pengujian mandiri:** Saya menjalankan Flutter di Chrome terhadap Django lokal untuk memeriksa daftar publik tanpa login, pengalihan ke login saat menambah entri, entri baru yang muncul di website, dan logout.