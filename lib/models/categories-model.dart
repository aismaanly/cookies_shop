// ignore_for_file: file_names

// Deklarasi class CategoriesModel
class CategoriesModel {
  // Deklarasi atribut-atribut yang ada dalam CategoriesModel
  final String categoryId; // ID kategori
  final String categoryImg; // Gambar kategori
  final String categoryName; // Nama kategori
  final dynamic createdAt; // Waktu pembuatan data (tipe dinamis)

  // Konstruktor untuk menginisialisasi semua atribut
  CategoriesModel({
    required this.categoryId,
    required this.categoryImg,
    required this.categoryName,
    required this.createdAt,
  });

  // Fungsi untuk mengonversi objek CategoriesModel menjadi Map (format key-value)
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryImg': categoryImg,
      'categoryName': categoryName,
      'createdAt': createdAt,
    };
  }

  // Factory constructor untuk membuat objek CategoriesModel dari Map
  factory CategoriesModel.fromMap(Map<String, dynamic> json) {
    return CategoriesModel(
      categoryId: json['categoryId'],
      categoryImg: json['categoryImg'],
      categoryName: json['categoryName'],
      createdAt: json['createdAt'],
    );
  }
}
