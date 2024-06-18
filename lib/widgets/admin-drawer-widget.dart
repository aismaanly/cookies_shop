import 'package:cloud_firestore/cloud_firestore.dart';  // Package untuk mengakses Firestore
import 'package:cookies_shop/controllers/get-user-data-controller.dart';  // Controller untuk mendapatkan data pengguna
import 'package:cookies_shop/controllers/log-in-controller.dart';  // Controller untuk proses login
import 'package:cookies_shop/models/user-model.dart';  // Model data pengguna
import 'package:cookies_shop/screens/admin-panel/admin-all-categories-screen.dart';  // Halaman untuk melihat semua kategori produk (admin)
import 'package:cookies_shop/screens/admin-panel/admin-all-orders-screen.dart';  // Halaman untuk melihat semua pesanan (admin)
import 'package:cookies_shop/screens/admin-panel/admin-all-products-screen.dart';  // Halaman untuk melihat semua produk (admin)
import 'package:cookies_shop/screens/admin-panel/admin-main-screen.dart';  // Halaman utama admin
import 'package:cookies_shop/screens/admin-panel/contact-screen.dart';  // Halaman kontak admin
import 'package:cookies_shop/screens/auth-ui/log-in-screen.dart';  // Halaman login
import 'package:cookies_shop/screens/admin-panel/all-users-screen.dart';  // Halaman untuk melihat semua pengguna (admin)
import 'package:cookies_shop/screens/user-panel/profile-screen.dart';  // Halaman profil pengguna
import 'package:cookies_shop/utils/app-constant.dart';  // Konstanta aplikasi
import 'package:firebase_auth/firebase_auth.dart';  // Package untuk autentikasi Firebase
import 'package:flutter/material.dart';  // Package untuk komponen UI Flutter
import 'package:get/get.dart';  // Package untuk manajemen state dan navigasi dengan GetX

class AdminDrawerWidget extends StatefulWidget {
  const AdminDrawerWidget({super.key});

  @override
  State<AdminDrawerWidget> createState() => _AdminDrawerWidgetState();
}

class _AdminDrawerWidgetState extends State<AdminDrawerWidget> {
  User? user = FirebaseAuth.instance.currentUser;  // Mendapatkan instance pengguna saat ini dari Firebase Authentication
  final SignInController signInController = Get.put(SignInController());  // Controller untuk sign-in menggunakan GetX
  final GetUserDataController getUserDataController = Get.put(GetUserDataController());  // Controller untuk mendapatkan data pengguna menggunakan GetX

  String? userName;  // Nama pengguna
  String? firstLetter;  // Huruf pertama dari nama pengguna
  UserModel? userModel;  // Model data pengguna

  // Fungsi async untuk mendapatkan data pengguna dari Firestore berdasarkan UID
  Future<dynamic> getUserData() async {
    if (user != null) {
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
            // Navigasi untuk berbagai layar dalam aplikasi admin
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.offAll(() => AdminMainScreen());  // Navigasi ke halaman utama admin
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
                  Get.to(() => AllUsersScreen());  // Navigasi ke halaman semua pengguna (admin)
                },
                title: Text(
                  'Users',
                  style: TextStyle(color: Colors.white),
                ),
                leading: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: ListTile(
                onTap: () {
                  Get.to(() => AdminAllOrdersScreen());  // Navigasi ke halaman semua pesanan (admin)
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
                  Get.to(() => AdminAllProductsScreen());  // Navigasi ke halaman semua produk (admin)
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
                  Get.to(() => AdminAllCategoriesScreen());  // Navigasi ke halaman semua kategori produk (admin)
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
                  Get.back();
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
                  "Logout",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.logout,
                  color: AppConstant.appTextColor,
                ),
                onTap: () {
                  // Dialog konfirmasi untuk logout
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