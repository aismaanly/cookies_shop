// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors,
// sized_box_for_whitespace, unused_import, unused_local_variable

import 'dart:io'; // Mengimpor pustaka dart:io untuk menggunakan platform-specific code
import 'package:cached_network_image/cached_network_image.dart'; // Mengimpor CachedNetworkImage dari pustaka cached_network_image
import 'package:cloud_firestore/cloud_firestore.dart'; // Mengimpor Firestore dari pustaka cloud_firestore
import 'package:cookies_shop/controllers/category-dropdown_controller.dart'; // Mengimpor CategoryDropDownController dari file category-dropdown_controller.dart
import 'package:cookies_shop/controllers/edit-product-controller.dart'; // Mengimpor EditProductController dari file edit-product-controller.dart
import 'package:cookies_shop/controllers/is-sale-controller.dart'; // Mengimpor IsSaleController dari file is-sale-controller.dart
import 'package:cookies_shop/models/product-model.dart'; // Mengimpor ProductModel dari file product-model.dart
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor AppConstant dari file app-constant.dart
import 'package:flutter/cupertino.dart'; // Mengimpor pustaka flutter/cupertino.dart untuk menggunakan Cupertino widgets
import 'package:flutter/material.dart'; // Mengimpor pustaka flutter/material.dart untuk menggunakan Material widgets
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Mengimpor EasyLoading dari pustaka flutter_easyloading
import 'package:get/get.dart'; // Mengimpor Get dari pustaka get

class EditProductScreen extends StatefulWidget {
  ProductModel productModel; // Model produk yang akan diedit
  EditProductScreen({super.key, required this.productModel}); // Konstruktor dengan parameter wajib productModel

  @override
  State<EditProductScreen> createState() => _EditProductScreenState(); // Membuat state untuk EditProductScreen
}

class _EditProductScreenState extends State<EditProductScreen> {
  IsSaleController isSaleController = Get.put(IsSaleController()); // Menginisialisasi IsSaleController dari GetX
  CategoryDropDownController categoryDropDownController = Get.put(CategoryDropDownController()); // Menginisialisasi CategoryDropDownController dari GetX
  TextEditingController productNameController = TextEditingController(); // TextEditingController untuk nama produk
  TextEditingController productImageController = TextEditingController(); // TextEditingController untuk gambar produk
  TextEditingController salePriceController = TextEditingController(); // TextEditingController untuk harga jual
  TextEditingController fullPriceController = TextEditingController(); // TextEditingController untuk harga penuh
  TextEditingController deliveryTimeController = TextEditingController(); // TextEditingController untuk waktu pengiriman
  TextEditingController productDescriptionController = TextEditingController(); // TextEditingController untuk deskripsi produk

