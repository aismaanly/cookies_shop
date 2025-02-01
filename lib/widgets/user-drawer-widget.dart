// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, no_leading_underscores_for_local_identifiers

// Mengimpor paket-paket yang diperlukan
import 'package:cloud_firestore/cloud_firestore.dart';  // Untuk mengakses Firestore
import 'package:cookies_shop/controllers/get-user-data-controller.dart';  // Untuk controller pengambilan data pengguna
import 'package:cookies_shop/controllers/log-in-controller.dart';  // Untuk controller login
import 'package:cookies_shop/models/user-model.dart';  // Untuk model data pengguna
import 'package:cookies_shop/screens/admin-panel/contact-screen.dart';  // Untuk halaman kontak admin
import 'package:cookies_shop/screens/auth-ui/log-in-screen.dart';  // Untuk halaman login
import 'package:cookies_shop/screens/user-panel/all-categories-screen.dart';  // Untuk halaman kategori produk
import 'package:cookies_shop/screens/user-panel/all-orders-screen.dart';  // Untuk halaman pesanan pengguna
import 'package:cookies_shop/screens/user-panel/all-products-screen.dart';  // Untuk halaman semua produk
import 'package:cookies_shop/screens/user-panel/profile-screen.dart';  // Untuk halaman profil pengguna
import 'package:cookies_shop/screens/user-panel/user-main-screen.dart';  // Untuk halaman utama pengguna
import 'package:cookies_shop/utils/app-constant.dart';  // Untuk konstanta aplikasi
import 'package:firebase_auth/firebase_auth.dart';  // Untuk autentikasi pengguna Firebase
import 'package:flutter/material.dart';  // Untuk komponen UI Flutter
import 'package:get/get.dart';  // Untuk manajemen state dan navigasi dengan GetX

// Deklarasi widget Stateful bernama DrawerWidget
class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  // Mendapatkan instance pengguna saat ini dari Firebase Authentication
  User? user = FirebaseAuth.instance.currentUser;
  
  // Inisialisasi controller sign-in dengan GetX
  final SignInController signInController = Get.put(SignInController());
  
  // Inisialisasi controller pengambilan data pengguna dengan GetX
  final GetUserDataController getUserDataController = Get.put(GetUserDataController());

  String? userName;  // Nama pengguna
  String? firstLetter;  // Huruf pertama dari nama pengguna
  UserModel? userModel;  // Model data pengguna

  // Fungsi async untuk mendapatkan data pengguna dari Firestore berdasarkan UID
  Future<void> getUserData() async {
    if (user != null) {
      // Mengambil data pengguna dari Firestore
      final DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid.toString())
          .get();

      // Mengisi userModel dengan data dari snapshot Firestore
      userModel = UserModel.fromMap(snapshot.data() as Map<String, dynamic>);
      userName = userModel?.username;  // Mengambil nama pengguna dari model
      firstLetter = userModel?.username[0];  // Mengambil huruf pertama dari nama pengguna
      setState(() {});  // Memperbarui tampilan dengan setState
    }
  }

  @override
  void initState() {
    super.initState();

    // Memanggil fungsi getUserData saat initState untuk mendapatkan data pengguna
    if (user != null) {
      getUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Widget Drawer yang berisi navigasi dan informasi pengguna
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topRight: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        )),
        child: Wrap(
          runSpacing: 10,
          children: [
            // Tampilan jika pengguna sudah login
            user != null
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: ListTile(
                      onTap: () {
                        if (userModel != null) {
                          Get.back();
                          Get.to(() => ProfileScreen(userModel: userModel!));  // Navigasi ke halaman profil pengguna
                        }
                      },
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        userName ?? '',  // Menampilkan nama pengguna atau string kosong
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      subtitle: Text(
                        AppConstant.appVersion,  // Menampilkan versi aplikasi
                        style: TextStyle(color: Colors.grey),
                      ),
                      leading: CircleAvatar(
                        radius: 22.0,
                        backgroundColor: AppConstant.appMainColor,
                        child: Text(
                          firstLetter ?? '',  // Menampilkan huruf pertama nama pengguna atau string kosong
                          style: TextStyle(color: AppConstant.appTextColor),
                        ),
                      ),
                    ),
                  )
                : // Tampilan jika pengguna belum login
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20.0),
                    child: ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Guest",  // Menampilkan "Guest" jika pengguna belum login
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      subtitle: Text(
                        AppConstant.appVersion,  // Menampilkan versi aplikasi
                        style: TextStyle(color: Colors.grey),
                      ),
                      leading: CircleAvatar(
                        radius: 22.0,
                        backgroundColor: AppConstant.appMainColor,
                        child: Text(
                          "G",  // Menampilkan "G" untuk "Guest"
                          style: TextStyle(color: AppConstant.appTextColor),
                        ),
                      ),
                    ),
                  ),
            Divider(
              indent: 10.0,
              endIndent: 10.0,
              thickness: 1.5,
              color: Colors.grey,
            ),
            // Navigasi untuk berbagai layar dalam aplikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.offAll(() => MainScreen());  // Navigasi ke halaman utama aplikasi
                },
                title: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.home_outlined,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.to(() => AllOrdersScreen());  // Navigasi ke halaman semua pesanan pengguna
                },
                title: Text(
                  'Orders',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.shopping_bag,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.back();
                  Get.to(() => AllProductsScreen());  // Navigasi ke halaman semua produk
                },
                title: Text(
                  'Products',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                onTap: () async {
                  Get.back();
                  Get.to(() => AllCategoriesScreen());  // Navigasi ke halaman semua kategori produk
                },
                title: Text(
                  'Categories',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.category,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.to(() => ContactScreen());  // Navigasi ke halaman kontak admin
                },
                title: Text(
                  'Contact',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.help,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Logout",  // Teks untuk logout
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.logout,
                  color: AppConstant.appTextColor,
                ),
                onTap: () {
                  // Dialog konfirmasi logout
                  Get.defaultDialog(
                    title: "Confirm Logout",
                    middleText: "Are you sure you want to logout?",
                    textCancel: "No",
                    textConfirm: "Yes",
                    confirmTextColor: Colors.white,
                    buttonColor: Colors.red,
                    cancelTextColor: Colors.black,
                    onConfirm: () {
                      FirebaseAuth.instance.signOut();  // Proses logout dari Firebase Authentication
                      Get.offAll(() => LogInScreen());  // Navigasi kembali ke halaman login
                    },
                  );
                },
              ),
            ),
          ],
        ),
        width: Get.width - 80.0,  // Lebar drawer
        backgroundColor: AppConstant.appScendoryColor,  // Warna latar belakang drawer
      ),
    );
  }
}
