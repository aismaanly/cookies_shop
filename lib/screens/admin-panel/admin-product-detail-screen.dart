// ignore_for_file: prefer_const_constructors, file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:cookies_shop/models/product-model.dart'; // Import model ProductModel
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema
import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:get/get.dart'; // Import package GetX untuk manajemen state

class AdminSingleProductDetailScreen extends StatelessWidget {
  ProductModel productModel; // Model data produk
  AdminSingleProductDetailScreen({
    super.key,
    required this.productModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar
        centerTitle: true,
        title: Text(
          productModel.productName, // Judul halaman sesuai nama produk
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appScendoryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Card(
              elevation: 10, // Elevation (ketebalan bayangan) untuk card
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Name"), // Label nama produk
                        Container(
                          width: Get.width / 2, // Lebar kontainer sesuai setengah lebar layar
                          child: Text(
                            productModel.productName, // Nama produk
                            overflow: TextOverflow.ellipsis, // Mengatur overflow jika teks terlalu panjang
                            maxLines: 3, // Maksimum baris teks yang ditampilkan
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Product Price"), // Label harga produk
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.salePrice != ''
                                ? productModel.salePrice // Jika ada harga jual, tampilkan harga jual
                                : productModel.fullPrice, // Jika tidak, tampilkan harga penuh
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Delivery Time"), // Label waktu pengiriman
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.deliveryTime, // Waktu pengiriman produk
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Is Sale?"), // Label penanda diskon
                        Container(
                          width: Get.width / 2,
                          child: Text(
                            productModel.isSale ? "True" : "false", // Menampilkan status diskon (true/false)
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
