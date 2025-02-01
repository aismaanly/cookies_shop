import 'package:cached_network_image/cached_network_image.dart';  // Package untuk mengambil gambar dari jaringan dengan cache
import 'package:cloud_firestore/cloud_firestore.dart';  // Package untuk mengakses Firestore
import 'package:cookies_shop/models/categories-model.dart';  // Model untuk data kategori
import 'package:cookies_shop/screens/user-panel/single-category-products-screen.dart';  // Layar untuk menampilkan produk dari kategori tertentu
import 'package:flutter/cupertino.dart';  // Package untuk widget Cupertino (iOS style)
import 'package:flutter/material.dart';  // Package untuk komponen UI Flutter
import 'package:get/get.dart';  // Package untuk manajemen state dan navigasi dengan GetX
import 'package:image_card/image_card.dart';  // Widget khusus untuk menampilkan gambar dengan judul

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('categories').get(),  // Mengambil data kategori dari Firestore
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),  // Tampilkan pesan jika terjadi error
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,  // Widget loading saat menunggu data
            child: Center(
              child: CupertinoActivityIndicator(),  // Indikator aktivitas saat loading
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No category found!"),  // Tampilkan pesan jika tidak ada kategori
          );
        }

        if (snapshot.data != null) {
          return Container(
            height: Get.height / 6.0,  // Tinggi kontainer untuk daftar kategori
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,  // Tampilkan kategori secara horizontal
              itemBuilder: (context, index) {
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: snapshot.data!.docs[index]['categoryId'],  // Ambil id kategori dari Firestore
                  categoryImg: snapshot.data!.docs[index]['categoryImg'],  // Ambil URL gambar kategori dari Firestore
                  categoryName: snapshot.data!.docs[index]['categoryName'],  // Ambil nama kategori dari Firestore
                  createdAt: snapshot.data!.docs[index]['createdAt'],  // Ambil waktu pembuatan kategori dari Firestore
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() => AllSingleCategoryProductsScreen(
                          categoryId: categoriesModel.categoryId)),  // Navigasi ke layar produk kategori tertentu saat diklik
                      child: Padding(
                        padding: EdgeInsets.all(5.0),  // Padding untuk jarak antara item kategori
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 5.0,
                                spreadRadius: 1.0,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20.0),  // Bentuk border untuk kontainer kategori
                          ),
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 5.0,  // Lebar gambar kategori
                            heightImage: Get.height / 12,  // Tinggi gambar kategori
                            imageProvider: CachedNetworkImageProvider(
                              categoriesModel.categoryImg,  // Menampilkan gambar kategori dari URL
                            ),
                            title: FractionallySizedBox(
                              widthFactor: 1.0,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  categoriesModel.categoryName,  // Tampilkan nama kategori
                                  style: TextStyle(
                                    fontSize: 10.0,  // Ukuran font untuk nama kategori
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }

        return Container();
      },
    );
  }
}
