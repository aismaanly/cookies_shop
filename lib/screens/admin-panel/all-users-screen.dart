// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:cookies_shop/models/user-model.dart'; // Mengimpor model UserModel dari user-model.dart
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta aplikasi dari app-constant.dart
import 'package:cached_network_image/cached_network_image.dart'; // Mengimpor CachedNetworkImage untuk memuat gambar dari jaringan dengan caching
import 'package:cloud_firestore/cloud_firestore.dart'; // Mengimpor Firestore untuk interaksi dengan database Firestore
import 'package:flutter/cupertino.dart'; // Mengimpor widget-style iOS (Cupertino) dari Flutter
import 'package:flutter/material.dart'; // Mengimpor widget-style Material dari Flutter

class AllUsersScreen extends StatefulWidget {
  const AllUsersScreen({super.key}); // Konstruktor untuk AllUsersScreen

  @override
  State<AllUsersScreen> createState() => _AllUsersScreenState(); // Membuat state AllUsersScreen
}

class _AllUsersScreenState extends State<AllUsersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold adalah kerangka utama halaman
      appBar: AppBar( // AppBar di bagian atas halaman
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon dengan warna dari konstanta aplikasi
        centerTitle: true, // Posisi judul di tengah AppBar
        title: Text( // Teks judul AppBar
          "All Users", // Judul halaman
          style: TextStyle( // Style teks judul
              fontWeight: FontWeight.bold, // Ketebalan teks tebal
              color: AppConstant.appScendoryColor, // Warna teks dari konstanta aplikasi
              fontSize: 20), // Ukuran teks 20
        ),
      ),
      body: FutureBuilder( // Widget FutureBuilder untuk membangun UI berdasarkan Future
        future: FirebaseFirestore.instance // Future untuk mengambil data dari Firestore
            .collection('users') // Mengambil koleksi 'users' dari Firestore
            .orderBy('createdOn', descending: true) // Mengurutkan berdasarkan 'createdOn' secara menurun
            .get(), // Mendapatkan data dari Firestore
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) { // Builder untuk menangani AsyncSnapshot dari Future
          if (snapshot.hasError) { // Jika terjadi error saat mengambil snapshot
            return Container( // Widget Container untuk tampilan error
              child: Center( // Widget Center untuk menengahkan teks
                child: Text('Error occurred while fetching category!'), // Teks untuk error fetching data
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) { // Jika koneksi sedang menunggu (loading)
            return Container( // Widget Container untuk tampilan loading
              child: Center( // Widget Center untuk menengahkan widget child
                child: CupertinoActivityIndicator(), // Indikator loading gaya Cupertino
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) { // Jika tidak ada dokumen (data) dalam snapshot
            return Container( // Widget Container untuk menampilkan pesan bahwa tidak ada pengguna ditemukan
              child: Center( // Widget Center untuk menengahkan widget child
                child: Text('No users found!'), // Teks yang menunjukkan tidak ada pengguna ditemukan
              ),
            );
          }

          if (snapshot.data != null) { // Jika data snapshot tidak null
            return ListView.builder( // ListView untuk menampilkan daftar pengguna
              shrinkWrap: true, // Memungkinkan ListView untuk "mengikat" tinggi ke dalam konten yang tersedia
              physics: BouncingScrollPhysics(), // Efek "bounce" saat scroll diaktifkan
              itemCount: snapshot.data!.docs.length, // Jumlah item sama dengan jumlah dokumen dalam snapshot
              itemBuilder: (context, index) { // ItemBuilder untuk membangun setiap item dalam ListView
                final data = snapshot.data!.docs[index]; // Data pengguna dari dokumen pada indeks tertentu

                UserModel userModel = UserModel( // Menginisialisasi UserModel dari data pengguna
                  uId: data['uId'], // ID pengguna
                  username: data['username'], // Nama pengguna
                  email: data['email'], // Email pengguna
                  phone: data['phone'], // Nomor telepon pengguna
                  userImg: data['userImg'], // URL gambar pengguna
                  country: data['country'], // Negara pengguna
                  userAddress: data['userAddress'], // Alamat pengguna
                  street: data['street'], // Nama jalan pengguna
                  isAdmin: data['isAdmin'], // Status admin pengguna
                  isActive: data['isActive'], // Status aktif pengguna
                  createdOn: data['createdOn'], // Waktu pembuatan akun pengguna
                  city: data['city'], // Kota pengguna
                );

                return Card( // Widget Card untuk menampilkan data pengguna dalam bentuk kartu
                  elevation: 5, // Efek bayangan untuk meningkatkan kedalaman kartu
                  child: ListTile( // Widget ListTile untuk menampilkan data pengguna secara terstruktur
                    leading: Stack( // Widget Stack untuk menggabungkan beberapa widget secara bersamaan
                      alignment: Alignment.center, // Penyusunan widget di tengah Stack
                      children: [
                        CircleAvatar( // Widget CircleAvatar untuk menampilkan gambar profil pengguna
                          backgroundColor: AppConstant.appMainColor, // Warna latar belakang Avatar dari konstanta aplikasi
                          backgroundImage: userModel.userImg.isNotEmpty // Memeriksa jika URL gambar tidak kosong
                              ? CachedNetworkImageProvider(userModel.userImg) // Menggunakan CachedNetworkImage untuk memuat gambar dari jaringan dengan caching
                              : null, // Jika tidak ada URL gambar, kosongkan Avatar
                          child: userModel.userImg.isEmpty // Jika URL gambar kosong
                              ? Text( // Menampilkan teks dalam Avatar jika gambar tidak tersedia
                                  userModel.username[0], // Mengambil huruf pertama dari nama pengguna
                                  style: TextStyle( // Style untuk teks dalam Avatar
                                    color: AppConstant.appTextColor, // Warna teks dari konstanta aplikasi
                                  ),
                                )
                              : null, // Kosongkan child jika ada URL gambar
                        ),
                      ],
                    ),
                    title: Text(userModel.username), // Teks judul dari nama pengguna
                    subtitle: Text(userModel.email), // Teks subjudul dari email pengguna
                  ),
                );
              },
            );
          }

          return Container(); // Mengembalikan widget Container kosong jika tidak ada data
        },
      ),
    );
  }
}
