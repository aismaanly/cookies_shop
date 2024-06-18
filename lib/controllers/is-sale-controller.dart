// ignore_for_file: file_names

// Import package GetX untuk state management
import 'package:get/get.dart';

// Definisikan class IsSaleController yang meng-extend GetxController
class IsSaleController extends GetxController {
  // Deklarasi variabel isSale dari tipe RxBool untuk menyimpan status penjualan
  RxBool isSale = false.obs;

  // Method toggleIsSale untuk mengubah nilai isSale dan memperbarui UI
  void toggleIsSale(bool value) {
    isSale.value = value;
    update();
  }

  // Method setIsSaleOldValue untuk mengatur kembali nilai isSale dan memperbarui UI
  void setIsSaleOldValue(bool value) {
    isSale.value = value;
    update();
  }
}
