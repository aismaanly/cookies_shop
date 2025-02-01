// ignore_for_file: file_names, unused_field

// Import package dart:async untuk StreamSubscription
import 'dart:async';

// Import package Firebase Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class GetUserLengthController yang meng-extend GetxController
class GetUserLengthController extends GetxController {
  // Deklarasi variabel _firestore dari tipe FirebaseFirestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Deklarasi variabel _userControllerSubscription dari tipe StreamSubscription
  late StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _userControllerSubscription;

  // Deklarasi variabel userCollectionLength dari tipe Rx<int> untuk menyimpan jumlah pengguna
  final Rx<int> userCollectionLength = Rx<int>(0);

  // Override metode onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    super.onInit();
    // Menginisialisasi _userControllerSubscription untuk mendengarkan perubahan pada collection 'users'
    _userControllerSubscription = _firestore
        .collection('users')
        .where('isAdmin', isEqualTo: false)
        .snapshots()
        .listen((snapshot) {
      // Mengupdate nilai userCollectionLength dengan jumlah dokumen snapshot
      userCollectionLength.value = snapshot.size;
    });
  }

  // Override metode onClose untuk membatalkan langganan _userControllerSubscription saat controller ditutup
  @override
  void onClose() {
    _userControllerSubscription.cancel();
    super.onClose();
  }
}
