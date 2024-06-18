// ignore_for_file: prefer_const_constructors

import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta aplikasi dari app-constant.dart
import 'package:flutter/material.dart'; // Mengimpor widget-style Material dari Flutter
import 'package:url_launcher/url_launcher.dart'; // Mengimpor package url_launcher untuk membuka URL

class ProfileAismaScreen extends StatefulWidget {
  const ProfileAismaScreen({super.key}); // Konstruktor ProfileAismaScreen

  @override
  State<ProfileAismaScreen> createState() => _ProfileAismaScreenState();
}

class _ProfileAismaScreenState extends State<ProfileAismaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold sebagai kerangka utama halaman
      appBar: AppHeader( // AppBar menggunakan custom widget AppHeader
        avatar: 'assets/aisma.jpg', // Path avatar
        header: 'assets/header.jpg', // Path header background
        content: [ // List widget konten AppBar
          Text( // Teks nama
            'Aisma Nurlaili',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text( // Teks jurusan
            'Sistem Informasi',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text( // Teks NPM
            'NPM : 22082010083',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
      body: Container( // Container untuk konten utama
        padding: const EdgeInsets.all(15), // Padding 15 pada semua sisi Container
        child: ListView( // ListView untuk menggulirkan konten
          padding: EdgeInsets.all(5), // Padding 5 pada semua sisi ListView
          children: [
            _buildProfileBox( // Memanggil method _buildProfileBox untuk membangun kotak profil
              name: 'Aisma Nurlaili',
              birthPlace: 'Surabaya',
              birthDate: '24 Oktober 2003',
              address: 'Jl.Jojoran 1 Blok AC no.8',
              phoneNumber: '081253004900',
              email: '22082010083@student.upnjatim.ac.id',
              github: 'https://github.com/aismaanly',
              education: 'IPA/SMAN 4 Surabaya\nSistem Informasi UPN Veteran Jawa Timur',
              award: '',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBox({ // Method untuk membangun kotak profil dengan parameter yang diberikan
    required String name,
    required String birthPlace,
    required String birthDate,
    required String address,
    required String phoneNumber,
    required String email,
    required String github,
    required String education,
    required String award,
  }) {
    return Container( // Container untuk kotak profil
      padding: const EdgeInsets.all(15), // Padding 15 pada semua sisi Container
      width: MediaQuery.of(context).size.width, // Lebar Container sesuai dengan lebar layar perangkat
      decoration: BoxDecoration( // Mendekorasikan Container dengan border radius dan warna latar belakang
        borderRadius: BorderRadius.circular(15), // BorderRadius 15 untuk sudut kotak
        color: AppConstant.appCardColor, // Warna latar belakang dari konstanta aplikasi
      ),
      child: Column( // Widget Column untuk menata widget secara vertikal
        crossAxisAlignment: CrossAxisAlignment.start, // Penyusunan widget start (mulai) dari kiri
        children: [
          ListTile( // ListTile untuk menampilkan info nama
            leading: Icon(Icons.person), // Icon di sebelah kiri
            title: Text('Nama'), // Teks judul
            subtitle: Text(name), // Teks subjudul
          ),
          ListTile( // ListTile untuk menampilkan info tempat dan tanggal lahir
            leading: Icon(Icons.calendar_today), // Icon di sebelah kiri
            title: Text('Tempat tanggal lahir '), // Teks judul
            subtitle: Text('$birthPlace, $birthDate'), // Teks subjudul gabungan tempat dan tanggal lahir
          ),
          ListTile( // ListTile untuk menampilkan info alamat
            leading: Icon(Icons.home), // Icon di sebelah kiri
            title: Text('Alamat'), // Teks judul
            subtitle: Text(address), // Teks subjudul
          ),
          ListTile( // ListTile untuk menampilkan info nomor HP
            leading: Icon(Icons.phone), // Icon di sebelah kiri
            title: Text('No.HP'), // Teks judul
            subtitle: Text(phoneNumber), // Teks subjudul
          ),
          ListTile( // ListTile untuk menampilkan info email
            leading: Icon(Icons.email), // Icon di sebelah kiri
            title: Text('Email'), // Teks judul
            subtitle: InkWell( // InkWell untuk membuat teks subjudul dapat ditekan
              onTap: () async { // Aksi ketika teks ditekan
                final url = 'mailto:$email'; // URL untuk membuka email
                if (await canLaunch(url)) { // Memeriksa apakah URL bisa dibuka
                  await launch(url); // Membuka URL
                } else {
                  throw 'Could not launch $url'; // Pesan jika gagal membuka URL
                }
              },
              child: Text( // Teks subjudul
                email,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ),
          ListTile( // ListTile untuk menampilkan info GitHub
            leading: Icon(Icons.link), // Icon di sebelah kiri
            title: Text('Github'), // Teks judul
            subtitle: InkWell( // InkWell untuk membuat teks subjudul dapat ditekan
              onTap: () async { // Aksi ketika teks ditekan
                final url = github; // URL GitHub
                if (await canLaunch(url)) { // Memeriksa apakah URL bisa dibuka
                  await launch(url); // Membuka URL
                } else {
                  throw 'Could not launch $url'; // Pesan jika gagal membuka URL
                }
              },
              child: Text( // Teks subjudul
                github,
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ),
          ListTile( // ListTile untuk menampilkan info riwayat pendidikan
            leading: Icon(Icons.school), // Icon di sebelah kiri
            title: Text('Riwayat Pendidikan'), // Teks judul
            subtitle: Text(education), // Teks subjudul
          ),
          ListTile( // ListTile untuk menampilkan info penghargaan
            leading: Icon(Icons.emoji_events), // Icon di sebelah kiri
            title: Text('Penghargaan'), // Teks judul
            subtitle: Text(award), // Teks subjudul
          ),
        ],
      ),
    );
  }
}

AppBar AppHeader({ // Widget custom AppBar AppHeader
  required String avatar, // Avatar
  required String header, // Header
  required List<Widget> content, // Konten AppBar berupa list widget
}) {
  return AppBar( // AppBar dengan toolbar khusus
    toolbarHeight: 240, // Tinggi toolbar
    flexibleSpace: Stack( // Widget Stack untuk menumpuk elemen-elemen di dalam AppBar
      children: [
        Container( // Container untuk background header
          decoration: BoxDecoration( // Mendekorasi Container dengan gambar latar belakang
            image: DecorationImage(
              image: AssetImage(header), // Gambar latar belakang header
              fit: BoxFit.cover, // Penyesuaian gambar agar sesuai
            ),
          ),
        ),
        Container( // Container untuk gradient overlay
          decoration: BoxDecoration( // Mendekorasi Container dengan gradient
            gradient: LinearGradient( // LinearGradient untuk gradient dari atas ke bawah
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
        Container( // Container untuk layout konten di dalam AppBar
          padding: const EdgeInsets.only(left: 60, right: 20), // Padding kiri dan kanan
          child: content.length == 1 // Memeriksa jumlah konten
              ? Column( // Jika konten hanya satu
                  mainAxisAlignment: MainAxisAlignment.center, // Penyusunan konten ke tengah
                  children: [
                    CircleAvatar( // CircleAvatar untuk avatar
                      radius: 62,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: Image.asset(
                            width: 105,
                            avatar,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    SizedBox( // SizedBox untuk spasi
                      height: 40,
                    ),
                  ],
                )
              : Row( // Jika konten lebih dari satu
                  mainAxisAlignment: MainAxisAlignment.start, // Penyusunan konten ke kiri
                  crossAxisAlignment: CrossAxisAlignment.center, // Penyusunan konten secara vertikal di tengah
                  children: [
                    CircleAvatar( // CircleAvatar untuk avatar
                      radius: 62,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        backgroundImage: AssetImage(avatar),
                      ),
                    ),
                    SizedBox( // SizedBox untuk spasi
                      width: 20,
                    ),
                    Column( // Column untuk menata konten
                      mainAxisAlignment: MainAxisAlignment.center, // Penyusunan konten ke tengah
                      crossAxisAlignment: CrossAxisAlignment.start, // Penyusunan konten start (mulai) dari kiri
                      children: content, // Menampilkan konten yang diberikan
                    ),
                  ],
                ),
        ),
      ],
    ),
  );
}
