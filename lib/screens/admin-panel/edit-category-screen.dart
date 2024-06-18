// ignore_for_file: must_be_immutable, avoid_unnecessary_containers

import 'package:cached_network_image/cached_network_image.dart'; // Mengimpor CachedNetworkImage untuk memuat gambar dari URL dengan caching
import 'package:cloud_firestore/cloud_firestore.dart'; // Mengimpor Firestore untuk interaksi dengan database Firestore
import 'package:cookies_shop/controllers/edit-category-controller.dart'; // Mengimpor controller EditCategoryController
import 'package:cookies_shop/models/categories-model.dart'; // Mengimpor model CategoriesModel
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta aplikasi dari app-constant.dart
import 'package:flutter/cupertino.dart'; // Mengimpor Cupertino untuk widget-style iOS
import 'package:flutter/material.dart'; // Mengimpor widget-style Material dari Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Mengimpor Flutter EasyLoading untuk menampilkan loading indicator
import 'package:get/get.dart'; // Mengimpor package GetX untuk state management

class EditCategoryScreen extends StatefulWidget { // Stateful widget EditCategoryScreen
  CategoriesModel categoriesModel; // Model CategoriesModel yang digunakan
  EditCategoryScreen({super.key, required this.categoriesModel}); // Konstruktor EditCategoryScreen

  @override
  State<EditCategoryScreen> createState() => _EditCategoryScreenState(); // Membuat state _EditCategoryScreenState
}

class _EditCategoryScreenState extends State<EditCategoryScreen> { // State _EditCategoryScreenState
  TextEditingController categoryNameController = TextEditingController(); // Controller untuk nama kategori
  TextEditingController categoryImageController = TextEditingController(); // Controller untuk gambar kategori

  @override
  void initState() { // initState dipanggil saat widget pertama kali dibuat
    super.initState();
    categoryNameController.text = widget.categoriesModel.categoryName; // Mengatur nilai awal controller nama kategori
    categoryImageController.text = widget.categoriesModel.categoryImg; // Mengatur nilai awal controller gambar kategori
  }

