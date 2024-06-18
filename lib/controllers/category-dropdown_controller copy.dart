// Import package GetX untuk state management
import 'package:get/get.dart';
// Import Firebase Firestore package untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';

// Definisikan class CategoryDropDownController yang meng-extend GetxController
class CategoryDropDownController extends GetxController {
  // Deklarasi variabel categories yang merupakan RxList dari Map<String, dynamic>
  // RxList adalah tipe data reaktif dari GetX yang memungkinkan perubahan
  // pada list secara reaktif dan otomatis memperbarui UI yang terkait
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // Deklarasi variabel untuk menyimpan ID dan nama kategori yang dipilih
  RxString? selectedCategoryId;
  RxString? selectedCategoryName;

  // Override metode onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    // Panggil implementasi metode onInit dari superclass (GetxController)
    super.onInit();
    // Panggil fungsi fetchCategories untuk mengambil data kategori
    fetchCategories();
  }

  // Fungsi asinkron untuk mengambil data kategori dari Firestore
  Future<void> fetchCategories() async {
    try {
      // Mengambil snapshot dari koleksi 'categories' di Firestore
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      // Membuat list sementara untuk menyimpan data kategori
      List<Map<String, dynamic>> categoriesList = [];

      // Iterasi melalui setiap dokumen dalam snapshot
      querySnapshot.docs
          .forEach((DocumentSnapshot<Map<String, dynamic>> document) {
        // Tambahkan data kategori ke list sementara
        categoriesList.add({
          'categoryId': document.id,
          'categoryName': document['categoryName'],
          'categoryImg': document['categoryImg'],
        });
      });

      // Update nilai categories dengan list yang telah dibuat
      categories.value = categoriesList;
      print(categories);
      // Panggil update() untuk memperbarui UI
      update();
    } catch (e) {
      // Menangkap dan mencetak error jika terjadi masalah saat pengambilan data
      print("Error fetching categories: $e");
    }
  }

  // Fungsi untuk mengatur kategori yang dipilih berdasarkan ID
  void setSelectedCategory(String? categoryId) {
    // Mengubah nilai selectedCategoryId menjadi nilai baru
    selectedCategoryId = categoryId?.obs;
    print('selectedCategoryId $selectedCategoryId');
    // Panggil update() untuk memperbarui UI
    update();
  }

  // Fungsi untuk mengambil nama kategori berdasarkan ID kategori
  Future<String?> getCategoryName(String? categoryId) async {
    try {
      // Akses dokumen dalam koleksi 'categories' berdasarkan ID kategori
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('categories')
          .doc(categoryId)
          .get();

      // Ekstrak nama kategori dari snapshot
      if (snapshot.exists) {
        return snapshot.data()?['categoryName'];
      } else {
        return null;
      }
    } catch (e) {
      // Menangkap dan mencetak error jika terjadi masalah saat pengambilan data
      print("Error fetching category name: $e");
      return null;
    }
  }

  // Fungsi untuk mengatur nama kategori yang dipilih
  void setSelectedCategoryName(String? categoryName) {
    // Mengubah nilai selectedCategoryName menjadi nilai baru
    selectedCategoryName = categoryName?.obs;
    print('selectedCategoryName $selectedCategoryName');
    // Panggil update() untuk memperbarui UI
    update();
  }

  // Fungsi untuk mengatur nilai lama kategori yang dipilih berdasarkan ID
  void setOldValue(String? categoryId) {
    // Mengubah nilai selectedCategoryId menjadi nilai baru
    selectedCategoryId = categoryId?.obs;
    print('selectedCategoryId $selectedCategoryId');
    // Panggil update() untuk memperbarui UI
    update();
  }
}
