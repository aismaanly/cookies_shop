// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, avoid_print

import 'package:cookies_shop/screens/admin-panel/specific-customer-orders-screen.dart'; // Import layar detail pesanan pelanggan
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema
import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk berinteraksi dengan Firestore
import 'package:flutter/cupertino.dart'; // Import widget dari Cupertino untuk UI
import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:get/get.dart'; // Import package GetX untuk manajemen state

class AdminAllOrdersScreen extends StatelessWidget {
  const AdminAllOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar
        centerTitle: true,
        title: Text(
          "All Orders", // Judul halaman
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('orders')
            .orderBy('createdAt', descending: true)
            .get(), // Mengambil semua dokumen dari koleksi 'orders' diurutkan berdasarkan tanggal pembuatan secara menurun
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              child: Center(
                child: Text('Error occurred while fetching orders!'), // Pesan error jika terjadi kesalahan
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: CupertinoActivityIndicator(), // Indicator loading saat data sedang diambil
              ),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Container(
              child: Center(
                child: Text('No orders found!'), // Pesan jika tidak ada pesanan yang ditemukan
              ),
            );
          }

          if (snapshot.data != null) {
            return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(), // Efek bounce saat scrolling
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];

                return Card(
                  elevation: 5,
                  child: ListTile(
                    onTap: () => Get.to(
                      () => SpecificCustomerOrderScreen(
                        docId: snapshot.data!.docs[index]['uId'], // Mengirimkan ID dokumen ke layar detail pesanan
                        customerName: snapshot.data!.docs[index]
                            ['customerName'], // Mengirimkan nama pelanggan ke layar detail pesanan
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: AppConstant.appMainColor, // Warna background avatar
                      child: Text(
                        data['customerName'][0], // Mengambil huruf pertama dari nama pelanggan
                        style: TextStyle(
                          color: AppConstant.appTextColor, // Warna teks huruf avatar
                          fontSize: 16,
                        ),
                      ),
                    ),
                    title: Text(data['customerName']), // Nama pelanggan sebagai judul ListTile
                    subtitle: Text(data['customerPhone']), // Nomor telepon pelanggan sebagai subtitle ListTile
                  ),
                );
              },
            );
          }

          return Container(); // Kontainer kosong jika snapshot null
        },
      ),
    );
  }
}
