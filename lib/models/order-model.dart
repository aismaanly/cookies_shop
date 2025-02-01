// ignore_for_file: file_names

// Deklarasi kelas OrderModel
class OrderModel {
  // Deklarasi atribut-atribut dalam OrderModel
  final String productId; // ID produk
  final String categoryId; // ID kategori
  final String productName; // Nama produk
  final String categoryName; // Nama kategori
  final String salePrice; // Harga setelah diskon produk
  final String fullPrice; // Harga penuh produk
  final List productImages; // Daftar gambar produk
  final String deliveryTime; // Waktu pengiriman
  final bool isSale; // Status apakah produk sedang dijual
  final String productDescription; // Deskripsi produk
  final dynamic createdAt; // Waktu pembuatan
  final dynamic updatedAt; // Waktu pembaruan
  final int productQuantity; // Jumlah produk
  final double productTotalPrice; // Total harga produk
  final String customerId; // ID pelanggan
  final bool status; // Status pesanan
  final String customerName; // Nama pelanggan
  final String customerPhone; // Nomor telepon pelanggan
  final String customerAddress; // Alamat pelanggan

  // Konstruktor untuk menginisialisasi semua atribut
  OrderModel({
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
    required this.customerId,
    required this.status,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
  });

  // Metode untuk mengonversi objek OrderModel menjadi map
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
      'customerId': customerId,
      'status': status,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
    };
  }

  // Factory constructor untuk membuat objek OrderModel dari map
  factory OrderModel.fromMap(Map<String, dynamic> json) {
    return OrderModel(
      productId: json['productId'],
      categoryId: json['categoryId'],
      productName: json['productName'],
      categoryName: json['categoryName'],
      salePrice: json['salePrice'],
      fullPrice: json['fullPrice'],
      productImages: json['productImages'],
      deliveryTime: json['deliveryTime'],
      isSale: json['isSale'],
      productDescription: json['productDescription'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      productQuantity: json['productQuantity'],
      productTotalPrice: json['productTotalPrice'],
      customerId: json['customerId'],
      status: json['status'],
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerAddress: json['customerAddress'],
    );
  }
}
