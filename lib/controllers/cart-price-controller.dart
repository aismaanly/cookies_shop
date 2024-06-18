// ignore_for_file: file_names, unnecessary_overrides, unused_local_variable, unnecessary_null_comparison

// Import package untuk Firebase Firestore dan Auth
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class ProductPriceController yang meng-extend GetxController
class ProductPriceController extends GetxController {
  // Deklarasi variabel totalPrice yang merupakan RxDouble
  // RxDouble adalah tipe data reaktif dari GetX yang memungkinkan perubahan
  // pada nilai secara reaktif dan otomatis memperbarui UI yang terkait
  RxDouble totalPrice = 0.0.obs;
  // Mendapatkan pengguna saat ini dari FirebaseAuth
  User? user = FirebaseAuth.instance.currentUser;

  // Override metode onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    // Panggil fungsi fetchProductPrice untuk mengambil harga produk
    fetchProductPrice();
    // Panggil implementasi metode onInit dari superclass (GetxController)
    super.onInit();
  }

  // Fungsi untuk mengambil harga produk dari Firestore
  void fetchProductPrice() async {
    // Mengambil snapshot dari koleksi 'cartOrders' di Firestore untuk pengguna saat ini
    final QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    // Inisialisasi variabel sum untuk menjumlahkan harga total produk
    double sum = 0.0;

    // Iterasi melalui setiap dokumen dalam snapshot
    for (final doc in snapshot.docs) {
      // Mendapatkan data dari dokumen
      final data = doc.data();
      // Jika data tidak null dan mengandung key 'productTotalPrice'
      if (data != null && data.containsKey('productTotalPrice')) {
        // Tambahkan nilai 'productTotalPrice' ke sum
        sum += (data['productTotalPrice'] as num).toDouble();
      }
    }

    // Update nilai totalPrice dengan sum yang telah dihitung
    totalPrice.value = sum;
  }
}