  @override
  void initState() {
    super.initState();
    // Mengatur nilai awal dari controller sesuai dengan nilai produk yang diteruskan
    productNameController.text = widget.productModel.productName;
    productImageController.text = widget.productModel.productImages.join(',');
    salePriceController.text = widget.productModel.salePrice;
    fullPriceController.text = widget.productModel.fullPrice;
    deliveryTimeController.text = widget.productModel.deliveryTime;
    productDescriptionController.text = widget.productModel.productDescription;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: widget.productModel), // Menginisialisasi EditProductController dari GetX
      builder: (controller) { // Membangun UI berdasarkan controller
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon untuk AppBar
            centerTitle: true, // Pusatkan judul AppBar
            title: Text(
              "Edit Product ${widget.productModel.productName}", // Judul AppBar
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.appScendoryColor,
                fontSize: 20,
              ),
            ),
          ),
          body: SingleChildScrollView( // SingleChildScrollView untuk mengatur scroll tampilan
            child: Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20, // Lebar kontainer
                      height: Get.height / 4.0, // Tinggi kontainer
                      child: GridView.builder(
                        itemCount: controller.images.length, // Jumlah item dalam GridView
                        physics: const BouncingScrollPhysics(), // Efek bouncing scroll
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Jumlah item per baris dalam GridView
                          mainAxisSpacing: 2, // Spasi antar item secara vertikal
                          crossAxisSpacing: 2, // Spasi antar item secara horizontal
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              CachedNetworkImage( // CachedNetworkImage untuk menampilkan gambar dari URL dengan caching
                                imageUrl: controller.images[index], // URL gambar
                                fit: BoxFit.contain, // Pengaturan fit gambar
                                height: Get.height / 5.5, // Tinggi gambar
                                width: Get.width / 2, // Lebar gambar
                                placeholder: (context, url) => Center(child: CupertinoActivityIndicator()), // Widget placeholder ketika memuat gambar
                                errorWidget: (context, url, error) => Icon(Icons.error), // Widget untuk menampilkan ikon error jika gagal memuat gambar
                              ),
                              Positioned( // Membuat posisi item di dalam Stack
                                right: 10, // Jarak dari kanan
                                top: 0, // Jarak dari atas
                                child: InkWell( // InkWell sebagai wrapper untuk item yang dapat di-tap
                                  onTap: () async { // Aksi ketika di-tap
                                    EasyLoading.show(); // Menampilkan loading indicator
                                    await controller.deleteImageFromFireStore( // Menghapus gambar dari Firestore
                                      controller.images[index].toString(), // URL gambar yang akan dihapus
                                      widget.productModel.productId); // ID produk terkait
                                    EasyLoading.dismiss(); // Menutup loading indicator
                                  },
                                  child: CircleAvatar( // Widget avatar dalam bentuk lingkaran
                                    backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang avatar
                                    child: Icon( // Icon di dalam avatar
                                      Icons.close, // Icon close untuk menghapus gambar
                                      color: AppConstant.appTextColor, // Warna icon
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  //drop down
                  GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(), // Menginisialisasi CategoryDropDownController dari GetX
                    builder: (categoriesDropDownController) { // Membangun UI berdasarkan categoriesDropDownController
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0), // Margin kontainer
                            child: Card( // Card untuk tampilan kategori produk
                              elevation: 10, // Elevasi Card
                              child: Padding(
                                padding: const EdgeInsets.all(8.0), // Padding dalam Card
                                child: DropdownButton<String>( // DropdownButton untuk memilih kategori
                                  value: categoriesDropDownController.selectedCategoryId?.value, // Nilai yang dipilih dalam dropdown
                                  items: categoriesDropDownController.categories.map((category) { // Item dalam dropdown berdasarkan list kategori
                                    return DropdownMenuItem<String>(
                                      value: category['categoryId'], // Nilai item dropdown
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max, // Ukuran utama dari Row
                                        children: [
                                          CircleAvatar( // Avatar dalam bentuk lingkaran untuk menampilkan gambar kategori
                                            backgroundImage: NetworkImage(category['categoryImg'].toString()), // Gambar kategori dari URL
                                          ),
                                          const SizedBox(width: 20), // Spasi horizontal
                                          Text(category['categoryName']), // Nama kategori
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedValue) async { // Aksi ketika nilai dropdown berubah
                                    categoriesDropDownController.setSelectedCategory(selectedValue); // Mengatur kategori yang dipilih
                                    String? categoryName = await categoriesDropDownController.getCategoryName(selectedValue); // Mendapatkan nama kategori berdasarkan nilai yang dipilih
                                    categoriesDropDownController.setSelectedCategoryName(categoryName); // Mengatur nama kategori yang dipilih
                                  },
                                  hint: const Text( // Text hint jika belum ada yang dipilih
                                    'Select a category', // Teks hint untuk memilih kategori
                                  ),
                                  isExpanded: true, // Mengatur dropdown agar menyesuaikan lebar
                                  elevation: 10, // Elevasi dropdown
                                  underline: const SizedBox.shrink(), // Garis bawah dropdown diatur menjadi kosong
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  //isSale
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(), // Menginisialisasi IsSaleController dari GetX
                    builder: (isSaleController) { // Membangun UI berdasarkan isSaleController
                      return Card( // Card untuk status apakah produk sedang diskon atau tidak
                        elevation: 10, // Elevasi Card
                        child: Padding(
                          padding: EdgeInsets.all(8.0), // Padding dalam Card
                          child: Row( // Row untuk menampilkan label dan switch
                            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Penyusunan item di sepanjang main axis
                            children: [
                              Text("Is Sale"), // Label "Is Sale"
                              Switch( // Switch untuk mengaktifkan atau menonaktifkan diskon
                                value: isSaleController.isSale.value, // Nilai dari switch
                                activeColor: AppConstant.appScendoryColor, // Warna ketika switch aktif
                                onChanged: (value) { // Aksi ketika nilai switch berubah
                                  isSaleController.toggleIsSale(value); // Mengubah status diskon
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //form
                  SizedBox(height: 15.0), // Spasi vertikal antara widget
                  Container( // Kontainer untuk form input
                    height: 65, // Tinggi kontainer
                    margin: EdgeInsets.symmetric(horizontal: 10.0), // Margin horizontal
                    child: TextFormField( // TextFormField untuk input nama produk
                      cursorColor: AppConstant.appScendoryColor, // Warna kursor
                      textInputAction: TextInputAction.next, // Aksi setelah input selesai
                      controller: productNameController, // Controller untuk mengontrol input
                      decoration: const InputDecoration( // Dekorasi input
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Product Name", // Label input
                        hintText: "Enter category name", // Hint teks input
                        hintStyle: TextStyle(fontSize: 12.0), // Gaya hint teks
                        border: OutlineInputBorder( // Border input
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0), // Spasi vertikal konstan
                  Container( // Kontainer untuk form input gambar produk
                    height: 65, // Tinggi kontainer
                    margin: const EdgeInsets.symmetric(horizontal: 10.0), // Margin horizontal
                    child: TextFormField( // TextFormField untuk input URL gambar produk
                      controller: productImageController, // Controller untuk mengontrol input
                      cursorColor: AppConstant.appScendoryColor, // Warna kursor
                      textInputAction: TextInputAction.done, // Aksi setelah input selesai
                      decoration: const InputDecoration( // Dekorasi input
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Image Product (Comma separated URLs)", // Label input
                        hintText: "Enter image product URLs separated by comma", // Hint teks input
                        hintStyle: TextStyle(fontSize: 12.0), // Gaya hint teks
                        border: OutlineInputBorder( // Border input
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<IsSaleController>( // GetBuilder untuk kondisional menampilkan input harga diskon
                    init: IsSaleController(), // Menginisialisasi IsSaleController dari GetX
                    builder: (isSaleController) {
                      return isSaleController.isSale.value // Menampilkan input harga diskon jika sedang diskon
                          ? Container(
                              height: 65, // Tinggi kontainer
                              margin: EdgeInsets.symmetric(horizontal: 10.0), // Margin horizontal
                              child: TextFormField( // TextFormField untuk input harga diskon
                                cursorColor: AppConstant.appScendoryColor, // Warna kursor
                                textInputAction: TextInputAction.next, // Aksi setelah input selesai
                                controller: salePriceController, // Controller untuk mengontrol input
                                decoration: const InputDecoration( // Dekorasi input
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  labelText: "Sale Price", // Label input
                                  hintText: "Enter sale price", // Hint teks input
                                  hintStyle: TextStyle(fontSize: 12.0), // Gaya hint teks
                                  border: OutlineInputBorder( // Border input
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink(); // Kosongkan widget jika tidak sedang diskon
                    },
                  ),
                  SizedBox(height: 8.0), // Spasi vertikal
                  Container( // Kontainer untuk form input harga penuh
                    height: 65, // Tinggi kontainer
                    margin: EdgeInsets.symmetric(horizontal: 10.0), // Margin horizontal
                    child: TextFormField( // TextFormField untuk input harga penuh
                      cursorColor: AppConstant.appScendoryColor, // Warna kursor
                      textInputAction: TextInputAction.next, // Aksi setelah input selesai
                      controller: fullPriceController, // Controller untuk mengontrol input
                      decoration: const InputDecoration( // Dekorasi input
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Full Price", // Label input
                        hintText: "Enter full price", // Hint teks input
                        hintStyle: TextStyle(fontSize: 12.0), // Gaya hint teks
                        border: OutlineInputBorder( // Border input
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0), // Spasi vertikal
                  Container( // Kontainer untuk form input waktu pengiriman
                    height: 65, // Tinggi kontainer
                    margin: EdgeInsets.symmetric(horizontal: 10.0), // Margin horizontal
                    child: TextFormField( // TextFormField untuk input waktu pengiriman
                      cursorColor: AppConstant.appScendoryColor, // Warna kursor
                      textInputAction: TextInputAction.next, // Aksi setelah input selesai
                      controller: deliveryTimeController, // Controller untuk mengontrol input
                      decoration: const InputDecoration( // Dekorasi input
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Delivery time", // Label input
                        hintText: "Enter delivery time", // Hint teks input
                        hintStyle: TextStyle(fontSize: 12.0), // Gaya hint teks
                        border: OutlineInputBorder( // Border input
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0), // Spasi vertikal
                  Container( // Kontainer untuk form input deskripsi produk
                    height: 65, // Tinggi kontainer
                    margin: EdgeInsets.symmetric(horizontal: 10.0), // Margin horizontal
                    child: TextFormField( // TextFormField untuk input deskripsi produk
                      cursorColor: AppConstant.appScendoryColor, // Warna kursor
                      textInputAction: TextInputAction.next, // Aksi setelah input selesai
                      controller: productDescriptionController, // Controller untuk mengontrol input
                      decoration: const InputDecoration( // Dekorasi input
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Product Description", // Label input
                        hintText: "Enter product description", // Hint teks input
                        hintStyle: TextStyle(fontSize: 12.0), // Gaya hint teks
                        border: OutlineInputBorder( // Border input
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton( // Tombol untuk menyimpan perubahan produk
                    onPressed: () async {
                      EasyLoading.show(status: "Updating..."); // Menampilkan loading indicator dengan status

                      List<String> productImages = productImageController.text // Mendapatkan daftar URL gambar dari input
                          .trim()
                          .split(',')
                          .map((image) => image.trim())
                          .toList();

                      ProductModel newProductModel = ProductModel( // Membuat objek ProductModel baru berdasarkan input
                        productId: widget.productModel.productId, // ID produk yang sedang diedit
                        categoryId: categoryDropDownController.selectedCategoryId.toString(), // ID kategori yang dipilih
                        productName: productNameController.text.trim(), // Nama produk dari input
                        categoryName: categoryDropDownController.selectedCategoryName.toString(), // Nama kategori yang dipilih
                        salePrice: salePriceController.text != '' ? salePriceController.text.trim() : '', // Harga diskon dari input
                        fullPrice: fullPriceController.text.trim(), // Harga penuh dari input
                        productImages: widget.productModel.productImages, // Daftar gambar produk
                        deliveryTime: deliveryTimeController.text.trim(), // Waktu pengiriman dari input
                        isSale: isSaleController.isSale.value, // Status diskon dari input
                        productDescription: productDescriptionController.text.trim(), // Deskripsi produk dari input
                        createdAt: widget.productModel.createdAt, // Waktu pembuatan produk
                      );

                      await FirebaseFirestore.instance // Mengakses Firestore untuk memperbarui produk
                          .collection('products')
                          .doc(widget.productModel.productId)
                          .update(newProductModel.toMap()) // Memperbarui data produk
                          .then((_) {
                        EasyLoading.dismiss(); // Menutup loading indicator
                        EasyLoading.showSuccess("Product Updated"); // Menampilkan notifikasi sukses
                      }).catchError((error) {
                        EasyLoading.dismiss(); // Menutup loading indicator
                        EasyLoading.showError("Failed to update product"); // Menampilkan notifikasi gagal
                      });
                    },
                    style: ElevatedButton.styleFrom( // Gaya tombol ElevatedButton
                      backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang tombol
                      padding: EdgeInsets.all(20.0), // Padding tombol
                    ),
                    child: Text( // Teks di dalam tombol
                      "Update Product", // Teks tombol untuk menyimpan perubahan produk
                      style: TextStyle(fontSize: 18.0), // Gaya teks
                    ),
                  ),

                  SizedBox(height: 8.0), // Spasi vertikal
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
