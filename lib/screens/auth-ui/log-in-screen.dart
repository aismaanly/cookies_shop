// ignore_for_file: unnecessary_null_comparison

import 'package:cookies_shop/controllers/log-in-controller.dart'; // Import kontroler untuk mengelola proses masuk.
import 'package:cookies_shop/screens/auth-ui/forget-password-screen.dart'; // Import layar untuk pemulihan kata sandi.
import 'package:cookies_shop/screens/auth-ui/sign-up-screen.dart'; // Import layar untuk pendaftaran pengguna baru.
import 'package:cookies_shop/screens/user-panel/user-main-screen.dart'; // Import layar utama untuk pengguna yang terautentikasi.
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta yang digunakan di seluruh aplikasi.
import 'package:firebase_auth/firebase_auth.dart'; // Import layanan otentikasi Firebase.
import 'package:flutter/material.dart'; // Framework UI Flutter.
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // Paket untuk mendeteksi visibilitas keyboard.
import 'package:get/get.dart'; // Library manajemen state GetX.
import 'package:lottie/lottie.dart'; // Paket untuk menampilkan animasi Lottie.
import '../../controllers/get-user-data-controller.dart'; // Import kontroler untuk mengambil data pengguna.
import '../admin-panel/admin-main-screen.dart'; // Import layar untuk panel admin.

class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key}); // Konstruktor untuk widget layar login.

  @override
  State<LogInScreen> createState() => _LogInScreenState(); // Membuat state untuk layar login.
}

