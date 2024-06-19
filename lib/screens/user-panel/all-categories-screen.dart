// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart'; // Paket untuk menampilkan gambar dari URL yang disimpan secara lokal.
import 'package:cloud_firestore/cloud_firestore.dart'; // Paket untuk interaksi dengan Firestore.
import 'package:cookies_shop/screens/user-panel/single-category-products-screen.dart'; // Layar untuk menampilkan produk berdasarkan kategori tertentu.
import 'package:cookies_shop/utils/app-constant.dart'; // Konstanta yang digunakan di seluruh aplikasi.
import 'package:flutter/cupertino.dart'; // Widget khusus untuk iOS.
import 'package:flutter/material.dart'; // Framework UI Flutter.
import 'package:get/get.dart'; // Library manajemen state GetX.
import 'package:image_card/image_card.dart'; // Widget untuk menampilkan gambar dengan judul.

import '../../models/categories-model.dart'; // Model data untuk kategori.

class AllCategoriesScreen extends StatefulWidget {
  const AllCategoriesScreen({super.key});

  @override
  State<AllCategoriesScreen> createState() => _AllCategoriesScreenState();
}

class _AllCategoriesScreenState extends State<AllCategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur tema ikon di app bar.
        centerTitle: true, // Mengatur judul di tengah app bar.
        title: Text(
          "All Categories", // Judul pada app bar.
          style: TextStyle(
              fontWeight: FontWeight.bold, // Mengatur tebal font judul.
              color: AppConstant.appScendoryColor, // Mengatur warna teks judul.
              fontSize: 20), // Mengatur ukuran font judul.
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('categories').get(), // Mengambil data kategori dari Firestore.
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) { // Jika terjadi error dalam mengambil data.
            return Center(
              child: Text("Error"), // Menampilkan teks "Error" di tengah layar.
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) { // Jika sedang dalam proses pengambilan data.
            return Container(
              height: Get.height / 5, // Mengatur tinggi container loading.
              child: Center(
                child: CupertinoActivityIndicator(), // Menampilkan indikator loading iOS di tengah layar.
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) { // Jika tidak ada data kategori yang ditemukan.
            return Center(
              child: Text("No category found!"), // Menampilkan teks "No category found!" di tengah layar.
            );
          }

          if (snapshot.data != null) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length, // Jumlah item dalam GridView sesuai dengan jumlah dokumen kategori.
              shrinkWrap: true, // Mengatur agar widget hanya menggunakan ruang yang dibutuhkan.
              physics: BouncingScrollPhysics(), // Efek fisika saat melakukan scroll.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah item dalam satu baris GridView.
                mainAxisSpacing: 3, // Spasi antar item secara vertikal.
                crossAxisSpacing: 3, // Spasi antar item secara horizontal.
                childAspectRatio: 1.19, // Rasio aspek untuk setiap item dalam GridView.
              ),
              itemBuilder: (context, index) {
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'], // Mendapatkan ID kategori dari Firestore.
                  categoryImg: snapshot.data!.docs[index]['categoryImg'], // Mendapatkan URL gambar kategori dari Firestore.
                  categoryName: snapshot.data!.docs[index]['categoryName'], // Mendapatkan nama kategori dari Firestore.
                  createdAt: snapshot.data!.docs[index]['createdAt'], // Mendapatkan waktu pembuatan kategori dari Firestore.
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => AllSingleCategoryProductsScreen(
                            categoryId: categoriesModel.categoryId,
                          )), // Mengarahkan ke layar produk kategori tertentu saat item di-tap.
                      child: Padding(
                        padding: EdgeInsets.all(8.0), // Padding untuk ruang di sekitar item.
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26, // Warna bayangan.
                                offset: Offset(0, 4), // Offset bayangan.
                                blurRadius: 5.0, // Radius blur bayangan.
                                spreadRadius: 1.0, // Radius penyebaran bayangan.
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0), // Mengatur border radius container.
                          ),
                          child: FillImageCard(
                            borderRadius: 20.0, // Mengatur border radius gambar.
                            width: Get.width / 2.3, // Lebar gambar.
                            heightImage: Get.height / 10, // Tinggi gambar.
                            imageProvider: CachedNetworkImageProvider(
                              categoriesModel.categoryImg, // Mengambil gambar dari URL.
                            ),
                            title: Center(
                              child: Text(
                                categoriesModel.categoryName, // Menampilkan nama kategori.
                                style: TextStyle(fontSize: 12.0), // Mengatur ukuran font judul.
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }
          return Container(); // Mengembalikan container kosong jika tidak ada data.
        },
      ),
    );
  }
}
