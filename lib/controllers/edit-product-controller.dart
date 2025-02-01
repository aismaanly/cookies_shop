// ignore_for_file: file_names, avoid_print

// Import package Firebase Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import model ProductModel
import 'package:cookies_shop/models/product-model.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class EditProductController yang meng-extend GetxController
class EditProductController extends GetxController {
  // Deklarasi variabel productModel dari tipe ProductModel
  ProductModel productModel;
  
  // Constructor untuk menerima productModel sebagai parameter
  EditProductController({
    required this.productModel,
  });
  
  // Deklarasi variabel images yang merupakan RxList dari String
  // RxList adalah tipe data reaktif dari GetX yang memungkinkan perubahan
  // pada list secara reaktif dan otomatis memperbarui UI yang terkait
  RxList<String> images = <String>[].obs;

  // Override metode onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi getRealTimeImages untuk mengambil gambar produk secara real-time
    getRealTimeImages();
  }

  // Fungsi untuk mendapatkan gambar produk secara real-time dari Firestore
  void getRealTimeImages() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productModel.productId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      // Jika dokumen ada
      if (snapshot.exists) {
        // Mengambil data dari snapshot
        final data = snapshot.data() as Map<String, dynamic>?;
        // Jika data tidak null dan memiliki field 'productImages'
        if (data != null && data['productImages'] != null) {
          // Update nilai images dengan daftar gambar produk yang baru
          images.value = List<String>.from(data['productImages'] as List<dynamic>);
          // Panggil update() untuk memperbarui UI
          update();
        }
      }
    });
  }

  // Fungsi asinkron untuk menghapus gambar dari Firestore
  Future<void> deleteImageFromFireStore(String imageUrl, String productId) async {
    try {
      // Menghapus imageUrl dari array 'productImages' di dokumen produk
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productId)
          .update({
        'productImages': FieldValue.arrayRemove([imageUrl])
      });
      // Panggil update() untuk memperbarui UI
      update();
    } catch (e) {
      // Menangkap dan mencetak error jika terjadi masalah saat penghapusan data
      print("Error $e");
    }
  }
}
