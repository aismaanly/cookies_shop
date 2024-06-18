// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, unnecessary_string_interpolations

// Mengimpor paket-paket yang dibutuhkan
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookies_shop/models/product-model.dart';
import 'package:cookies_shop/screens/user-panel/product-details-screen.dart';
import 'package:cookies_shop/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

// Definisi widget Stateless yang menampilkan produk flash sale
class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Mengambil data produk dari koleksi 'products' di Firestore yang memiliki field 'isSale' dengan nilai true
      future: FirebaseFirestore.instance
          .collection('products')
          .where('isSale', isEqualTo: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Menampilkan pesan error jika ada kesalahan saat mengambil data
        if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }
        // Menampilkan indikator proses jika masih dalam proses pengambilan data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: Get.height / 5,
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        // Menampilkan pesan jika tidak ada produk yang ditemukan
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("No products found!"),
          );
        }

        // Menampilkan daftar produk jika data berhasil diambil
        if (snapshot.data != null) {
          return Container(
            height: Get.height / 5,
            child: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Mengambil data produk dari snapshot
                final productData = snapshot.data!.docs[index];
                // Membuat model produk dari data yang diambil
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
                      // Menavigasi ke layar detail produk saat gambar produk ditekan
                      onTap: () => Get.to(() => ProductDetailsScreen(productModel: productModel)),
                      child: Padding(
                        padding: EdgeInsets.all(5.0),
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
                            width: Get.width / 3.5,
                            heightImage: Get.height / 12,
                            // Menampilkan gambar produk
                            imageProvider: CachedNetworkImageProvider(
                              productModel.productImages[0],
                            ),
                            // Menampilkan nama produk di tengah gambar
                            title: Center(
                              child: Text(
                                productModel.productName,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 10.0),
                              ),
                            ),
                            // Menampilkan harga produk (harga diskon dan harga asli yang dicoret)
                            footer: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Rp.${productModel.salePrice}",
                                  style: TextStyle(fontSize: 10.0),
                                ),
                                SizedBox(
                                  width: 2.0,
                                ),
                                Text(
                                  "${productModel.fullPrice}",
                                  style: TextStyle(
                                    fontSize: 10.0,
                                    color: AppConstant.appScendoryColor,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
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

        // Mengembalikan container kosong jika tidak ada data
        return Container();
      },
    );
  }
}