class _LogInScreenState extends State<LogInScreen> {
  final SignInController signInController = Get.put(SignInController()); // Instance dari SignInController untuk mengelola logika masuk.
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
                      labelText: "Email", // Label untuk input email.
                      hintText: "Masukkan email Anda", // Hint text untuk input email.
                      contentPadding: EdgeInsets.only(top: 2.0, left: 8.0), // Padding konten input.
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0), // Mengatur border radius input.
                      ),
                      filled: true, // Mengisi background input dengan warna abu-abu.
                      fillColor: Colors.grey[200], // Warna background input.
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppConstant.appScendoryColor), // Mengatur border saat input mendapatkan fokus.
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[400]!), // Mengatur border saat input tidak mendapatkan fokus.
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
                        obscureText: !signInController.isPasswordVisible.value, // Menyembunyikan atau menampilkan teks password.
                        cursorColor: AppConstant.appScendoryColor,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          labelText: "Password", // Label untuk input password.
                          hintText: "Masukkan password Anda", // Hint text untuk input password.
                          suffixIcon: GestureDetector(
                            onTap: () {
                              signInController.isPasswordVisible.toggle(); // Mengubah visibilitas password saat ikon ditekan.
                            },
                            child: signInController.isPasswordVisible.value
                                ? Icon(Icons.visibility) // Icon untuk menampilkan password.
                                : Icon(Icons.visibility_off), // Icon untuk menyembunyikan password.
                          ),
                          contentPadding: EdgeInsets.only(top: 2.0, left: 8.0), // Padding konten input.
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0), // Mengatur border radius input.
                          ),
                          filled: true, // Mengisi background input dengan warna abu-abu.
                          fillColor: Colors.grey[200], // Warna background input.
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppConstant.appScendoryColor), // Mengatur border saat input mendapatkan fokus.
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[400]!), // Mengatur border saat input tidak mendapatkan fokus.
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
                    Get.to(() => ForgetPasswordScreen()); // Mengarahkan ke layar pemulihan kata sandi saat teks "Lupa Password?" ditekan.
                  },
                  child: Text(
                    "Lupa Password?", // Teks untuk memulai proses pemulihan kata sandi.
                    style: TextStyle(
                        color: AppConstant.appScendoryColor, // Warna teks.
                        fontWeight: FontWeight.bold), // Mengatur tebal teks.
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
                    color: AppConstant.appScendoryColor, // Mengatur warna background tombol "LOG IN".
                    borderRadius: BorderRadius.circular(20.0), // Mengatur border radius tombol "LOG IN".
                  ),
                  child: TextButton(
                    child: Text(
                      "LOG IN", // Teks pada tombol "LOG IN".
                      style: TextStyle(color: AppConstant.appTextColor), // Mengatur warna teks tombol "LOG IN".
                    ),
                    onPressed: () async {
                      String email = userEmail.text.trim(); // Mengambil nilai teks email dan menghapus spasi di awal dan akhir.
                      String password = userPassword.text.trim(); // Mengambil nilai teks password dan menghapus spasi di awal dan akhir.

                      if (email.isEmpty || password.isEmpty) { // Memeriksa apakah email atau password kosong.
                        Get.snackbar(
                          "Error", // Judul snackbar untuk kesalahan.
                          "Silakan masukkan semua detail", // Pesan pada snackbar untuk informasi detail yang kurang.
                          snackPosition: SnackPosition.BOTTOM, // Mengatur posisi snackbar di bagian bawah layar.
                          backgroundColor: AppConstant.appScendoryColor, // Mengatur warna background snackbar.
                          colorText: AppConstant.appTextColor, // Mengatur warna teks pada snackbar.
                        );
                      } else {
                        UserCredential? userCredential = await signInController.signInMethod(email, password); // Memanggil metode sign-in dari controller.

                        var userData = await getUserDataController.getUserData(userCredential!.user!.uid); // Mengambil data pengguna berdasarkan UID.

                        if (userCredential != null) { // Jika credentials pengguna tidak null.
                          if (userCredential.user!.emailVerified) { // Jika email pengguna sudah terverifikasi.
                            if (userData[0]['isAdmin'] == true) { // Jika pengguna adalah admin.
                              Get.snackbar(
                                "Sukses Login Admin", // Judul snackbar untuk login admin berhasil.
                                "Login Berhasil!", // Pesan pada snackbar untuk informasi login berhasil.
                                snackPosition: SnackPosition.BOTTOM, // Mengatur posisi snackbar di bagian bawah layar.
                                backgroundColor: AppConstant.appScendoryColor, // Mengatur warna background snackbar.
                                colorText: AppConstant.appTextColor, // Mengatur warna teks pada snackbar.
                              );
                              Get.offAll(() => AdminMainScreen()); // Mengarahkan ke layar utama admin setelah login.
                            } else {
                              Get.offAll(() => MainScreen()); // Mengarahkan ke layar utama pengguna setelah login.
                              Get.snackbar(
                                "Sukses Login Pengguna", // Judul snackbar untuk login pengguna berhasil.
                                "Login Berhasil!", // Pesan pada snackbar untuk informasi login berhasil.
                                snackPosition: SnackPosition.BOTTOM, // Mengatur posisi snackbar di bagian bawah layar.
                                backgroundColor: AppConstant.appScendoryColor, // Mengatur warna background snackbar.
                                colorText: AppConstant.appTextColor, // Mengatur warna teks pada snackbar.
                              );
                            }
                          } else {
                            Get.snackbar(
                              "Error", // Judul snackbar untuk kesalahan.
                              "Harap verifikasi email Anda sebelum login", // Pesan pada snackbar untuk meminta verifikasi email.
                              snackPosition: SnackPosition.BOTTOM, // Mengatur posisi snackbar di bagian bawah layar.
                              backgroundColor: AppConstant.appScendoryColor, // Mengatur warna background snackbar.
                              colorText: AppConstant.appTextColor, // Mengatur warna teks pada snackbar.
                            );
                          }
                        } else {
                          Get.snackbar(
                            "Error", // Judul snackbar untuk kesalahan.
                            "Silakan coba lagi", // Pesan pada snackbar untuk meminta pengguna untuk mencoba lagi.
                            snackPosition: SnackPosition.BOTTOM, // Mengatur posisi snackbar di bagian bawah layar.
                            backgroundColor: AppConstant.appScendoryColor, // Mengatur warna background snackbar.
                            colorText: AppConstant.appTextColor, // Mengatur warna teks pada snackbar.
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
                    "Belum punya akun? ", // Teks untuk informasi pengguna yang belum memiliki akun.
                    style: TextStyle(color: AppConstant.appScendoryColor), // Mengatur warna teks.
                  ),
                  GestureDetector(
                    onTap: () => Get.offAll(() => SignUpScreen()), // Mengarahkan ke layar pendaftaran pengguna baru saat teks "Daftar" ditekan.
                    child: Text(
                      "Daftar", // Teks untuk memulai proses pendaftaran.
                      style: TextStyle(
                          color: AppConstant.appScendoryColor, // Warna teks.
                          fontWeight: FontWeight.bold), // Mengatur tebal teks.
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
