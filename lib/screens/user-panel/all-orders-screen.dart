// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart'; // Paket untuk interaksi dengan Firestore.
import 'package:cookies_shop/models/order-model.dart'; // Model data untuk pesanan.
import 'package:cookies_shop/utils/app-constant.dart'; // Konstanta yang digunakan di seluruh aplikasi.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication untuk pengelolaan otentikasi pengguna.
import 'package:flutter/cupertino.dart'; // Widget khusus untuk iOS.
import 'package:flutter/material.dart'; // Framework UI Flutter.
import 'package:get/get.dart'; // Library manajemen state GetX.

import '../../controllers/cart-price-controller.dart'; // Controller untuk harga produk.

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({super.key});

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  User? user = FirebaseAuth.instance.currentUser; // Mendapatkan pengguna saat ini.
  final ProductPriceController productPriceController = Get.put(ProductPriceController()); // Instance dari controller harga produk.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur tema ikon di app bar.
        centerTitle: true, // Mengatur judul di tengah app bar.
        title: Text(
          "All Orders", // Judul pada app bar.
          style: TextStyle(
              fontWeight: FontWeight.bold, // Mengatur tebal font judul.
              color: AppConstant.appScendoryColor, // Mengatur warna teks judul.
              fontSize: 20), // Mengatur ukuran font judul.
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .doc(user!.uid)
            .collection('confirmOrders')
            .snapshots(), // Mendapatkan stream dari koleksi pesanan pengguna yang saat ini login.
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) { // Jika terjadi error dalam stream.
            return Center(
              child: Text("Error"), // Menampilkan teks "Error" di tengah layar.
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) { // Jika masih dalam proses pengambilan data.
            return Container(
              height: Get.height / 5, // Mengatur tinggi container loading.
              child: Center(
                child: CupertinoActivityIndicator(), // Menampilkan indikator loading iOS di tengah layar.
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) { // Jika tidak ada dokumen pesanan yang ditemukan.
            return Center(
              child: Text("No products found!"), // Menampilkan teks "No products found!" di tengah layar.
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length, // Jumlah item dalam ListView sesuai dengan jumlah dokumen pesanan.
                shrinkWrap: true, // Mengatur agar widget hanya menggunakan ruang yang dibutuhkan.
                physics: BouncingScrollPhysics(), // Efek fisika saat melakukan scroll.
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  OrderModel orderModel = OrderModel(
                    productId: productData['productId'],
                    categoryId: productData['categoryId'],
                    productName: productData['productName'],
                    categoryName: productData['categoryName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt'],
                    productQuantity: productData['productQuantity'],
                    productTotalPrice: double.parse(productData['productTotalPrice'].toString()),
                    customerId: productData['customerId'],
                    status: productData['status'],
                    customerName: productData['customerName'],
                    customerPhone: productData['customerPhone'],
                    customerAddress: productData['customerAddress'],
                  );

                  // Menghitung harga
                  productPriceController.fetchProductPrice();

                  return Card(
                    elevation: 5, // Mengatur elevasi bayangan card.
                    color: AppConstant.appCardColor, // Mengatur warna latar belakang card.
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0), // Mengatur border radius card.
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0), // Padding di dalam card.
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: AppConstant.appMainColor, // Mengatur warna latar belakang avatar.
                            backgroundImage: NetworkImage(orderModel.productImages[0]), // Mengatur gambar avatar dari produk.
                            radius: 30, // Mengatur radius avatar.
                          ),
                          SizedBox(width: 10), // Spasi horizontal antara avatar dan teks.
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  orderModel.productName, // Menampilkan nama produk.
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Mengatur tebal font teks.
                                    fontSize: 18, // Mengatur ukuran font teks.
                                  ),
                                ),
                                Text(
                                  "Rp.${orderModel.productTotalPrice.toString()}", // Menampilkan harga total produk.
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold, // Mengatur tebal font teks.
                                    color: Colors.brown, // Mengatur warna teks.
                                  ),
                                ),
                                SizedBox(height: 5), // Spasi vertikal.
                                !orderModel.status
                                    ? Text(
                                        "Pending..", // Menampilkan status "Pending" jika pesanan belum dikirim.
                                        style: TextStyle(color: Colors.green), // Mengatur warna teks.
                                      )
                                    : Text(
                                        "Delivered", // Menampilkan status "Delivered" jika pesanan sudah dikirim.
                                        style: TextStyle(color: Colors.red), // Mengatur warna teks.
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container(); // Mengembalikan container kosong jika tidak ada data.
        },
      ),
    );
  }
}