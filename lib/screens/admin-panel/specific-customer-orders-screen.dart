// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore untuk database
import 'package:flutter/cupertino.dart'; // Import Cupertino widgets
import 'package:flutter/material.dart'; // Import material design widgets
import 'package:get/get.dart'; // Import GetX untuk manajemen state
import '../../models/order-model.dart'; // Import model OrderModel
import 'check-single-order-screen.dart'; // Import halaman untuk memeriksa pesanan

class SpecificCustomerOrderScreen extends StatelessWidget { // Kelas layar untuk menampilkan pesanan spesifik pelanggan
  String docId; // ID dokumen pesanan
  String customerName; // Nama pelanggan

  SpecificCustomerOrderScreen({ // Konstruktor dengan parameter wajib
    super.key,
    required this.docId,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Widget utama sebagai kerangka layar
      appBar: AppBar( // AppBar di bagian atas layar
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon
        centerTitle: true, // Posisi judul di tengah
        title: Text( // Teks judul
          customerName, // Judul adalah nama pelanggan
          style: TextStyle( // Gaya teks judul
            fontWeight: FontWeight.bold,
            color: AppConstant.appScendoryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder( // Widget untuk membangun UI berdasarkan Future
        future: FirebaseFirestore.instance // Future untuk mendapatkan data pesanan dari Firestore
            .collection('orders')
            .doc(docId)
            .collection('confirmOrders')
            .orderBy('createdAt', descending: true)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) { // Builder untuk membangun UI berdasarkan status snapshot
          if (snapshot.hasError) { // Jika terjadi error saat fetching data
            return Container( // Tampilkan pesan error
              child: const Center(
                child: Text('Error occurred while fetching orders!'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) { // Saat data masih dalam proses fetching
            return Container( // Tampilkan indikator loading
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) { // Jika tidak ada pesanan yang ditemukan
            return Container( // Tampilkan pesan tidak ada pesanan
              child: const Center(
                child: Text('No orders found!'),
              ),
            );
          }

          if (snapshot.data != null) { // Jika ada data yang ditemukan
            return ListView.builder( // ListView untuk menampilkan daftar pesanan
              shrinkWrap: true, // Mengikat ListView sesuai dengan konten
              physics: const BouncingScrollPhysics(), // Efek animasi saat scrolling
              itemCount: snapshot.data!.docs.length, // Jumlah item berdasarkan data snapshot
              itemBuilder: (context, index) { // Membangun setiap item di ListView
                final data = snapshot.data!.docs[index]; // Data pesanan dari snapshot
                String orderDocId = data.id; // ID dokumen pesanan
                OrderModel orderModel = OrderModel( // Model OrderModel untuk data pesanan
                  categoryId: data['categoryId'],
                  categoryName: data['categoryName'],
                  createdAt: data['createdAt'],
                  customerAddress: data['customerAddress'],
                  customerId: data['customerId'],
                  customerName: data['customerName'],
                  customerPhone: data['customerPhone'],
                  deliveryTime: data['deliveryTime'],
                  fullPrice: data['fullPrice'],
                  isSale: data['isSale'],
                  productDescription: data['productDescription'],
                  productId: data['productId'],
                  productImages: data['productImages'],
                  productName: data['productName'],
                  productQuantity: data['productQuantity'],
                  productTotalPrice: data['productTotalPrice'],
                  salePrice: data['salePrice'],
                  status: data['status'],
                  updatedAt: data['updatedAt'],
                );

                return Card( // Widget Card untuk menampilkan setiap pesanan
                  elevation: 5, // Elevasi bayangan di Card
                  child: ListTile( // Widget ListTile untuk tampilan item pesanan
                    onTap: () => Get.to( // Aksi saat item pesanan diklik untuk detail pesanan
                      () => CheckSingleOrderScreen(
                        docId: snapshot.data!.docs[index].id,
                        orderModel: orderModel,
                      ),
                    ),
                    leading: CircleAvatar( // Avatar lingkaran di bagian kiri
                      backgroundColor: AppConstant.appMainColor, // Warna latar belakang avatar
                      child: Text( // Teks di dalam avatar
                        orderModel.customerName[0], // Inisial nama pelanggan
                        style: TextStyle( // Gaya teks inisial
                          color: AppConstant.appTextColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(data['customerName']), // Judul ListTile adalah nama pelanggan
                    subtitle: Text(orderModel.productName), // Subjudul ListTile adalah nama produk
                    trailing: GestureDetector( // Widget trailing dengan aksi onTap
                      onTap: () {
                        showBottomSheet( // Menampilkan bottom sheet untuk mengubah status pesanan
                          userDocId: docId,
                          orderModel: orderModel,
                          orderDocId: orderDocId,
                        );
                      },
                      child: Icon(Icons.edit), // Ikon edit di trailing
                    ),
                  ),
                );
              },
            );
          }

          return Container(); // Kontainer kosong jika tidak ada data
        },
      ),
    );
  }

  void showBottomSheet({ // Metode untuk menampilkan bottom sheet
    required String userDocId, // ID dokumen pengguna
    required OrderModel orderModel, // Model OrderModel untuk pesanan
    required String orderDocId, // ID dokumen pesanan
  }) {
    Get.bottomSheet( // Menampilkan bottom sheet dengan GetX
      Container( // Kontainer bottom sheet
        height: Get.height * 0.35, // Tinggi kontainer
        decoration: BoxDecoration( // Dekorasi kontainer
          color: Colors.white, // Warna latar belakang putih
          borderRadius: BorderRadius.circular(20.0), // Border radius 20.0
        ),
        child: Column( // Kolom di dalam kontainer
          mainAxisAlignment: MainAxisAlignment.center, // Posisi teks di tengah
          crossAxisAlignment: CrossAxisAlignment.center, // Posisi teks di tengah
          children: [
            Row( // Baris dalam kolom
              mainAxisAlignment: MainAxisAlignment.center, // Posisi elemen di tengah
              children: [
                Padding( // Padding untuk tombol Pending
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton( // Tombol Elevated untuk Pending
                    onPressed: () async { // Aksi saat tombol ditekan
                      await FirebaseFirestore.instance // Mengubah status pesanan menjadi Pending di Firestore
                          .collection('orders')
                          .doc(userDocId)
                          .collection('confirmOrders')
                          .doc(orderDocId)
                          .update({
                        'status': false,
                      });

                      Get.back(); // Menutup bottom sheet setelah update
                      Get.snackbar( // Menampilkan snackbar notifikasi
                        "Order Status Updated", // Judul snackbar
                        "Order set to Pending", // Pesan snackbar
                        snackPosition: SnackPosition.BOTTOM, // Posisi snackbar di bawah
                        backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang snackbar
                        colorText: AppConstant.appTextColor, // Warna teks snackbar
                      );
                    },
                    style: ElevatedButton.styleFrom( // Gaya tombol ElevatedButton
                      backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang tombol
                      padding: EdgeInsets.all(20.0), // Padding tombol
                    ),
                    child: Text( // Teks di dalam tombol
                      'Pending', // Teks tombol untuk Pending
                      style: TextStyle(color: Colors.white), // Warna teks putih
                    ),
                  ),
                ),
                Padding( // Padding untuk tombol Delivered
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton( // Tombol Elevated untuk Delivered
                    onPressed: () async { // Aksi saat tombol ditekan
                      await FirebaseFirestore.instance // Mengubah status pesanan menjadi Delivered di Firestore
                          .collection('orders')
                          .doc(userDocId)
                          .collection('confirmOrders')
                          .doc(orderDocId)
                          .update({
                        'status': true,
                      });

                      Get.back(); // Menutup bottom sheet setelah update
                      Get.snackbar( // Menampilkan snackbar notifikasi
                        "Order Status Updated", // Judul snackbar
                        "Order set to Delivered", // Pesan snackbar
                        snackPosition: SnackPosition.BOTTOM, // Posisi snackbar di bawah
                        backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang snackbar
                        colorText: AppConstant.appTextColor, // Warna teks snackbar
                      );
                    },
                    style: ElevatedButton.styleFrom( // Gaya tombol ElevatedButton
                      backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang tombol
                      padding: EdgeInsets.all(20.0), // Padding tombol
                    ),
                    child: Text( // Teks di dalam tombol
                      'Delivered', // Teks tombol untuk Delivered
                      style: TextStyle(color: Colors.white), // Warna teks putih
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
