// ignore_for_file: unnecessary_null_comparison

import 'package:cookies_shop/controllers/log-in-controller.dart'; // Mengimpor controller untuk mengelola log masuk.
import 'package:cookies_shop/screens/auth-ui/forget-password-screen.dart'; // Mengimpor layar untuk pemulihan kata sandi.
import 'package:cookies_shop/screens/auth-ui/sign-up-screen.dart'; // Mengimpor layar untuk pendaftaran pengguna baru.
import 'package:cookies_shop/screens/user-panel/user-main-screen.dart'; // Mengimpor layar utama untuk pengguna yang terautentikasi.
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta yang digunakan di seluruh aplikasi.
import 'package:firebase_auth/firebase_auth.dart'; // Mengimpor layanan otentikasi Firebase.
import 'package:flutter/material.dart'; // Widget UI framework Flutter.
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // Paket untuk mendeteksi visibilitas keyboard.
import 'package:get/get.dart'; // Library manajemen state GetX.
import 'package:lottie/lottie.dart'; // Paket untuk menampilkan animasi Lottie.
import '../../controllers/get-user-data-controller.dart'; // Controller untuk mengambil data pengguna.
import '../admin-panel/admin-main-screen.dart'; // Mengimpor layar untuk panel admin.

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key}); // Konstruktor untuk widget layar login.

  @override
  State<LogInScreen> createState() => _LogInScreenState(); // Membuat state untuk layar login.
}

class _LogInScreenState extends State<LogInScreen> {
  final SignInController signInController = Get.put(SignInController()); // Instance dari SignInController untuk mengelola logika sign-in.
  final GetUserDataController getUserDataController = Get.put(GetUserDataController()); // Instance dari GetUserDataController untuk mengambil data pengguna.
  TextEditingController userEmail = TextEditingController(); // Controller untuk mengelola input email pengguna.
  TextEditingController userPassword = TextEditingController(); // Controller untuk mengelola input password pengguna.

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar.
          title: Text(""), // Judul kosong pada app bar.
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Mengaktifkan efek fisika 'bouncing' saat melakukan scroll.
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: Get.width * 0.4,
                    height: Get.width * 0.4,
                    child: Lottie.asset('assets/splash-icon.json'), // Menampilkan animasi Lottie sebagai ikon splash.
                  ),
                  SizedBox(
                    height: Get.height / 40,
                  ),
                  Text(
                    "Log In",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.appScendoryColor,
                    ),
                  ),
                  SizedBox(
                    height: Get.height / 30,
                  ),
                  Text(
                    "Masukkan email dan password Anda",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppConstant.appMainColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: Get.width,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: userEmail,
                    cursorColor: AppConstant.appScendoryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email",
                      hintText: "Masukkan email Anda",
                      contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppConstant.appScendoryColor),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!), 
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 5.0),
                width: Get.width,
                child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Obx(
                      () => TextFormField(
                        controller: userPassword,
                        obscureText: !signInController.isPasswordVisible.value,
                        cursorColor: AppConstant.appScendoryColor,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password",
                          hintText: "Masukkan password Anda",
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signInController.isPasswordVisible.toggle();
                            },
                            child: signInController.isPasswordVisible.value
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppConstant.appScendoryColor),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!), 
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Get.to(() => ForgetPasswordScreen());
                  },
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(
                        color: AppConstant.appScendoryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              Material(
                child: Container(
                  width: Get.width / 2,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "LOG IN",
                      style: TextStyle(color: AppConstant.appTextColor),
                    ),
                    onPressed: () async {
                      String email = userEmail.text.trim();
                      String password = userPassword.text.trim();

                      if (email.isEmpty || password.isEmpty) {
                        Get.snackbar(
                          "Error",
                          "Silakan masukkan semua detail",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: AppConstant.appScendoryColor,
                          colorText: AppConstant.appTextColor,
                        );
                      } else {
                        UserCredential? userCredential = await signInController.signInMethod(email, password);

                        var userData = await getUserDataController.getUserData(userCredential!.user!.uid);

                        if (userCredential != null) {
                          if (userCredential.user!.emailVerified) {
                            if (userData[0]['isAdmin'] == true) {
                              Get.snackbar(
                                "Sukses Login Admin",
                                "Login Berhasil!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appScendoryColor,
                                colorText: AppConstant.appTextColor,
                              );
                              Get.offAll(() => AdminMainScreen());
                            } else {
                              Get.offAll(() => MainScreen());
                              Get.snackbar(
                                "Sukses Login Pengguna",
                                "Login Berhasil!",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: AppConstant.appScendoryColor,
                                colorText: AppConstant.appTextColor,
                              );
                            }
                          } else {
                            Get.snackbar(
                              "Error",
                              "Harap verifikasi email Anda sebelum login",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: AppConstant.appScendoryColor,
                              colorText: AppConstant.appTextColor,
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Error",
                            "Silakan coba lagi",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appScendoryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        }
                      }
                    },
                  ),
                ),
              ),
              SizedBox(
                height: Get.height / 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? ",
                    style: TextStyle(color: AppConstant.appScendoryColor),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(() => SignUpScreen()),
                    child: Text(
                      "Daftar",
                      style: TextStyle(
                          color: AppConstant.appScendoryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
