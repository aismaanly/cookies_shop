// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart'; // Import untuk menggunakan CachedNetworkImage
import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk berinteraksi dengan Firestore
import 'package:cookies_shop/controllers/edit-category-controller.dart'; // Import controller untuk mengedit kategori
import 'package:cookies_shop/models/categories-model.dart'; // Import model CategoriesModel untuk data kategori
import 'package:cookies_shop/screens/admin-panel/add-category-screen.dart'; // Import layar tambah kategori
import 'package:cookies_shop/screens/admin-panel/edit-category-screen.dart'; // Import layar edit kategori
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema
import 'package:flutter/cupertino.dart'; // Import widget dari Cupertino untuk UI
import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import untuk menampilkan loading, error, dan sukses dengan mudah
import 'package:flutter_swipe_action_cell/core/cell.dart'; // Import untuk mengimplementasikan swipe action di ListTile
import 'package:get/get.dart'; // Import package GetX untuk manajemen state

class AdminAllCategoriesScreen extends StatelessWidget {
  const AdminAllCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar
        centerTitle: true,
        title: Text(
          "All Categories", // Judul halaman
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
        actions: [
          InkWell(
            onTap: () => Get.to(() => const AddCategoriesScreen()), // Navigasi ke layar tambah kategori
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.add), // Icon tambah di app bar
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .snapshots(), // Stream untuk mendapatkan snapshot dari koleksi 'categories' di Firestore
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: const Center(
                child: Text('Error occurred while fetching category!'), // Pesan error jika terjadi kesalahan
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: const Center(
                child: CupertinoActivityIndicator(), // Indicator loading saat data sedang diambil
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: const Center(
                child: Text('No category found!'), // Pesan jika tidak ada kategori yang ditemukan
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(), // Efek bounce saat scrolling
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                // Mengisi model dengan data dari Firestore
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: data['categoryId'],
                  categoryName: data['categoryName'],
                  categoryImg: data['categoryImg'],
                  createdAt: data['createdAt'],
                );

                return SwipeActionCell(
                  key: ObjectKey(categoriesModel.categoryId),
                  trailingActions: <SwipeAction>[
                    SwipeAction(
                        title: "Delete", // Judul untuk aksi hapus
                        onTap: (CompletionHandler handler) async {
                          // Dialog konfirmasi sebelum menghapus
                          await Get.defaultDialog(
                            title: "Delete Product",
                            content: const Text(
                                "Are you sure you want to delete this category?"),
                            textCancel: "Cancel",
                            textConfirm: "Delete",
                            contentPadding: const EdgeInsets.all(10.0),
                            confirmTextColor: Colors.white,
                            onCancel: () {},
                            onConfirm: () async {
                              Get.back(); // Menutup dialog konfirmasi
                              EasyLoading.show(status: 'Please wait..'); // Menampilkan loading indicator
                              EditCategoryController editCategoryController =
                                  Get.put(EditCategoryController(
                                      categoriesModel: categoriesModel));

                              // Memanggil method untuk menghapus kategori dari Firestore
                              await editCategoryController
                                  .deleteWholeCategoryFromFireStore(
                                      categoriesModel.categoryId);
                              EasyLoading.dismiss(); // Menutup loading indicator setelah selesai
                            },
                            buttonColor: Colors.red, // Warna tombol hapus
                            cancelTextColor: Colors.black, // Warna teks tombol batal
                          );
                        },
                        color: Colors.red), // Warna latar belakang aksi hapus
                  ],
                  child: Card(
                    elevation: 5,
                    child: ListTile(
                      onTap: () {},
                      leading: CircleAvatar(
                        backgroundColor: AppConstant.appScendoryColor, // Warna background avatar
                        backgroundImage: CachedNetworkImageProvider(
                          categoriesModel.categoryImg.toString(), // URL gambar dari Firestore
                          errorListener: (err) {
                            print('Error loading image'); // Log jika gagal memuat gambar
                            const Icon(Icons.error); // Icon error jika gambar gagal dimuat
                          },
                        ),
                      ),
                      title: Text(categoriesModel.categoryName), // Nama kategori
                      subtitle: Text(categoriesModel.categoryId), // ID kategori
                      trailing: GestureDetector(
                          onTap: () => Get.to(() => EditCategoryScreen( // Navigasi ke layar edit kategori
                                    categoriesModel: categoriesModel),
                              ),
                          child: const Icon(Icons.edit)), // Icon edit
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
