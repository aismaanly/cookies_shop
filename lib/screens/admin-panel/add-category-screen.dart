// ignore_for_file: file_names

import 'package:flutter/material.dart';  // Package untuk komponen UI Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import untuk menampilkan loading, error, dan sukses dengan mudah
import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk berinteraksi dengan Firestore
import 'package:cookies_shop/models/categories-model.dart'; // Import model CategoriesModel
import 'package:cookies_shop/services/generate-ids-service.dart'; // Import GenerateIds untuk menghasilkan ID kategori
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema

class AddCategoriesScreen extends StatefulWidget {
  const AddCategoriesScreen({Key? key}) : super(key: key);

  @override
  State<AddCategoriesScreen> createState() => _AddCategoriesScreenState();
}

class _AddCategoriesScreenState extends State<AddCategoriesScreen> {
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryImageController = TextEditingController();

  void _uploadCategory() async {
    // Memvalidasi input sebelum menyimpan kategori baru
    if (categoryNameController.text.isEmpty ||
        categoryImageController.text.isEmpty) {
      EasyLoading.showError("Please fill in all fields"); // Menampilkan pesan error jika ada input yang kosong
      return;
    }

    try {
      EasyLoading.show(status: "Saving..."); // Menampilkan indikator loading saat menyimpan

      String categoryId = await GenerateIds().generateCategoryId(); // Menghasilkan ID unik untuk kategori baru

      // Membuat objek CategoriesModel untuk kategori baru
      CategoriesModel categoriesModel = CategoriesModel(
        categoryId: categoryId,
        categoryName: categoryNameController.text.trim(),
        categoryImg: categoryImageController.text.trim(),
        createdAt: DateTime.now(),
      );

      // Menyimpan data kategori ke Firestore
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .set(categoriesModel.toMap());

      EasyLoading.dismiss(); // Menutup indikator loading setelah berhasil
      EasyLoading.showSuccess("Category Added"); // Menampilkan pesan sukses bahwa kategori berhasil ditambahkan

      _clearFields(); // Menghapus teks di dalam input field setelah kategori berhasil ditambahkan
    } catch (error) {
      print("Error: $error"); // Menampilkan error di console jika terjadi kesalahan
      EasyLoading.dismiss(); // Menutup indikator loading jika terjadi kesalahan
      EasyLoading.showError("Failed to add category"); // Menampilkan pesan error bahwa gagal menambahkan kategori
    }
  }

  void _clearFields() {
    categoryNameController.clear(); // Menghapus teks dari input field kategori
    categoryImageController.clear(); // Menghapus teks dari input field URL gambar kategori
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon kembali di app bar
        centerTitle: true,
        title: Text(
          "Add Categories", // Judul pada app bar
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appScendoryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appScendoryColor, // Mengatur warna kursor input
                  textInputAction: TextInputAction.next,
                  controller: categoryNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Category Name", // Label untuk input kategori
                    hintText: "Enter category name", // Hint untuk input kategori
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  cursorColor: AppConstant.appScendoryColor, // Mengatur warna kursor input
                  textInputAction: TextInputAction.next,
                  controller: categoryImageController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Category Image", // Label untuk input URL gambar kategori
                    hintText: "Enter category image URL", // Hint untuk input URL gambar kategori
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _uploadCategory, // Aksi saat tombol "Save" ditekan untuk menyimpan kategori
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appScendoryColor, // Mengatur warna latar belakang tombol
                  padding: EdgeInsets.all(20.0), // Padding pada tombol
                ),
                child: Text(
                  "Save", // Teks pada tombol
                  style: TextStyle(color: Colors.white), // Warna teks pada tombol
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
