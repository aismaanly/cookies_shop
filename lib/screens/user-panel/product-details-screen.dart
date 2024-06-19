import 'package:cached_network_image/cached_network_image.dart'; // Import package cached_network_image untuk memuat gambar dari URL dengan caching.
import 'package:carousel_slider/carousel_slider.dart'; // Import package carousel_slider untuk membuat slider gambar.
import 'package:cloud_firestore/cloud_firestore.dart'; // Import package cloud_firestore untuk interaksi dengan Firestore database.
import 'package:cookies_shop/models/product-model.dart'; // Import model ProductModel untuk data produk.
import 'package:cookies_shop/screens/user-panel/cart-screen.dart'; // Import layar CartScreen untuk navigasi ke keranjang belanja.
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi untuk styling konsisten.
import 'package:firebase_auth/firebase_auth.dart'; // Import package firebase_auth untuk otentikasi pengguna.
import 'package:flutter/cupertino.dart'; // Import package flutter/cupertino.dart untuk widget gaya iOS.
import 'package:flutter/material.dart'; // Import package flutter/material.dart untuk widget Material Design.
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Import package flutter_easyloading untuk menampilkan indikator loading.
import 'package:get/get.dart'; // Import package get untuk manajemen state.

import '../../models/cart-model.dart'; // Import model CartModel untuk item keranjang.

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel productModel; // Properti untuk menyimpan model produk.

  ProductDetailsScreen({Key? key, required this.productModel}) : super(key: key);

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late User? user = FirebaseAuth.instance.currentUser; // Mendapatkan pengguna yang saat ini diautentikasi.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema warna ikon pada app bar dari konstanta aplikasi.
        centerTitle: true,
        title: Text(
          "Product Details", // Judul pada app bar.
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appScendoryColor,
            fontSize: 20,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()), // Navigasi ke CartScreen saat ikon keranjang ditekan.
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.shopping_cart), // Ikon keranjang belanja.
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height / 60), // Spasi kosong setara dengan 1/60 dari tinggi layar.
          CarouselSlider(
            items: widget.productModel.productImages.map((imageUrls) => ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: imageUrls,
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width - 10, // Lebar gambar sesuai dengan lebar layar dikurangi 10.
                placeholder: (context, url) => ColoredBox(
                  color: Colors.white,
                  child: Center(
                    child: CupertinoActivityIndicator(), // Indikator aktivitas saat memuat gambar.
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error), // Widget ikon error jika gambar gagal dimuat.
              ),
            )).toList(),
            options: CarouselOptions(
              scrollDirection: Axis.horizontal, // Arah scroll horizontal.
              autoPlay: true, // Otomatis memainkan slider.
              aspectRatio: 2.0, // Rasio aspek gambar.
              viewportFraction: 1, // Fraksi viewport.
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.0), // Padding semua sisi sebesar 12.0.
            child: Card(
              color: Colors.white, // Warna latar belakang kartu putih.
              elevation: 5.0, // Efek elevasi kartu.
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0), // Bentuk tepi kartu bulat dengan radius 20.0.
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.brown[200]!, Colors.brown[400]!], // Gradien warna dari coklat muda ke coklat tua.
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0), // Sudut bulat kiri atas kartu.
                        topRight: Radius.circular(20.0), // Sudut bulat kanan atas kartu.
                      ),
                    ),
                    padding: EdgeInsets.all(16.0), // Padding dalam kontainer 16.0.
                    alignment: Alignment.center,
                    child: Text(
                      widget.productModel.productName, // Menampilkan nama produk di tengah kontainer.
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Padding dalam kolom 16.0.
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.productModel.isSale == true && widget.productModel.salePrice.isNotEmpty
                              ? "Price: Rp." + widget.productModel.salePrice // Harga jual jika tersedia.
                              : "Price: Rp." + widget.productModel.fullPrice, // Harga penuh jika tidak ada harga jual.
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8), // Spasi kosong vertikal sebesar 8.
                        Text(
                          "Category: " + widget.productModel.categoryName, // Menampilkan kategori produk.
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 8), // Spasi kosong vertikal sebesar 8.
                        Text(
                          "Description: " + widget.productModel.productDescription, // Menampilkan deskripsi produk.
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0), // Padding dalam kolom 16.0.
                    child: Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.0, // Lebar kontainer setengah dari lebar layar.
                        height: MediaQuery.of(context).size.height / 16, // Tinggi kontainer setengah dari tinggi layar.
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.pinkAccent, Colors.redAccent], // Gradien warna dari pink ke merah.
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30.0), // Bentuk tepi kontainer bulat dengan radius 30.0.
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0), // Bentuk tepi tombol bulat dengan radius 30.0.
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                          child: Text(
                            "Add to cart", // Teks tombol "Add to cart".
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            await checkProductExistence(uId: user!.uid); // Memanggil fungsi untuk mengecek atau menambahkan produk ke keranjang.
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Fungsi untuk mengecek apakah produk sudah ada di keranjang atau menambahkannya jika belum.
  Future<void> checkProductExistence({
    required String uId,
    int quantityIncrement = 1,
  }) async {
    final DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString()); // Referensi dokumen produk dalam Firestore.

    DocumentSnapshot snapshot = await documentReference.get(); // Mendapatkan snapshot dokumen.

    if (snapshot.exists) {
      int currentQuantity = snapshot['productQuantity']; // Mendapatkan jumlah produk saat ini dalam keranjang.
      int updatedQuantity = currentQuantity + quantityIncrement; // Menambahkan jumlah produk dengan increment.
      double totalPrice = double.parse(widget.productModel.isSale
              ? widget.productModel.salePrice
              : widget.productModel.fullPrice) *
          updatedQuantity; // Menghitung total harga produk.

      await documentReference.update({
        'productQuantity': updatedQuantity, // Memperbarui jumlah produk dalam Firestore.
        'productTotalPrice': totalPrice, // Memperbarui total harga produk dalam Firestore.
      });

      print("Product exists in cart, quantity updated."); // Pesan konfirmasi produk sudah ada dalam keranjang.
    } else {
      await FirebaseFirestore.instance.collection('cart').doc(uId).set(
        {
          'uId': uId, // Menyimpan ID pengguna dalam dokumen keranjang.
          'createdAt': DateTime.now(), // Menyimpan waktu pembuatan dokumen.
        },
      );

      CartModel cartModel = CartModel(
        productId: widget.productModel.productId, // Menginisialisasi model CartModel dengan data produk.
        categoryId: widget.productModel.categoryId,
        productName: widget.productModel.productName,
        categoryName: widget.productModel.categoryName,
        salePrice: widget.productModel.salePrice,
        fullPrice: widget.productModel.fullPrice,
        productImages: widget.productModel.productImages,
        deliveryTime: widget.productModel.deliveryTime,
        isSale: widget.productModel.isSale,
        productDescription: widget.productModel.productDescription,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        productQuantity: 1, // Menginisialisasi jumlah produk dalam keranjang.
        productTotalPrice: double.parse(widget.productModel.isSale
            ? widget.productModel.salePrice
            : widget.productModel.fullPrice), // Menginisialisasi total harga produk.
      );

      await documentReference.set(cartModel.toMap()); // Menyimpan data produk dalam Firestore.

      print("Product added to cart."); // Pesan konfirmasi produk berhasil ditambahkan ke keranjang.
      EasyLoading.showSuccess("The product has been successfully added to your cart."); // Menampilkan pesan sukses dengan EasyLoading.
    }
  }
}
