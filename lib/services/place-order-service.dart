// ignore_for_file: file_names, avoid_print, unused_local_variable, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';  // Import Firestore untuk mengakses layanan database Firestore
import 'package:cookies_shop/models/order-model.dart';  // Import model OrderModel untuk memodelkan data pesanan
import 'package:cookies_shop/screens/user-panel/user-main-screen.dart';  // Import UserMainScreen, halaman utama pengguna
import 'package:cookies_shop/services/genrate-order-id-service.dart';  // Import layanan untuk menghasilkan ID pesanan
import 'package:cookies_shop/utils/app-constant.dart';  // Import konstanta aplikasi seperti warna dan teks
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Authentication untuk otentikasi pengguna
import 'package:flutter/material.dart';  // Import material.dart untuk komponen UI Flutter
import 'package:flutter_easyloading/flutter_easyloading.dart';  // Import package Flutter EasyLoading untuk menampilkan loading indicator
import 'package:get/get.dart';  // Import GetX untuk manajemen state dan navigasi aplikasi

void placeOrder({
  required BuildContext context,
  required String customerName,
  required String customerPhone,
  required String customerAddress,
}) async {
  final user = FirebaseAuth.instance.currentUser;  // Mendapatkan instance pengguna saat ini dari Firebase Authentication
  EasyLoading.show(status: "Please Wait..");  // Menampilkan loading indicator
  
  if (user != null) {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .get();  // Mengambil semua produk dalam keranjang pengguna

      List<QueryDocumentSnapshot> documents = querySnapshot.docs;  // Mengambil dokumen-dokumen hasil query

      for (var doc in documents) {
        Map<String, dynamic>? data = doc.data() as Map<String, dynamic>;  // Mendapatkan data produk dari dokumen

        String orderId = generateOrderId();  // Menghasilkan ID pesanan baru

        OrderModel cartModel = OrderModel(  // Membuat model OrderModel dari data produk dalam keranjang
          productId: data['productId'],
          categoryId: data['categoryId'],
          productName: data['productName'],
          categoryName: data['categoryName'],
          salePrice: data['salePrice'],
          fullPrice: data['fullPrice'],
          productImages: data['productImages'],
          deliveryTime: data['deliveryTime'],
          isSale: data['isSale'],
          productDescription: data['productDescription'],
          createdAt: DateTime.now(),
          updatedAt: data['updatedAt'],
          productQuantity: data['productQuantity'],
          productTotalPrice: double.parse(data['productTotalPrice'].toString()),
          customerId: user.uid,
          status: false,
          customerName: customerName,
          customerPhone: customerPhone,
          customerAddress: customerAddress,
        );

        for (var x = 0; x < documents.length; x++) {
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .set(
            {
              'uId': user.uid,
              'customerName': customerName,
              'customerPhone': customerPhone,
              'customerAddress': customerAddress,
              'orderStatus': false,
              'createdAt': DateTime.now()
            },
          );  // Menyimpan data pesanan dalam koleksi 'orders'

          // Upload pesanan konfirmasi ke dalam koleksi 'confirmOrders'
          await FirebaseFirestore.instance
              .collection('orders')
              .doc(user.uid)
              .collection('confirmOrders')
              .doc(orderId)
              .set(cartModel.toMap());

          // Menghapus produk dari keranjang setelah dipesan
          await FirebaseFirestore.instance
              .collection('cart')
              .doc(user.uid)
              .collection('cartOrders')
              .doc(cartModel.productId.toString())
              .delete()
              .then((value) {
            print('Delete cart Products $cartModel.productId.toString()');
          });
        }
      }

      print("Order Confirmed");  // Pesanan berhasil dikonfirmasi
      Get.snackbar(
        "Order Confirmed",  // Tampilan snackbar untuk konfirmasi pesanan
        "Thank you for your order!",
        backgroundColor: AppConstant.appScendoryColor,
        colorText: Colors.white,
        duration: Duration(seconds: 5),
      );

      EasyLoading.dismiss();  // Menutup loading indicator setelah pesanan dikonfirmasi
      Get.offAll(() => MainScreen());  // Navigasi kembali ke halaman utama
    } catch (e) {
      print("error $e");  // Menampilkan pesan error jika terjadi kesalahan
    }
  }
}
