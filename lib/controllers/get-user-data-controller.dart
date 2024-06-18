// ignore_for_file: file_names, unused_field

// Import package Firebase Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class GetUserDataController yang meng-extend GetxController
class GetUserDataController extends GetxController {
  // Deklarasi variabel _firestore dari tipe FirebaseFirestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi async getUserData untuk mendapatkan data pengguna berdasarkan uId
  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {
    // Mengambil data pengguna dari koleksi 'users' dengan kondisi uId sama dengan parameter uId
    final QuerySnapshot userData =
        await _firestore.collection('users').where('uId', isEqualTo: uId).get();
    // Mengembalikan daftar dokumen hasil query
    return userData.docs;
  }
}
