// Mengimpor paket dan file yang diperlukan
import 'package:cookies_shop/controllers/forget-password-controller.dart'; // Mengimpor controller untuk logika lupa password.
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta yang digunakan di seluruh aplikasi.
import 'package:flutter/material.dart'; // Flutter framework UI widgets.
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart'; // Paket untuk mendeteksi visibilitas keyboard.
import 'package:get/get.dart'; // Library manajemen state GetX.
import 'package:lottie/lottie.dart'; // Paket untuk menampilkan animasi Lottie.

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key}); // Konstruktor untuk widget layar lupa password.

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState(); // Membuat state untuk layar lupa password.
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  // Menginisialisasi ForgetPasswordController menggunakan GetX untuk manajemen state
  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController()); // Instance dari ForgetPasswordController.

  // Controller untuk input email pengguna
  TextEditingController userEmail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // KeyboardVisibilityBuilder untuk menangani perubahan UI saat keyboard muncul atau tidak
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      // Scaffold untuk struktur layar secara keseluruhan
      return Scaffold(
        appBar: AppBar(
          // Menyesuaikan app bar dengan warna tema dan judul
          iconTheme: IconThemeData(color: AppConstant.appScendoryColor),
          centerTitle: true,
          title: Text(
            "Forget Password",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(), // Efek bouncing saat scroll
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: Get.width * 0.4,
                      height: Get.width * 0.4,
                      child: Lottie.asset('assets/splash-icon.json'), // Menampilkan animasi Lottie sebagai ikon splash
                    ),
                  ],
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        "Masukkan alamat email untuk mendapatkan tautan reset password",
                        style: TextStyle(
                          color: AppConstant.appMainColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
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
                      // Field teks untuk memasukkan email
                      controller: userEmail,
                      cursorColor: AppConstant.appScendoryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Masukkan email Anda",
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                      onPressed: () async {
                        // Aksi tombol untuk memulai proses reset password
                        String email = userEmail.text.trim();

                        if (email.isEmpty) {
                          // Menampilkan snackbar error jika email kosong
                          Get.snackbar(
                            "Error",
                            "Silakan masukkan semua detail",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppConstant.appScendoryColor,
                            colorText: AppConstant.appTextColor,
                          );
                        } else {
                          // Memanggil metode forget password dari controller
                          forgetPasswordController.ForgetPasswordMethod(email);
                        }
                      },
                      child: Text(
                        "Forget",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height / 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
