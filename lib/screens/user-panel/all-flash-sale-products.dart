// ignore_for_file: file_names, prefer_const_constructors, sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart'; // Paket untuk menampilkan gambar dari URL yang disimpan secara lokal.
import 'package:cloud_firestore/cloud_firestore.dart'; // Paket untuk interaksi dengan Firestore.
import 'package:cookies_shop/screens/user-panel/product-details-screen.dart'; // Layar untuk menampilkan detail produk.
import 'package:flutter/cupertino.dart'; // Widget khusus untuk iOS.
import 'package:flutter/material.dart'; // Framework UI Flutter.
import 'package:get/get.dart'; // Library manajemen state GetX.
import 'package:image_card/image_card.dart'; // Widget untuk menampilkan gambar dengan judul.

import '../../models/product-model.dart'; // Model data untuk produk.
import '../../utils/app-constant.dart'; // Konstanta yang digunakan di seluruh aplikasi.

class AllFlashSaleProductScreen extends StatefulWidget {
  const AllFlashSaleProductScreen({super.key});

  @override
  State<AllFlashSaleProductScreen> createState() =>
      _AllFlashSaleProductScreenState();
}

class _AllFlashSaleProductScreenState extends State<AllFlashSaleProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur tema ikon di app bar.
        centerTitle: true, // Mengatur judul di tengah app bar.
        title: Text(
          "All Flash Sale", // Judul pada app bar.
          style: TextStyle(
              fontWeight: FontWeight.bold, // Mengatur tebal font judul.
              color: AppConstant.appScendoryColor, // Mengatur warna teks judul.
              fontSize: 20), // Mengatur ukuran font judul.
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: true)
            .get(), // Mengambil data produk yang sedang dalam penawaran flash sale dari Firestore.
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

          if (snapshot.data!.docs.isEmpty) { // Jika tidak ada data produk yang ditemukan.
            return Center(
              child: Text("No products found!"), // Menampilkan teks "No products found!" di tengah layar.
            );
          }

          if (snapshot.data != null) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length, // Jumlah item dalam GridView sesuai dengan jumlah dokumen produk.
              shrinkWrap: true, // Mengatur agar widget hanya menggunakan ruang yang dibutuhkan.
              physics: BouncingScrollPhysics(), // Efek fisika saat melakukan scroll.
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Jumlah item dalam satu baris GridView.
                mainAxisSpacing: 3, // Spasi antar item secara vertikal.
                crossAxisSpacing: 3, // Spasi antar item secara horizontal.
                childAspectRatio: 1.19, // Rasio aspek untuk setiap item dalam GridView.
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                  productId: productData['productId'], // Mendapatkan ID produk dari Firestore.
                  categoryId: productData['categoryId'], // Mendapatkan ID kategori produk dari Firestore.
                  productName: productData['productName'], // Mendapatkan nama produk dari Firestore.
                  categoryName: productData['categoryName'], // Mendapatkan nama kategori produk dari Firestore.
                  salePrice: productData['salePrice'], // Mendapatkan harga jual produk dari Firestore.
                  fullPrice: productData['fullPrice'], // Mendapatkan harga normal produk dari Firestore.
                  productImages: productData['productImages'], // Mendapatkan gambar produk dari Firestore.
                  deliveryTime: productData['deliveryTime'], // Mendapatkan waktu pengiriman produk dari Firestore.
                  isSale: productData['isSale'], // Mendapatkan status penawaran flash sale produk dari Firestore.
                  productDescription: productData['productDescription'], // Mendapatkan deskripsi produk dari Firestore.
                  createdAt: productData['createdAt'], // Mendapatkan waktu pembuatan produk dari Firestore.
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductDetailsScreen(productModel: productModel)), // Mengarahkan ke layar detail produk saat item di-tap.
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
                              productModel.productImages[0], // Mengambil gambar pertama dari produk.
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName, // Menampilkan nama produk.
                                overflow: TextOverflow.ellipsis, // Mengatur overflow jika teks terlalu panjang.
                                maxLines: 1, // Batasan jumlah baris untuk nama produk.
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