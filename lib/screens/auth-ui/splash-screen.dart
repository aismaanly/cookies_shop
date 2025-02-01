// ignore_for_file: unused_local_variable, prefer_const_constructors

import 'dart:async';
import 'package:cookies_shop/controllers/get-user-data-controller.dart';
import 'package:cookies_shop/screens/admin-panel/admin-main-screen.dart';
import 'package:cookies_shop/screens/auth-ui/log-in-screen.dart';
import 'package:cookies_shop/screens/user-panel/user-main-screen.dart';
import 'package:cookies_shop/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;  // Mendapatkan pengguna saat ini dari Firebase Authentication

  @override
  void initState() {
    super.initState();
    // Timer untuk menavigasi ke LogInScreen setelah 4 detik
    Timer(Duration(seconds: 4), () {
      Get.offAll(() => LogInScreen());
    });
  }

  // Future untuk mengecek apakah pengguna sudah login
  Future<void> loggedIn(BuildContext context) async {
    if (user != null) {
      final GetUserDataController getUserDataController =
          Get.put(GetUserDataController());  // Menginisialisasi controller untuk mendapatkan data pengguna
      var userData = await getUserDataController.getUserData(user!.uid);  // Mendapatkan data pengguna berdasarkan UID

      // Memeriksa apakah pengguna adalah admin atau bukan
      if (userData[0]['isAdmin'] == true) {
        Get.offAll(() => AdminMainScreen());  // Jika admin, navigasi ke AdminMainScreen
      } else {
        Get.offAll(() => MainScreen());  // Jika bukan admin, navigasi ke MainScreen
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;  // Mendapatkan ukuran layar perangkat
    return Scaffold(
      backgroundColor: AppConstant.appScendoryColor,  // Warna latar belakang dari konstanta aplikasi
      appBar: AppBar(
        backgroundColor: AppConstant.appScendoryColor,  // Warna appbar dari konstanta aplikasi
        elevation: 0,  // Elevation appbar dihilangkan
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: Get.width,  // Lebar container sesuai dengan lebar layar
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: Get.width * 0.5,
                    height: Get.width * 0.5,
                    child: Lottie.asset('assets/splash-icon.json'),  // Widget Lottie untuk animasi splash
                  ),
                  SizedBox(height: 10),
                  Text(
                    AppConstant.appMainName,  // Nama aplikasi dari konstanta aplikasi
                    style: TextStyle(
                        color: AppConstant.appTextColor,  // Warna teks dari konstanta aplikasi
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 40.0),  // Margin bawah 40.0
            width: Get.width,  // Lebar container sesuai dengan lebar layar
            alignment: Alignment.center,
            child: Text(
              AppConstant.appPoweredBy,  // Teks Powered by dari konstanta aplikasi
              style: TextStyle(
                  color: AppConstant.appTextColor,  // Warna teks dari konstanta aplikasi
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
