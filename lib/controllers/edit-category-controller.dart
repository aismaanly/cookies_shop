// ignore_for_file: file_names, avoid_print

// Import package Firebase Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import model CategoriesModel
import 'package:cookies_shop/models/categories-model.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class EditCategoryController yang meng-extend GetxController
class EditCategoryController extends GetxController {
  // Deklarasi variabel categoriesModel dari tipe CategoriesModel
  CategoriesModel categoriesModel;
  
  // Constructor untuk menerima categoriesModel sebagai parameter
  EditCategoryController({required this.categoriesModel});
  
  // Deklarasi variabel categoryImg yang merupakan RxString
  // RxString adalah tipe data reaktif dari GetX yang memungkinkan perubahan
  // pada string secara reaktif dan otomatis memperbarui UI yang terkait
  Rx<String> categoryImg = ''.obs;

  // Override metode onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi getRealTimeCategoryImg untuk mengambil gambar kategori secara real-time
    getRealTimeCategoryImg();
  }

  // Fungsi untuk mendapatkan gambar kategori secara real-time dari Firestore
  void getRealTimeCategoryImg() {
    FirebaseFirestore.instance
        .collection('categories')
        .doc(categoriesModel.categoryId)
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      // Jika dokumen ada
      if (snapshot.exists) {
        // Mengambil data dari snapshot
        final data = snapshot.data() as Map<String, dynamic>?;
        // Jika data tidak null dan memiliki field 'categoryImg'
        if (data != null && data['categoryImg'] != null) {
          // Update nilai categoryImg dengan data baru
          categoryImg.value = data['categoryImg'].toString();
          print(categoryImg);
          // Panggil update() untuk memperbarui UI
          update();
        }
      }
    });
  }

  // Fungsi asinkron untuk menghapus gambar dari Firestore
  Future<void> deleteImageFromFireStore(String imageUrl, String categoryId) async {
    try {
      // Mengupdate field 'categoryImg' menjadi string kosong
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .update({'categoryImg': ''});
      // Panggil update() untuk memperbarui UI
      update();
    } catch (e) {
      // Menangkap dan mencetak error jika terjadi masalah saat penghapusan data
      print("Error $e");
    }
  }

  // Fungsi asinkron untuk menghapus seluruh kategori dari Firestore
  Future<void> deleteWholeCategoryFromFireStore(String categoryId) async {
    try {
      // Menghapus dokumen berdasarkan ID kategori
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(categoryId)
          .delete();
      // Panggil update() untuk memperbarui UI
      update();
    } catch (e) {
      // Menangkap dan mencetak error jika terjadi masalah saat penghapusan data
      print("Error $e");
    }
  }
}
