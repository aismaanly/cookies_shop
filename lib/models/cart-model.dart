// ignore_for_file: file_names

// Deklarasi class CartModel
class CartModel {
  // Deklarasi atribut-atribut yang ada dalam CartModel
  final String productId; // ID produk
  final String categoryId; // ID kategori produk
  final String productName; // Nama produk
  final String categoryName; // Nama kategori produk
  final String salePrice; // Harga setelah diskon produk
  final String fullPrice; // Harga full produk
  final List productImages; // Daftar gambar produk
  final String deliveryTime; // Waktu pengiriman produk
  final bool isSale; // Status apakah produk sedang diskon
  final String productDescription; // Deskripsi produk
  final dynamic createdAt; // Waktu pembuatan data (tipe dinamis)
  final dynamic updatedAt; // Waktu pembaruan data (tipe dinamis)
  final int productQuantity; // Jumlah produk dalam keranjang
  final double productTotalPrice; // Total harga produk dalam keranjang

  // Konstruktor untuk menginisialisasi semua atribut
  CartModel({
    required this.productId,
    required this.categoryId,
    required this.productName,
    required this.categoryName,
    required this.salePrice,
    required this.fullPrice,
    required this.productImages,
    required this.deliveryTime,
    required this.isSale,
    required this.productDescription,
    required this.createdAt,
    required this.updatedAt,
    required this.productQuantity,
    required this.productTotalPrice,
  });

  // Fungsi untuk mengonversi objek CartModel menjadi Map (format key-value)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'categoryName': categoryName,
      'salePrice': salePrice,
      'fullPrice': fullPrice,
      'productImages': productImages,
      'deliveryTime': deliveryTime,
      'isSale': isSale,
      'productDescription': productDescription,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'productQuantity': productQuantity,
      'productTotalPrice': productTotalPrice,
    };
  }

  // Factory constructor untuk membuat objek CartModel dari Map
  factory CartModel.fromMap(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImages: List.from(json['productImages']), // Mengonversi ke List
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
    );
  }
}
