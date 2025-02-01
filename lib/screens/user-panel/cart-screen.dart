import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore untuk database.
import 'package:cookies_shop/models/cart-model.dart'; // Model untuk data keranjang.
import 'package:cookies_shop/utils/app-constant.dart'; // Konstanta aplikasi.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication untuk otentikasi pengguna.
import 'package:flutter/cupertino.dart'; // Widget Cupertino untuk gaya iOS.
import 'package:flutter/material.dart'; // Framework Flutter.
import 'package:flutter_swipe_action_cell/core/cell.dart'; // Widget swipe action cell untuk aksi swipe pada list.
import 'package:get/get.dart'; // Manajemen state dengan GetX.

import '../../controllers/cart-price-controller.dart'; // Controller untuk harga produk di keranjang.
import 'checkout-screen.dart'; // Layar checkout untuk proses pembayaran.

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser; // Mendapatkan pengguna saat ini.
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController()); // Controller untuk harga produk.

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(productId)
        .delete(); // Menghapus produk dari keranjang.

    // Periksa apakah keranjang kosong setelah penghapusan
    var snapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    if (snapshot.docs.isEmpty) {
      productPriceController.totalPrice.value = 0; // Setel harga total ke 0 jika keranjang kosong.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon untuk app bar.
        centerTitle: true, // Pusatkan judul di app bar.
        title: Text(
          "Cart", // Teks judul.
          style: TextStyle(
              fontWeight: FontWeight.bold, // Ketebalan teks tebal.
              color: AppConstant.appScendoryColor, // Warna teks judul.
              fontSize: 20), // Ukuran font judul.
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(), // Stream untuk mendapatkan data keranjang.
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"), // Tampilkan teks "Error" jika terjadi kesalahan.
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(), // Indikator aktivitas jika sedang memuat.
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"), // Tampilkan teks "No products found!" jika tidak ada produk.
            );
          }

          if (snapshot.data != null) {
            return Container(
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final productData = snapshot.data!.docs[index];
                  CartModel cartModel = CartModel(
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
                    productTotalPrice: double.parse(
                        productData['productTotalPrice'].toString()),
                  );

                  // Menghitung harga produk
                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete", // Judul aksi hapus.
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          await Get.defaultDialog(
                            title: "Remove Product", // Judul dialog hapus produk.
                            content: const Text(
                                "Are you sure you want to remove this product from your cart?"), // Konten dialog.
                            textCancel: "Cancel", // Teks tombol batal.
                            textConfirm: "Delete", // Teks tombol hapus.
                            contentPadding: const EdgeInsets.all(10.0),
                            confirmTextColor: Colors.white,
                            onCancel: () {}, // Aksi ketika tombol batal ditekan.
                            onConfirm: () async {
                              Get.back();
                              await deleteProduct(cartModel.productId); // Hapus produk dari keranjang.
                            },
                            buttonColor: Colors.red, // Warna tombol hapus.
                            cancelTextColor: Colors.black, // Warna teks tombol batal.
                          );
                        },
                        color: Colors.red, // Warna aksi hapus.
                      ),
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appCardColor, // Warna latar belakang kartu.
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0), // Bentuk kartu dengan sudut melengkung.
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppConstant.appMainColor, // Warna latar belakang avatar.
                              backgroundImage:
                                  NetworkImage(cartModel.productImages[0]), // Gambar produk di avatar.
                              radius: 30, // Radius avatar.
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartModel.productName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Rp.${cartModel.productTotalPrice.toString()}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.brown, // Warna teks harga produk.
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline), // Ikon kurangi produk.
                                  onPressed: () async {
                                    if (cartModel.productQuantity > 1) {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity - 1, // Kurangi jumlah produk.
                                        'productTotalPrice':
                                            (double.parse(cartModel.fullPrice) *
                                                (cartModel.productQuantity - 1))
                                      });
                                    } else {
                                      await Get.defaultDialog(
                                        title: "Remove Product", // Judul dialog hapus produk.
                                        content: const Text(
                                            "Are you sure you want to remove this product from your cart?"), // Konten dialog.
                                        textCancel: "Cancel", // Teks tombol batal.
                                        textConfirm: "Remove", // Teks tombol hapus.
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.red,
                                        cancelTextColor: Colors.black,
                                        onCancel: () {}, // Aksi ketika tombol batal ditekan.
                                        onConfirm: () async {
                                          Get.back();
                                          await deleteProduct(
                                              cartModel.productId); // Hapus produk dari keranjang.
                                        },
                                      );
                                    }
                                  },
                                  color: AppConstant.appScendoryColor, // Warna ikon kurangi produk.
                                ),
                                Text(
                                  cartModel.productQuantity.toString(), // Teks jumlah produk.
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline), // Ikon tambah produk.
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity':
                                          cartModel.productQuantity + 1, // Tambah jumlah produk.
                                      'productTotalPrice':
                                          double.parse(cartModel.fullPrice) *
                                              (cartModel.productQuantity + 1)
                                    });
                                  },
                                  color: AppConstant.appScendoryColor, // Warna ikon tambah produk.
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Container(); // Return container kosong jika tidak ada data.
        },
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            Expanded(
              child: Obx(
                () => Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    "Total : ${productPriceController.totalPrice.value.toStringAsFixed(0)}", // Teks total harga produk di keranjang.
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor, // Warna latar belakang tombol Checkout.
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Checkout", // Teks tombol Checkout.
                      style: TextStyle(
                        color: AppConstant.appTextColor, // Warna teks tombol Checkout.
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => CheckOutScreen()); // Pindah ke layar Checkout.
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
