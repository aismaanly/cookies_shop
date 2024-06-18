// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import untuk menampilkan loading, error, dan sukses dengan mudah
import 'package:get/get.dart'; // Import package GetX untuk manajemen state
import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk berinteraksi dengan Firestore
import 'package:cookies_shop/controllers/category-dropdown_controller.dart'; // Import controller untuk dropdown kategori
import 'package:cookies_shop/controllers/is-sale-controller.dart'; // Import controller untuk status sale
import 'package:cookies_shop/models/product-model.dart'; // Import model ProductModel untuk data produk
import 'package:cookies_shop/services/generate-ids-service.dart'; // Import service untuk menghasilkan ID produk
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema
import 'package:cookies_shop/widgets/dropdown-categories-widget.dart'; // Import widget dropdown kategori

class AddProductScreen extends StatelessWidget {
  AddProductScreen({super.key});

  // Controller untuk mengontrol input dari form
  TextEditingController addProductImagesController = TextEditingController();
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController()); // Instance controller dropdown kategori menggunakan GetX
  IsSaleController isSaleController = Get.put(IsSaleController()); // Instance controller status sale menggunakan GetX
  TextEditingController productNameController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  String errorMessage = ''; // Variabel untuk menyimpan pesan error jika validasi gagal

  // Method untuk mengupload data produk ke Firestore
  Future<void> _uploadProduct() async {
    // Validasi bahwa semua input terisi dengan benar sebelum mengupload
    if (_validateFields()) {
      try {
        EasyLoading.show(); // Menampilkan loading indicator

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

        EasyLoading.dismiss(); // Menutup loading indicator setelah berhasil
        EasyLoading.showSuccess('Product successfully added.'); // Menampilkan pesan sukses

      } catch (e) {
        print("error : $e"); // Menampilkan error di console jika terjadi kesalahan
      }
    } else {
      EasyLoading.showError("Please fill in all fields"); // Menampilkan pesan error jika validasi gagal
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
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar
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
        physics: BouncingScrollPhysics(), // Efek bounce saat scrolling
        child: Container(
          child: Column(
            children: [
              DropDownCategoriesWidget(), // Widget untuk dropdown kategori
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
                  cursorColor: AppConstant.appScendoryColor, // Warna kursor
                  textInputAction: TextInputAction.next,
                  controller: productNameController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Product Name", // Label untuk input nama produk
                    hintText: "Enter product name", // Hint untuk input nama produk
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
                  cursorColor: AppConstant.appScendoryColor, // Warna kursor
                  textInputAction: TextInputAction.next,
                  controller: addProductImagesController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Image Product (Comma separated URLs)", // Label untuk input URL gambar produk
                    hintText:
                        "Enter image product URLs separated by comma", // Hint untuk input URL gambar produk
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
                          cursorColor: AppConstant.appScendoryColor, // Warna kursor
                          textInputAction: TextInputAction.next,
                          controller: salePriceController,
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            labelText: "Sale Price", // Label untuk input sale price
                            hintText: "Enter sale price", // Hint untuk input sale price
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
                  cursorColor: AppConstant.appScendoryColor, // Warna kursor
                  textInputAction: TextInputAction.next,
                  controller: fullPriceController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Full Price", // Label untuk input full price
                    hintText: "Enter full price", // Hint untuk input full price
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
                  cursorColor: AppConstant.appScendoryColor, // Warna kursor
                  textInputAction: TextInputAction.next,
                  controller: deliveryTimeController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Delivery time", // Label untuk input waktu pengiriman
                    hintText: "Enter delivery time", // Hint untuk input waktu pengiriman
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
                  cursorColor: AppConstant.appScendoryColor, // Warna kursor
                  textInputAction: TextInputAction.next,
                  controller: productDescriptionController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                    ),
                    labelText: "Product Description", // Label untuk input deskripsi produk
                    hintText: "Enter product description", // Hint untuk input deskripsi produk
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
                onPressed: _uploadProduct, // Method yang dipanggil saat tombol ditekan
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appScendoryColor, // Warna background tombol
                  padding: EdgeInsets.all(20.0), // Padding tombol
                ),
                child: Text(
                  "Upload", // Text di dalam tombol
                  style: TextStyle(color: Colors.white), // Warna teks di dalam tombol
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function untuk memeriksa apakah sebuah string adalah angka
bool isNumeric(String? str) {
  if (str == null) {
    return false;
  }
  return double.tryParse(str) != null;
}
