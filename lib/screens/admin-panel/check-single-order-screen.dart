// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:cookies_shop/models/order-model.dart'; // Mengimpor model OrderModel dari order-model.dart
import 'package:cookies_shop/utils/app-constant.dart'; // Mengimpor konstanta aplikasi dari app-constant.dart
import 'package:flutter/material.dart'; // Mengimpor widget-style Material dari Flutter

class CheckSingleOrderScreen extends StatelessWidget {
  OrderModel orderModel; // Deklarasi variabel orderModel bertipe OrderModel
  CheckSingleOrderScreen({
    super.key,
    required this.orderModel, required String docId, // Konstruktor CheckSingleOrderScreen dengan parameter wajib orderModel dan docId
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Scaffold adalah kerangka utama halaman
      appBar: AppBar( // AppBar di bagian atas halaman
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon dengan warna dari konstanta aplikasi
        centerTitle: true, // Posisi judul di tengah AppBar
        title: Text( // Teks judul AppBar
          "Detail Order", // Judul halaman
          style: TextStyle( // Style teks judul
              fontWeight: FontWeight.bold, // Ketebalan teks tebal
              color: AppConstant.appScendoryColor, // Warna teks dari konstanta aplikasi
              fontSize: 20), // Ukuran teks 20
        ),
      ),
      body: Container( // Widget Container sebagai wadah utama konten
        padding: const EdgeInsets.all(15), // Padding 15 pada semua sisi Container
        child: ListView( // ListView untuk menggulirkan konten jika terlalu panjang
          padding: EdgeInsets.all(5), // Padding 5 pada semua sisi ListView
          children: [
            Row( // Widget Row untuk menampilkan gambar produk dalam baris
              mainAxisAlignment: MainAxisAlignment.center, // Posisi teks dalam baris di tengah
              children: [
                CircleAvatar( // Widget CircleAvatar untuk menampilkan gambar produk pertama
                  radius: 50.0, // Radius avatar 50
                  foregroundImage: NetworkImage(orderModel.productImages[0]), // Gambar produk dari URL pertama dalam model pesanan
                ),
                SizedBox(width: 10), // SizedBox untuk spasi horizontal 10
                CircleAvatar( // Widget CircleAvatar untuk menampilkan gambar produk kedua
                  radius: 50.0, // Radius avatar 50
                  foregroundImage: NetworkImage(orderModel.productImages[1]), // Gambar produk dari URL kedua dalam model pesanan
                ),
              ],
            ),
            SizedBox(height: 15), // SizedBox untuk spasi vertikal 15
            _buildOrderInfoBox(context, orderModel), // Memanggil method _buildOrderInfoBox untuk membangun kotak info pesanan
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfoBox(BuildContext context, OrderModel orderModel) {
    return Container( // Widget Container untuk kotak info pesanan
      padding: const EdgeInsets.all(15), // Padding 15 pada semua sisi Container
      width: MediaQuery.of(context).size.width, // Lebar Container sesuai dengan lebar layar perangkat
      decoration: BoxDecoration( // Mendekorasikan Container dengan border radius dan warna latar belakang
        borderRadius: BorderRadius.circular(15), // BorderRadius 15 untuk sudut kotak
        color: AppConstant.appCardColor, // Warna latar belakang dari konstanta aplikasi
      ),
      child: Column( // Widget Column untuk menata widget secara vertikal
        crossAxisAlignment: CrossAxisAlignment.start, // Penyusunan widget start (mulai) dari kiri
        children: [
          _buildInfoRow(Icons.shopping_bag, 'Product Name', orderModel.productName), // Memanggil method _buildInfoRow untuk menampilkan info nama produk
          _buildInfoRow(Icons.price_check, 'Total Price', orderModel.productTotalPrice.toString()), // Memanggil method _buildInfoRow untuk menampilkan info harga total produk
          _buildInfoRow(Icons.production_quantity_limits, 'Quantity', 'x' + orderModel.productQuantity.toString()), // Memanggil method _buildInfoRow untuk menampilkan info jumlah produk
          _buildInfoRow(Icons.description, 'Description', orderModel.productDescription), // Memanggil method _buildInfoRow untuk menampilkan info deskripsi produk
          _buildInfoRow(Icons.person, 'Customer Name', orderModel.customerName), // Memanggil method _buildInfoRow untuk menampilkan info nama pelanggan
          _buildInfoRow(Icons.phone, 'Phone', orderModel.customerPhone), // Memanggil method _buildInfoRow untuk menampilkan info telepon pelanggan
          _buildInfoRow(Icons.home, 'Address', orderModel.customerAddress), // Memanggil method _buildInfoRow untuk menampilkan info alamat pelanggan
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) { // Method untuk membangun baris info dengan icon, judul, dan nilai
    return ListTile( // Widget ListTile untuk menampilkan baris info
      leading: Icon(icon, color: AppConstant.appScendoryColor), // Icon di sebelah kiri dengan warna dari konstanta aplikasi
      title: Text(title), // Teks judul dari info
      subtitle: Text(value), // Teks subjudul dari nilai info
    );
  }
}
