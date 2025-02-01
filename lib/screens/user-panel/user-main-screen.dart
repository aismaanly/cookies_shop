// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:cookies_shop/screens/user-panel/all-categories-screen.dart'; // Layar untuk menampilkan semua kategori produk.
import 'package:cookies_shop/screens/user-panel/all-flash-sale-products.dart'; // Layar untuk menampilkan semua produk flash sale.
import 'package:cookies_shop/screens/user-panel/all-products-screen.dart'; // Layar untuk menampilkan semua produk.
import 'package:cookies_shop/screens/user-panel/cart-screen.dart'; // Layar untuk keranjang belanja.
import 'package:cookies_shop/widgets/all-products-widget.dart'; // Widget untuk menampilkan semua produk.
import 'package:cookies_shop/widgets/banner-widget.dart'; // Widget untuk banner promosi.
import 'package:cookies_shop/widgets/category-widget.dart'; // Widget untuk menampilkan kategori produk.
import 'package:cookies_shop/widgets/flash-sale-widget.dart'; // Widget untuk menampilkan produk flash sale.
import 'package:cookies_shop/widgets/heading-widget.dart'; // Widget untuk judul dengan tombol aksi.
import 'package:flutter/material.dart'; // Package flutter/material.dart untuk widget Material Design.
import 'package:flutter/services.dart'; // Package flutter/services.dart untuk mengakses layanan platform.
import 'package:get/get.dart'; // Package get/get.dart untuk manajemen state dan navigasi.
import '../../utils/app-constant.dart'; // Konstanta aplikasi untuk pengaturan tema.
import '../../widgets/user-drawer-widget.dart'; // Widget drawer untuk menu navigasi pengguna.

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon pada app bar.
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppConstant.appMainColor, // Warna status bar.
            statusBarIconBrightness: Brightness.light), // Kecerahan ikon pada status bar.
        title: Text(
          AppConstant.appMainName, // Judul aplikasi.
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
        centerTitle: true, // Pusatkan judul app bar.
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()), // Navigasi ke layar CartScreen saat ikon keranjang di-tap.
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.shopping_cart, // Ikon keranjang belanja.
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(), // Widget drawer untuk menu navigasi.
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(), // Efek fisika saat scrolling.
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 80.0, // Spasi vertikal.
              ),

              // Banner promosi
              BannerWidget(),

              // Heading kategori
              HeadingWidget(
                headingTitle: "Categories", // Judul kategori.
                headingSubTitle: "According to your budget", // Subjudul kategori.
                onTap: () => Get.to(() => AllCategoriesScreen()), // Navigasi ke layar AllCategoriesScreen saat teks di-tap.
                buttonText: "See More >", // Tombol lihat lebih banyak.
              ),

              CategoriesWidget(), // Widget untuk menampilkan kategori produk.

              // Heading flash sale
              HeadingWidget(
                headingTitle: "Flash Sale", // Judul flash sale.
                headingSubTitle: "According to your budget", // Subjudul flash sale.
                onTap: () => Get.to(() => AllFlashSaleProductScreen()), // Navigasi ke layar AllFlashSaleProductScreen saat teks di-tap.
                buttonText: "See More >", // Tombol lihat lebih banyak.
              ),

              FlashSaleWidget(), // Widget untuk menampilkan produk flash sale.

              // Heading semua produk
              HeadingWidget(
                headingTitle: "All Products", // Judul semua produk.
                headingSubTitle: "According to your budget", // Subjudul semua produk.
                onTap: () => Get.to(() => AllProductsScreen()), // Navigasi ke layar AllProductsScreen saat teks di-tap.
                buttonText: "See More >", // Tombol lihat lebih banyak.
              ),

              AllProductsWidget(), // Widget untuk menampilkan semua produk.
            ],
          ),
        ),
      ),
    );
  }
}
