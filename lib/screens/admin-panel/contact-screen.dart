// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cookies_shop/screens/admin-panel/contact-aisma-screen.dart'; // Mengimpor screen ContactAismaScreen
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta aplikasi dari app-constant.dart
import 'package:flutter/material.dart'; // Mengimpor widget-style Material dari Flutter
import 'package:get/get.dart'; // Mengimpor package GetX untuk routing

class ContactScreen extends StatefulWidget { // Stateful widget ContactScreen
  const ContactScreen({super.key}); // Konstruktor ContactScreen

  @override
  State<ContactScreen> createState() => _ContactScreenState(); // Membuat state _ContactScreenState
}

class _ContactScreenState extends State<ContactScreen> { // State _ContactScreenState
  @override
  Widget build(BuildContext context) { // Method build untuk membangun UI
    return Scaffold( // Scaffold sebagai kerangka utama halaman
      appBar: AppBar( // AppBar untuk header halaman
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon dengan warna dari konstanta aplikasi
        centerTitle: true, // Posisi judul di tengah
        title: Text( // Teks judul AppBar
          "Contact Developer",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
      ),
      body: SingleChildScrollView( // SingleChildScrollView untuk mengizinkan scroll
        physics: BouncingScrollPhysics(), // Efek bounce saat scrolling
        child: Container( // Container untuk konten utama
          child: Column( // Widget Column untuk menata konten secara vertikal
            children: [
              SizedBox( // SizedBox untuk memberikan spasi vertikal
                height: Get.height / 40, // Tinggi sesuai dengan 1/40 dari tinggi layar menggunakan GetX
              ),
              Container( // Container untuk judul
                alignment: Alignment.center, // Penyusunan teks ke tengah
                child: Column( // Widget Column dalam Container judul
                  children: [
                    Text( // Teks judul
                      "Developer Cookies Shop",
                      style: TextStyle(
                          color: AppConstant.appMainColor, // Warna teks dari konstanta aplikasi
                          fontWeight: FontWeight.bold,
                          fontSize: 25),
                    ),
                    SizedBox( // SizedBox untuk spasi vertikal
                      height: 20,
                    ),
                  ],
                ),
              ),
              Card( // Card untuk informasi pengembang
                child: ListTile( // ListTile sebagai item dalam Card
                  leading: CircleAvatar( // CircleAvatar di sebelah kiri
                    backgroundImage: AssetImage('assets/aisma.jpg'), // Gambar avatar
                  ),
                  title: Text( // Teks judul item
                    "Aisma Nurlaili",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppConstant.appScendoryColor,
                        fontSize: 18),
                  ),
                  subtitle: Text('22082010083'), // Teks subjudul dengan NPM
                  onTap: () { // Aksi ketika item ditekan
                    Get.to(() => ProfileAismaScreen()); // Navigasi ke halaman ProfileAismaScreen menggunakan GetX
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
