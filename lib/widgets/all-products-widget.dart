import 'package:cached_network_image/cached_network_image.dart';  // Package untuk mengambil gambar dari jaringan dengan cache
import 'package:cloud_firestore/cloud_firestore.dart';  // Package untuk mengakses Firestore
import 'package:cookies_shop/models/product-model.dart';  // Model data produk
import 'package:cookies_shop/screens/user-panel/product-details-screen.dart';  // Halaman detail produk
import 'package:flutter/cupertino.dart';  // Package untuk widget Cupertino (iOS style)
import 'package:flutter/material.dart';  // Package untuk komponen UI Flutter
import 'package:get/get.dart';  // Package untuk manajemen state dan navigasi dengan GetX
import 'package:image_card/image_card.dart';  // Package untuk kartu gambar kustom

class AllProductsWidget extends StatelessWidget {
  const AllProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Mengambil koleksi produk yang tidak sedang dijual dari Firestore
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: false)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          // Menampilkan pesan kesalahan jika terjadi kesalahan saat memuat data
          return Center(
            child: Text("Error"),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Menampilkan indikator loading saat masih menunggu data
          return Container(
            height: Get.height / 5,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          // Menampilkan pesan jika tidak ada produk yang ditemukan
          return Center(
            child: Text("No products found!"),
          );
        }

        if (snapshot.data != null) {
          // Memperbarui tampilan dengan GridView builder jika data tersedia
          return GridView.builder(
            itemCount: snapshot.data!.docs.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 3,
              crossAxisSpacing: 3,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, index) {
              final productData = snapshot.data!.docs[index];
              ProductModel productModel = ProductModel(
                // Mengisi model produk dari data Firestore
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
                    onTap: () => Get.to(
                        () => ProductDetailsScreen(productModel: productModel)),  // Navigasi ke halaman detail produk
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
                          // Kartu gambar kustom dengan gambar dari jaringan
                          borderRadius: 20.0,
                          width: Get.width / 2.3,
                          heightImage: Get.height / 6,
                          imageProvider: CachedNetworkImageProvider(
                            productModel.productImages[0],  // Mengambil gambar produk dari URL
                          ),
                          title: Center(
                            child: Text(
                              productModel.productName,  // Menampilkan nama produk
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ),
                          footer: Center(
                            child: Text("Rp." + productModel.fullPrice),  // Menampilkan harga produk
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

        return Container();  // Mengembalikan container kosong jika tidak ada data
      },
    );
  }
}