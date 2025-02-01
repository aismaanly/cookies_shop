// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace
// prefer_const_literals_to_create_immutables, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings

import 'package:cached_network_image/cached_network_image.dart'; // Package untuk caching gambar dari jaringan.
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore untuk interaksi dengan database.
import 'package:cookies_shop/models/product-model.dart'; // Model untuk data produk.
import 'package:cookies_shop/screens/user-panel/product-details-screen.dart'; // Layar untuk menampilkan detail produk.
import 'package:cookies_shop/utils/app-constant.dart'; // Konstanta aplikasi yang digunakan di seluruh aplikasi.
import 'package:flutter/cupertino.dart'; // Widget Cupertino untuk gaya iOS.
import 'package:flutter/material.dart'; // Framework Flutter.
import 'package:get/get.dart'; // Manajemen state dengan GetX.
import 'package:image_card/image_card.dart'; // Widget kartu gambar kustom.

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur tema ikon untuk app bar.
        centerTitle: true, // Pusatkan judul di app bar.
        title: Text(
          "All Products", // Teks judul.
          style: TextStyle(
              fontWeight: FontWeight.bold, // Ketebalan teks tebal.
              color: AppConstant.appScendoryColor, // Warna teks judul.
              fontSize: 20), // Ukuran font judul.
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('products')
            .where('isSale', isEqualTo: false)
            .get(), // Mengambil data produk yang tidak sedang dijual.
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
                child: CupertinoActivityIndicator(), // Tampilkan indikator aktivitas jika sedang memuat.
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"), // Tampilkan teks "No products found!" jika tidak ada produk.
            );
          }

          if (snapshot.data != null) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 1.00,
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
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
                );
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(() =>
                          ProductDetailsScreen(productModel: productModel)),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
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
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 2.3,
                            heightImage: Get.height / 8,
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            title: Center(
                              child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                            footer: Center(
                              child: Text("Rp." + productModel.fullPrice),
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

          return Container(); // Return container kosong jika tidak ada data.
        },
      ),
    );
  }
}