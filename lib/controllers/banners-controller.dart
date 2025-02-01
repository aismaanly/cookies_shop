// ignore_for_file: camel_case_types, file_names, unnecessary_overrides, unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Import package untuk mengakses Firestore.
import 'package:get/get.dart'; // Import package GetX untuk state management.

// Definisikan class bannerController yang meng-extend GetxController
class bannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]); // Deklarasi variabel reaktif untuk menyimpan URL banner.

// Override method onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    super.onInit(); // Panggil method onInit dari parent class.
    fetchBannersUrls(); // Panggil fungsi fetchBannersUrls untuk mengambil URL banner saat inisialisasi.
  }

  // Fungsi asinkron untuk mengambil data URL banner dari Firestore
  Future<void> fetchBannersUrls() async {
    try {
      // Mengambil snapshot dari koleksi 'banners' di Firestore
      QuerySnapshot bannersSnapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      // Jika terdapat dokumen dalam snapshot, update bannerUrls dengan data yang diambil
      if (bannersSnapshot.docs.isNotEmpty) {
        bannerUrls.value = bannersSnapshot.docs
            .map((doc) => doc['imageUrl'] as String) // Mapping setiap dokumen ke URL banner.
            .toList(); // Konversi hasil mapping ke dalam bentuk list.
      }
    } catch (e) {
      print("error: $e"); // Menangkap dan mencetak error jika terjadi kesalahan saat pengambilan data.
    }
  }
}
