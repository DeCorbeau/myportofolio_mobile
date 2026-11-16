Nama : Faiz Yusuf Elriki

NPM : 2506607921

Kelas : PBP A

## Tentang Proyek

Repositori aplikasi mobile Flutter yang menjadi pendamping dari website portofolio pribadi saya ([myportofolio](https://github.com/DeCorbeau/myportofolio), dibangun dengan Django). Aplikasi ini dibangun bertahap untuk memenuhi tugas individu mata kuliah Pemrograman Berbasis Platform (PBP) pada paruh kedua semester ini.

Pada tahap Tugas 7, halaman utama aplikasi berisi tiga bagian:
- **Kartu identitas (`InfoCard`)**: tiga kartu yang menampilkan NPM, nama lengkap, dan kelas saya.
- **Menu aksi portofolio (`ItemCard`)**: tiga tombol berbentuk kartu, yaitu View Skills, Add Skill, dan Logout. Setiap tombol memiliki warna latar berbeda yang diambil dari model `ItemHomepage`, dan memunculkan `SnackBar` saat ditekan.
- **Tema visual**: tema gelap dengan aksen ungu, logo "Faiz.", dan font Space Grotesk yang mengikuti tampilan website portofolio saya.

## Cara Menjalankan Proyek Secara Lokal

Prasyarat: Flutter SDK, Android Studio (untuk Android SDK), dan VS Code dengan ekstensi Flutter sudah terpasang. Pastikan `flutter doctor` tidak menunjukkan masalah pada Flutter, Android toolchain, dan Chrome.

1. Clone repository ini, lalu masuk ke foldernya.
2. Ambil dependensi:
   ```
   flutter pub get
   ```
3. Jalankan aplikasi di Chrome:
   ```
   flutter run -d chrome
   ```
   Untuk emulator Android atau perangkat fisik, gunakan `flutter run`.
4. Periksa kualitas kode:
   ```
   flutter analyze
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
- **Penyesuaian Impor & Referensi Path:** Saat proses *refactoring* pemindahan file ke direktori `screens/` dan `widgets/`, AI sempat menyertakan jalur impor lama (`flutter/material.dart` maupun *path* relatif yang belum diperbarui), sehingga menimbulkan peringatan *deprecated* dan *error* referensi. Saya memperbaikinya secara manual menggunakan fitur *auto-refactor* di VS Code dan menyeragamkannya ke `package:material_ui/material_ui.dart`.
- **Validasi Input & Konsistensi Tema:** Kode contoh dari AI masih menggunakan warna *hardcoded* (`Colors.indigo`) yang bertabrakan dengan tema gelap portofolio saya dari Tugas 7, serta validasi yang terlalu generik. Saya menyesuaikan sendiri skema warnanya agar menyatu dengan `ThemeData` aplikasi dan memperketat logika `validator` (seperti menolak *string* yang hanya berisi spasi dan memeriksa format input).
- **Pengujian Mandiri:** Saya melakukan pengujian menyeluruh pada layar sempit (mode responsif) di Chrome untuk memastikan form dapat di-*scroll* dengan `SingleChildScrollView`, tombol simpan tetap terjangkau, serta menguji skenario input valid, input kosong, dan perpindahan *drawer*.