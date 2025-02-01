// ignore_for_file: file_names

import 'package:uuid/uuid.dart';//package untuk generate id

// Kelas untuk menghasilkan ID unik untuk produk dan kategori
class GenerateIds {
  // Fungsi untuk menghasilkan ID produk unik
  String generateProductId() {
    String formatedProductId;  // Deklarasi variabel untuk menyimpan ID produk yang diformat
    String uuid = const Uuid().v4();  // Membuat UUID versi 4 (acak)

    // Kustomisasi ID produk dengan mengambil substring dari UUID
    formatedProductId = "cookies-shop-${uuid.substring(0, 5)}";

    // Mengembalikan ID produk yang diformat
    return formatedProductId;
  }

  // Fungsi untuk menghasilkan ID kategori unik
  String generateCategoryId() {
    String formatedCategoryId;  // Deklarasi variabel untuk menyimpan ID kategori yang diformat
    String uuid = const Uuid().v4();  // Membuat UUID versi 4 (acak)

    // Kustomisasi ID kategori dengan mengambil substring dari UUID
    formatedCategoryId = "cookies-shop-${uuid.substring(0, 5)}";

    // Mengembalikan ID kategori yang diformat
    return formatedCategoryId;
  }
}
