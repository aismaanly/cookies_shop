// ignore_for_file: file_names, body_might_complete_normally_nullable, unused_field, unused_local_variable

// Import package Cloud Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import package Flutter EasyLoading untuk menampilkan loading indicator
import 'package:flutter_easyloading/flutter_easyloading.dart';
// Import package Firebase Auth untuk autentikasi pengguna
import 'package:firebase_auth/firebase_auth.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';
// Import file AppConstant.dart untuk konstanta aplikasi
import 'package:cookies_shop/utils/app-constant.dart';

// Definisikan class SignInController yang meng-extend GetxController
class SignInController extends GetxController {
  // Deklarasi variabel _auth dari tipe FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Deklarasi variabel _firestore dari tipe FirebaseFirestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variabel isPasswordVisible dari tipe RxBool untuk menampilkan status visibility password
  var isPasswordVisible = false.obs;

  // Fungsi async signInMethod untuk melakukan proses sign in pengguna
  Future<UserCredential?> signInMethod(
    String userEmail,
    String userPassword,
  ) async {
    try {
      // Menampilkan loading indicator menggunakan Flutter EasyLoading
      EasyLoading.show(status: "Please wait ...");

      // Melakukan sign in dengan email dan password menggunakan FirebaseAuth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // Menutup loading indicator setelah sign in berhasil
      EasyLoading.dismiss();

      // Mengembalikan userCredential setelah berhasil sign in
      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Menutup loading indicator jika terjadi error
      EasyLoading.dismiss();

      // Menampilkan snackbar dengan pesan error menggunakan GetX
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
