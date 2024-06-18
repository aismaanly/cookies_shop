// ignore_for_file: file_names

import 'dart:math';  // Mengimpor library Dart untuk operasi matematika acak

// Fungsi untuk menghasilkan ID pesanan unik
String generateOrderId() {
  DateTime now = DateTime.now();  // Mendapatkan tanggal dan waktu saat ini

  int randomNumbers = Random().nextInt(99999);  // Menghasilkan angka acak antara 0 dan 99999
  String id = '${now.microsecondsSinceEpoch}_$randomNumbers';  // Menggabungkan timestamp dengan angka acak untuk membuat ID unik

  return id;  // Mengembalikan ID pesanan yang dihasilkan
}
