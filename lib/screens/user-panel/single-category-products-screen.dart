// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers, must_be_immutable

import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage untuk memuat gambar dari URL dengan caching.
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore untuk mengakses database Firestore.
import 'package:cookies_shop/models/product-model.dart'; // Import model ProductModel untuk data produk.
import 'package:cookies_shop/screens/user-panel/product-details-screen.dart'; // Import layar ProductDetailsScreen untuk detail produk.
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi untuk styling konsisten.
import 'package:flutter/cupertino.dart'; // Import Cupertino untuk menggunakan CupertinoActivityIndicator.
import 'package:flutter/material.dart'; // Import package flutter/material.dart untuk widget Material Design.
import 'package:get/get.dart'; // Import Get untuk navigasi antar layar.
import 'package:image_card/image_card.dart'; // Import ImageCard untuk kartu gambar dengan judul.

class AllSingleCategoryProductsScreen extends StatefulWidget {
  String categoryId; // Properti untuk menyimpan ID kategori produk.

  AllSingleCategoryProductsScreen({Key? key, required this.categoryId});

  @override
  State<AllSingleCategoryProductsScreen> createState() =>
      _AllSingleCategoryProductsScreenState();
}

class _AllSingleCategoryProductsScreenState
    extends State<AllSingleCategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema warna ikon pada app bar dari konstanta aplikasi.
        centerTitle: true,
        title: Text(
          "Products", // Judul pada app bar.
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('categoryId', isEqualTo: widget.categoryId)
            .get(), // Membuat kueri Firestore untuk mendapatkan produk berdasarkan ID kategori.
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"), // Tampilkan teks "Error" jika terjadi kesalahan.
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(), // Tampilkan indikator aktivitas saat menunggu data.
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No category found!"), // Tampilkan teks "No category found!" jika tidak ada produk.
            );
          }

          if (snapshot.data != null) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length, // Jumlah item sesuai dengan jumlah dokumen hasil kueri.
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // Efek fisika saat scrolling.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah kolom dalam grid.
                mainAxisSpacing: 3, // Spasi vertikal antara item.
                crossAxisSpacing: 3, // Spasi horizontal antara item.
                childAspectRatio: 1.00, // Rasio aspek untuk item grid.
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index]; // Data produk dari dokumen Firestore.
                ProductModel productModel = ProductModel(
                  productId: productData['productId'],
                  categoryId: productData['categoryId'],
                  productName: productData['productName'],
                  categoryName: productData['categoryName'],
                  salePrice: productData['salePrice'],
                  fullPrice: productData['fullPrice'],
                  productImages: productData['productImages'],
                  deliveryTime: productData['deliveryTime'],
                  isSale: productData['isSale'],
                  productDescription: productData['productDescription'],
                  createdAt: productData['createdAt'],
                ); // Membuat objek ProductModel dari data Firestore.

                return GestureDetector(
                  onTap: () => Get.to(() =>
                      ProductDetailsScreen(productModel: productModel)), // Navigasi ke layar ProductDetailsScreen saat item di-tap.
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26, // Warna bayangan item.
                            offset: Offset(0, 4), // Posisi bayangan relatif terhadap item.
                            blurRadius: 5.0, // Besar blur pada bayangan.
                            spreadRadius: 1.0, // Penyebaran bayangan.
                          ),
                        ],
                        borderRadius: BorderRadius.circular(20.0), // Bentuk tepi item bulat.
                      ),
                      child: FillImageCard(
                        borderRadius: 20.0, // Radius sudut gambar.
                        width: Get.width / 2.3, // Lebar item sesuai dengan layar.
                        heightImage: Get.height / 8, // Tinggi gambar dalam item.
                        imageProvider: CachedNetworkImageProvider(
                          productModel.productImages[0], // Memuat gambar produk dari URL.
                        ),
                        title: Center(
                          child: Text(
                            productModel.productName, // Judul produk.
                            overflow: TextOverflow.ellipsis, // Perlakuan teks saat overflow.
                            style: TextStyle(fontSize: 12.0), // Gaya teks untuk judul.
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Container(); // Kontainer kosong jika data snapshot belum tersedia.
        },
      ),
    );
  }
}
