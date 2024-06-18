// ignore_for_file: file_names, body_might_complete_normally_nullable, unused_field, unused_local_variable

// Import package Cloud Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import model UserModel dari package cookies_shop/models/
import 'package:cookies_shop/models/user-model.dart';
// Import file AppConstant.dart untuk konstanta aplikasi
import 'package:cookies_shop/utils/app-constant.dart';
// Import package Firebase Auth untuk autentikasi pengguna
import 'package:firebase_auth/firebase_auth.dart';
// Import package Flutter EasyLoading untuk menampilkan loading indicator
import 'package:flutter_easyloading/flutter_easyloading.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class SignUpController yang meng-extend GetxController
class SignUpController extends GetxController {
  // Deklarasi variabel _auth dari tipe FirebaseAuth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Deklarasi variabel _firestore dari tipe FirebaseFirestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Variabel isPasswordVisible dari tipe RxBool untuk menampilkan status visibility password
  var isPasswordVisible = false.obs;

  // Fungsi async signUpMethod untuk melakukan proses sign up pengguna
  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPhone,
    String userCity,
    String userPassword,
  ) async {
    try {
      // Menampilkan loading indicator menggunakan Flutter EasyLoading
      EasyLoading.show(status: "Please wait ...");

      // Melakukan sign up dengan email dan password menggunakan FirebaseAuth
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: userEmail,
        password: userPassword,
      );

      // Mengirim email verifikasi ke pengguna yang baru saja sign up
      await userCredential.user!.sendEmailVerification();

      // Membuat objek UserModel dari informasi pengguna
      UserModel userModel = UserModel(
        uId: userCredential.user!.uid,
        username: userName,
        email: userEmail,
        phone: userPhone,
        userImg: '',
        country: '',
        userAddress: '',
        street: '',
        isAdmin: false,
        isActive: true,
        createdOn: DateTime.now(),
        city: userCity,
      );

      // Menyimpan data pengguna ke Firestore dengan menggunakan user.uid sebagai document ID
      await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());

      // Menutup loading indicator setelah sign up berhasil
      EasyLoading.dismiss();

      // Mengembalikan userCredential setelah berhasil sign up
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
