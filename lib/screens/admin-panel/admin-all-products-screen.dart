// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, avoid_print

import 'package:cookies_shop/controllers/category-dropdown_controller.dart'; // Import controller untuk dropdown kategori
import 'package:cookies_shop/controllers/is-sale-controller.dart'; // Import controller untuk status sale
import 'package:cookies_shop/models/product-model.dart'; // Import model produk
import 'package:cookies_shop/screens/admin-panel/add-products-screen.dart'; // Import layar tambah produk
import 'package:cookies_shop/screens/admin-panel/admin-product-detail-screen.dart'; // Import layar detail produk admin
import 'package:cookies_shop/screens/admin-panel/edit-product-screen.dart'; // Import layar edit produk
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage untuk mengambil gambar dari URL
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore untuk interaksi dengan database Firestore
import 'package:flutter/cupertino.dart'; // Import widget dari Cupertino untuk UI
import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import Flutter EasyLoading untuk indikator loading
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart'; // Import widget untuk swipe action cell
import 'package:get/get.dart'; // Import package GetX untuk manajemen state

class AdminAllProductsScreen extends StatefulWidget {
  const AdminAllProductsScreen({super.key});

  @override
  State<AdminAllProductsScreen> createState() => _AdminAllProductsScreenState();
}

class _AdminAllProductsScreenState extends State<AdminAllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar
        centerTitle: true,
        title: Text(
          "All Products", // Judul halaman
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => AddProductScreen()), // Navigasi ke layar tambah produk
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.add), // Icon tambah di app bar
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('createdAt', descending: true)
            .snapshots(), // Stream untuk mendapatkan produk dari Firestore, diurutkan berdasarkan tanggal pembuatan secara menurun
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching products!'), // Pesan error jika terjadi kesalahan
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(), // Indicator loading saat data sedang diambil
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text('No products found!'), // Pesan jika tidak ada produk yang ditemukan
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // Efek bounce saat scrolling
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                ProductModel productModel = ProductModel(
                  productId: data['productId'],
                  categoryId: data['categoryId'],
                  productName: data['productName'],
                  categoryName: data['categoryName'],
                  salePrice: data['salePrice'],
                  fullPrice: data['fullPrice'],
                  productImages: List<String>.from(data['productImages']),
                  deliveryTime: data['deliveryTime'],
                  isSale: data['isSale'],
                  productDescription: data['productDescription'],
                  createdAt: data['createdAt']?.toDate(),
                ); // Mendefinisikan objek ProductModel dari data produk

                return SwipeActionCell(
                  key: ObjectKey(productModel.productId), // Key untuk SwipeActionCell

                  trailingActions: <SwipeAction>[
                    SwipeAction(
                        title: "Delete",
                        onTap: (CompletionHandler handler) async {
                          await Get.defaultDialog(
                            title: "Delete Product",
                            content: Text(
                                "Are you sure you want to delete this product?"), // Konfirmasi dialog untuk menghapus produk
                            textCancel: "Cancel",
                            textConfirm: "Delete",
                            contentPadding: EdgeInsets.all(10.0),
                            confirmTextColor: Colors.white,
                            onCancel: () {},
                            onConfirm: () async {
                              Get.back();
                              EasyLoading.show(status: 'Please wait..'); // Menampilkan loading saat proses penghapusan

                              await FirebaseFirestore.instance
                                  .collection('products')
                                  .doc(productModel.productId)
                                  .delete(); // Menghapus produk dari Firestore

                              EasyLoading.dismiss(); // Menutup loading setelah selesai
                            },
                            buttonColor: Colors.red,
                            cancelTextColor: Colors.black,
                          );
                        },
                        color: Colors.red),
                  ],
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () {
                        Get.to(() => AdminSingleProductDetailScreen(
                            productModel: productModel)); // Navigasi ke layar detail produk
                      },
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appScendoryColor,
                        backgroundImage: CachedNetworkImageProvider(
                          productModel.productImages[0],
                          errorListener: (err) {
                            print('Error loading image'); // Handle error jika gambar tidak bisa dimuat
                            Icon(Icons.error); // Icon error untuk tampilan placeholder
                          },
                        ),
                      ),
                      title: Text(productModel.productName), // Nama produk sebagai judul ListTile
                      subtitle: Text(productModel.productId), // ID produk sebagai subtitle ListTile
                      trailing: GestureDetector(
                          onTap: () {
                            final editProdouctCategory =
                                Get.put(CategoryDropDownController()); // Menggunakan GetX untuk state management
                            final isSaleController =
                                Get.put(IsSaleController());

                            editProdouctCategory
                                .setOldValue(productModel.categoryId); // Set nilai awal dropdown kategori

                            isSaleController
                                .setIsSaleOldValue(productModel.isSale); // Set nilai awal status sale
                            Get.to(() =>
                                EditProductScreen(productModel: productModel)); // Navigasi ke layar edit produk
                          },
                          child: Icon(Icons.edit)), // Icon edit untuk mengedit produk
                    ),
                  ),
                );
              },
            );
          }

          return Container(); // Kontainer kosong jika snapshot null
        },
      ),
    );
  }
}
