// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';  // Package untuk komponen UI Flutter
import 'package:get/get.dart';  // Package untuk manajemen state dan navigasi dengan GetX

import '../controllers/category-dropdown_controller.dart';  // Mengimpor controller untuk DropDown kategori

class DropDownCategoriesWidget extends StatelessWidget {
  const DropDownCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan GetBuilder untuk manajemen state dengan GetX
    return GetBuilder<CategoryDropDownController>(
      init: CategoryDropDownController(),  // Inisialisasi controller
      builder: (categoriesDropDownController) {
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.0),  // Margin horizontal
              child: Card(
                elevation: 10,  // Memberikan efek bayangan pada card
                child: Padding(
                  padding: const EdgeInsets.all(8.0),  // Padding dalam card
                  child: DropdownButton<String>(
                    value: categoriesDropDownController.selectedCategoryId?.value,  // Nilai yang dipilih saat ini
                    items: categoriesDropDownController.categories.map((category) {  // Mengubah daftar kategori menjadi DropdownMenuItem
                      return DropdownMenuItem<String>(
                        value: category['categoryId'],  // Nilai dari item dropdown
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                category['categoryImg'].toString(),  // Gambar kategori
                              ),
                            ),
                            const SizedBox(width: 20),  // Jarak antara gambar dan teks
                            Text(category['categoryName']),  // Nama kategori
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (String? selectedValue) async {  // Fungsi yang dipanggil saat item dipilih
                      categoriesDropDownController.setSelectedCategory(selectedValue);  // Mengatur kategori yang dipilih
                      String? categoryName = await categoriesDropDownController.getCategoryName(selectedValue);  // Mendapatkan nama kategori
                      categoriesDropDownController.setSelectedCategoryName(categoryName);  // Mengatur nama kategori yang dipilih
                    },
                    hint: const Text('Select a category'),  // Hint untuk dropdown
                    isExpanded: true,  // Membuat dropdown mengambil lebar penuh
                    elevation: 10,  // Elevasi untuk dropdown
                    underline: const SizedBox.shrink(),  // Menghilangkan garis bawah default dari dropdown
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
