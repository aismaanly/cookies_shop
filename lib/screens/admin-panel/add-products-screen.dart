// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';// Import library dasar dari Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart';// Import untuk menampilkan loading, error, dan sukses dengan mudah
import 'package:get/get.dart';// Import package GetX untuk manajemen state
import 'package:cloud_firestore/cloud_firestore.dart';// Import untuk berinteraksi dengan Firestore
import 'package:cookies_shop/controllers/category-dropdown_controller.dart';// Import controller untuk dropdown kategori
import 'package:cookies_shop/controllers/is-sale-controller.dart';// Import controller untuk status sale
import 'package:cookies_shop/models/product-model.dart';// Import model ProductModel untuk data produk
import 'package:cookies_shop/services/generate-ids-service.dart';// Import service untuk menghasilkan ID produk
import 'package:cookies_shop/utils/app-constant.dart';// Import konstanta aplikasi seperti warna dan tema
import 'package:cookies_shop/widgets/dropdown-categories-widget.dart';// Import widget dropdown kategori

// Deklarasi kelas AddProductScreen yang merupakan StatelessWidget
class AddProductScreen extends StatelessWidget {
  // Konstruktor AddProductScreen
  AddProductScreen({super.key});

  // Controller untuk mengontrol input dari form
  TextEditingController addProductImagesController = TextEditingController();
  // Instance controller dropdown kategori menggunakan GetX
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());
  // Instance controller status sale menggunakan GetX
  IsSaleController isSaleController = Get.put(IsSaleController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  // Variabel untuk menyimpan pesan error jika validasi gagal
  String errorMessage = '';

  // Method untuk mengupload data produk ke Firestore
  Future<void> _uploadProduct() async {
    // Validasi bahwa semua input terisi dengan benar sebelum mengupload
    if (_validateFields()) {
      try {
        // Menampilkan loading indicator
        EasyLoading.show();

        // Generate ID produk yang unik menggunakan service GenerateIds
        String productId = await GenerateIds().generateProductId();

        // Memisahkan dan membersihkan URL gambar produk
        List<String> productImages = addProductImagesController.text
            .trim()
            .split(',')
            .map((image) => image.trim())
            .toList();

        // Membuat objek ProductModel dengan data yang diinputkan
        ProductModel productModel = ProductModel(
          productId: productId,
          categoryId: categoryDropDownController.selectedCategoryId.toString(),
          productName: productNameController.text.trim(),
          categoryName:
              categoryDropDownController.selectedCategoryName.toString(),
          salePrice: salePriceController.text.isNotEmpty
              ? salePriceController.text.trim()
              : '',
          fullPrice: fullPriceController.text.trim(),
          productImages: productImages,
          deliveryTime: deliveryTimeController.text.trim(),
          isSale: isSaleController.isSale.value,
          productDescription: productDescriptionController.text.trim(),
          createdAt: DateTime.now(),
        );

        // Menyimpan data produk ke Firestore
        await FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .set(productModel.toMap());

        // Menutup loading indicator setelah berhasil
        EasyLoading.dismiss();
        // Menampilkan pesan sukses
        EasyLoading.showSuccess('Product successfully added.');

      } catch (e) {
        // Menampilkan error di console jika terjadi kesalahan
        print("error : $e");
      }
    } else {
      // Menampilkan pesan error jika validasi gagal
      EasyLoading.showError("Please fill in all fields");
    }
  }

  // Method untuk validasi input form
  bool _validateFields() {
    // Validasi bahwa semua input yang dibutuhkan terisi
    if (productNameController.text.isEmpty ||
        addProductImagesController.text.isEmpty ||
        fullPriceController.text.isEmpty ||
        deliveryTimeController.text.isEmpty ||
        productDescriptionController.text.isEmpty) {
      errorMessage = "Please fill in all required fields.";
      return false;
    }

    // Validasi bahwa sale price (jika diisi) adalah angka yang valid
    if (!isNumeric(salePriceController.text) &&
        salePriceController.text.isNotEmpty) {
      errorMessage = "Sale Price must be a valid number.";
      return false;
    }

    // Validasi bahwa full price adalah angka yang valid
    if (!isNumeric(fullPriceController.text)) {
      errorMessage = "Full Price must be a valid number.";
      return false;
    }

    return true;
  }

  // Method untuk memeriksa apakah sebuah string adalah angka
  bool isNumeric(String? str) {
    if (str == null) {
      return false;
    }
    return double.tryParse(str) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Mengatur warna ikon di app bar
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor),
        centerTitle: true,
        title: Text(
          "Add Products", // Judul halaman
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appScendoryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Efek bounce saat scrolling
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              // Widget untuk dropdown kategori
              DropDownCategoriesWidget(),
              // Toggle untuk isSale
              GetBuilder<IsSaleController>(
                init: IsSaleController(),
                builder: (isSaleController) {
                  return Card(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Is Sale"),
                          Switch(
                            value: isSaleController.isSale.value,
                            activeColor: AppConstant.appScendoryColor,
                            onChanged: (value) {
                              isSaleController.toggleIsSale(value);
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20.0), // Spacer vertikal
              // Input fields untuk form produk
              Container(
                height: 65,
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  // Warna kursor
                  cursorColor: AppConstant.appScendoryColor,
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    // Label untuk input nama produk
                    labelText: "Product Name",
                    // Hint untuk input nama produk
                    hintText: "Enter product name",
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
                  // Warna kursor
                  cursorColor: AppConstant.appScendoryColor,
                  textInputAction: TextInputAction.next,
                  controller: addProductImagesController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    // Label untuk input URL gambar produk
                    labelText: "Image Product (Comma separated URLs)",
                    // Hint untuk input URL gambar produk
                    hintText: "Enter image product URLs separated by comma",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              // Input untuk sale price (hanya muncul jika isSale diaktifkan)
              Obx(() {
                return isSaleController.isSale.value
                    ? Container(
                        height: 65,
                        margin: EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          // Warna kursor
                          cursorColor: AppConstant.appScendoryColor,
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            // Label untuk input sale price
                            labelText: "Sale Price",
                            // Hint untuk input sale price
                            hintText: "Enter sale price",
                            hintStyle: TextStyle(fontSize: 12.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(); // Spacer kosong jika isSale tidak aktif
              }),
              Container(
                height: 65,
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  // Warna kursor
                  cursorColor: AppConstant.appScendoryColor,
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    // Label untuk input full price
                    labelText: "Full Price",
                    // Hint untuk input full price
                    hintText: "Enter full price",
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
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  // Warna kursor
                  cursorColor: AppConstant.appScendoryColor,
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    // Label untuk input waktu pengiriman
                    labelText: "Delivery time",
                    // Hint untuk input waktu pengiriman
                    hintText: "Enter delivery time",
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
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                child: TextFormField(
                  // Warna kursor
                  cursorColor: AppConstant.appScendoryColor,
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    // Label untuk input deskripsi produk
                    labelText: "Product Description",
                    // Hint untuk input deskripsi produk
                    hintText: "Enter product description",
                    hintStyle: TextStyle(fontSize: 12.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.0), // Spacer vertikal
              // Tombol untuk mengupload produk
              ElevatedButton(
                // Method yang dipanggil saat tombol ditekan
                onPressed: _uploadProduct,
                style: ElevatedButton.styleFrom(
                  // Warna background tombol
                  backgroundColor: AppConstant.appScendoryColor,
                  // Padding tombol
                  padding: EdgeInsets.all(20.0),
                ),
                child: Text(
                  "Upload", // Teks di dalam tombol
                  // Warna teks di dalam tombol
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Fungsi untuk memeriksa apakah sebuah string adalah angka
bool isNumeric(String? str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}