  @override
  Widget build(BuildContext context) { // Method build untuk membangun UI
    return Scaffold( // Scaffold sebagai kerangka utama halaman
      appBar: AppBar( // AppBar untuk header halaman
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon dengan warna dari konstanta aplikasi
        centerTitle: true, // Posisi judul di tengah
        title: Text(widget.categoriesModel.categoryName), // Judul AppBar sesuai dengan nama kategori
      ),
      body: Container( // Container sebagai konten utama
        child: Column( // Widget Column untuk menata konten secara vertikal
          children: [
            GetBuilder( // GetBuilder dari package GetX untuk membangun UI berdasarkan state controller
              init: EditCategoryController(categoriesModel: widget.categoriesModel), // Menginisialisasi EditCategoryController dengan CategoriesModel
              builder: (editCategory) { // Builder untuk membangun UI berdasarkan state editCategory
                return editCategory.categoryImg.value != '' ? Stack( // Stack untuk menumpuk widget
                  children: [
                    CachedNetworkImage( // CachedNetworkImage untuk memuat gambar dari URL dengan caching
                      imageUrl: editCategory.categoryImg.value.toString(), // URL gambar dari state editCategory
                      fit: BoxFit.contain, // Penyesuaian gambar ke dalam kontainer
                      height: Get.height / 5.5, // Tinggi gambar sesuai 1/5.5 dari tinggi layar menggunakan GetX
                      width: Get.width / 2, // Lebar gambar sesuai setengah dari lebar layar menggunakan GetX
                      placeholder: (context, url) => const Center(child: CupertinoActivityIndicator()), // Placeholder saat memuat gambar
                      errorWidget: (context, url, error) => const Icon(Icons.error), // Widget error jika gagal memuat gambar
                    ),
                    Positioned( // Positioned untuk menempatkan widget di posisi tertentu
                      right: 10,
                      top: 0,
                      child: InkWell( // InkWell sebagai area ketika widget ditekan
                        onTap: () async { // Aksi saat widget ditekan
                          EasyLoading.show(); // Menampilkan loading indicator
                          await editCategory.deleteImageFromFireStore( // Memanggil fungsi deleteImageFromFireStore dari editCategory
                              editCategory.categoryImg.value.toString(), // URL gambar yang akan dihapus
                              widget.categoriesModel.categoryId); // ID kategori
                          EasyLoading.dismiss(); // Menutup loading indicator setelah selesai
                        },
                        child: const CircleAvatar( // CircleAvatar untuk tombol close
                          backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang dari konstanta aplikasi
                          child: Icon( // Icon close
                            Icons.close,
                            color: AppConstant.appTextColor, // Warna ikon dari konstanta aplikasi
                          ),
                        ),
                      ),
                    ),
                  ],
                ) : const SizedBox.shrink(); // Jika tidak ada gambar, kembalikan SizedBox shrink
              },
            ),
            const SizedBox(height: 20.0), // SizedBox untuk memberikan spasi vertikal
            Container( // Container untuk input nama kategori
              height: 65, // Tinggi kontainer
              margin: const EdgeInsets.symmetric(horizontal: 10.0), // Padding horizontal
              child: TextFormField( // TextFormField untuk input teks
                controller: categoryNameController, // Menggunakan controller untuk mengatur nilai input
                cursorColor: AppConstant.appScendoryColor, // Warna kursor dari konstanta aplikasi
                textInputAction: TextInputAction.next, // Aksi keyboard berikutnya
                decoration: InputDecoration( // Dekorasi input field
                  labelText: "Category Name", // Label teks input
                  hintText: "Enter category name", // Hint teks input
                  hintStyle: TextStyle(fontSize: 12.0), // Gaya teks hint
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0), // Padding konten
                  border: OutlineInputBorder( // Border input field
                    borderRadius: BorderRadius.circular(10.0), // BorderRadius dengan sudut bulat
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0), // SizedBox untuk memberikan spasi vertikal
            Container( // Container untuk input URL gambar kategori
              height: 65, // Tinggi kontainer
              margin: const EdgeInsets.symmetric(horizontal: 10.0), // Padding horizontal
              child: TextFormField( // TextFormField untuk input teks
                controller: categoryImageController, // Menggunakan controller untuk mengatur nilai input
                cursorColor: AppConstant.appScendoryColor, // Warna kursor dari konstanta aplikasi
                textInputAction: TextInputAction.done, // Aksi keyboard selesai
                decoration: InputDecoration( // Dekorasi input field
                  labelText: "Category Image", // Label teks input
                  hintText: "Enter category image URL", // Hint teks input
                  hintStyle: TextStyle(fontSize: 12.0), // Gaya teks hint
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0), // Padding konten
                  border: OutlineInputBorder( // Border input field
                    borderRadius: BorderRadius.circular(10.0), // BorderRadius dengan sudut bulat
                  ),
                ),
              ),
            ),
            ElevatedButton( // Tombol ElevatedButton untuk menyimpan perubahan
              onPressed: () async { // Aksi saat tombol ditekan
                EasyLoading.show(status: "Updating..."); // Menampilkan loading indicator dengan status updating

                CategoriesModel categoriesModel = CategoriesModel( // Membuat objek CategoriesModel baru
                  categoryId: widget.categoriesModel.categoryId, // Menggunakan ID kategori yang sama
                  categoryName: categoryNameController.text.trim(), // Mengambil nama kategori dari input controller
                  categoryImg: widget.categoriesModel.categoryImg, // Menggunakan URL gambar yang sama
                  createdAt: widget.categoriesModel.createdAt, // Menggunakan waktu pembuatan yang sama
                );

                await FirebaseFirestore.instance // Mengakses Firestore instance
                    .collection('categories') // Collection categories
                    .doc(categoriesModel.categoryId) // Dokumen dengan ID kategori yang sama
                    .update(categoriesModel.toMap()) // Melakukan update dengan data baru dari categoriesModel
                    .then((_) { // Jika berhasil
                  EasyLoading.dismiss(); // Menutup loading indicator
                  EasyLoading.showSuccess("Category Updated"); // Menampilkan pesan sukses
                }).catchError((error) { // Jika terjadi error
                  EasyLoading.dismiss(); // Menutup loading indicator
                  EasyLoading.showError("Failed to update category"); // Menampilkan pesan error
                });
              },
              style: ElevatedButton.styleFrom( // Stylized elevated button
                backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang dari konstanta aplikasi
                padding: EdgeInsets.all(20.0), // Padding tombol
              ),
              child: Text( // Teks pada tombol
                "Update",
                style: TextStyle(color: Colors.white), // Warna teks putih
              ),
            )
          ],
        ),
      ),
    );
  }
}
