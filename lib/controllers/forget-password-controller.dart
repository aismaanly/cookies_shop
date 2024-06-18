// ignore_for_file: file_names, body_might_complete_normally_nullable, unused_field, unused_local_variable, non_constant_identifier_names, prefer_const_constructors

// Import package Firebase Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import screen LogInScreen dari package cookies_shop/screens/auth-ui/
import 'package:cookies_shop/screens/auth-ui/log-in-screen.dart';
// Import class AppConstant dari package cookies_shop/utils/
import 'package:cookies_shop/utils/app-constant.dart';
// Import package Firebase Auth untuk autentikasi pengguna
import 'package:firebase_auth/firebase_auth.dart';
// Import package Flutter EasyLoading untuk menampilkan loading indicator
import 'package:flutter_easyloading/flutter_easyloading.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class ForgetPasswordController yang meng-extend GetxController
class ForgetPasswordController extends GetxController {
  // Deklarasi variabel _auth dari tipe FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Deklarasi variabel _firestore dari tipe FirebaseFirestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi ForgetPasswordMethod untuk mengirim email reset password
  Future<void> ForgetPasswordMethod(String userEmail) async {
    try {
      // Menampilkan loading indicator menggunakan Flutter EasyLoading
      EasyLoading.show(status: "Please wait ...");

      // Mengirim email reset password menggunakan Firebase Auth
      await _auth.sendPasswordResetEmail(email: userEmail);

      // Menampilkan snackbar untuk informasi sukses pengiriman email
      Get.snackbar(
        "Request Sent Successfully",
        "Password reset link sent to $userEmail",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );

      // Navigasi ke layar LogInScreen setelah pengiriman email berhasil
      Get.offAll(() => LogInScreen());

      // Menutup loading indicator setelah selesai
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      // Menutup loading indicator jika terjadi exception pada Firebase Auth
      EasyLoading.dismiss();
      
      // Menampilkan snackbar untuk informasi error
      Get.snackbar(
        "Error",
        "$e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppConstant.appScendoryColor,
        colorText: AppConstant.appTextColor,
      );
    }
  }
}
