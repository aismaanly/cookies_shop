// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sized_box_for_whitespace, avoid_print, unused_local_variable, use_build_context_synchronously
import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore untuk database.
import 'package:cookies_shop/controllers/cart-price-controller.dart'; // Controller untuk harga produk di keranjang.
import 'package:cookies_shop/models/cart-model.dart'; // Model untuk data keranjang.
import 'package:cookies_shop/services/place-order-service.dart'; // Service untuk menempatkan pesanan.
import 'package:cookies_shop/utils/app-constant.dart'; // Konstanta aplikasi.
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Authentication untuk otentikasi pengguna.
import 'package:flutter/cupertino.dart'; // Widget Cupertino untuk gaya iOS.
import 'package:flutter/material.dart'; // Framework Flutter.
import 'package:flutter_easyloading/flutter_easyloading.dart'; // Paket Flutter EasyLoading untuk menampilkan pesan loading.
import 'package:flutter_swipe_action_cell/core/cell.dart'; // Widget swipe action cell untuk aksi swipe pada list.
import 'package:get/get.dart'; // Manajemen state dengan GetX.
import 'package:http/http.dart' as http; // Paket HTTP untuk permintaan ke server.

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({super.key});

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  User? user = FirebaseAuth.instance.currentUser; // Mendapatkan pengguna saat ini.
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController()); // Controller untuk harga produk.
  TextEditingController nameController = TextEditingController(); // Controller untuk input nama.
  TextEditingController phoneController = TextEditingController(); // Controller untuk input nomor telepon.
  TextEditingController addressController = TextEditingController(); // Controller untuk input alamat.

  // Fungsi untuk mengambil QR code dari server eksternal.
  Future<String> fetchQrCode() async {
    final response = await http.get(Uri.parse(
        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Example'));

    if (response.statusCode == 200) {
      return 'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=Example';
    } else {
      throw Exception('Failed to load QR code');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema ikon untuk app bar.
        centerTitle: true, // Pusatkan judul di app bar.
        title: Text(
          "Checkout", // Teks judul.
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

                  //calculate price
                  productPriceController.fetchProductPrice();
                  return SwipeActionCell(
                    key: ObjectKey(cartModel.productId),
                    trailingActions: [
                      SwipeAction(
                        title: "Delete", // Judul aksi hapus.
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          print('deleted'); // Cetak pesan "deleted" ketika aksi hapus dipicu.

                          await FirebaseFirestore.instance
                              .collection('cart')
                              .doc(user!.uid)
                              .collection('cartOrders')
                              .doc(cartModel.productId)
                              .delete(); // Hapus produk dari keranjang.
                        },
                      )
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Obx(
                () => Text(
                  "Total : ${productPriceController.totalPrice.value.toStringAsFixed(0)}", // Teks total harga produk di keranjang.
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
            Spacer(), // Spacer untuk memberi ruang di antara elemen.
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                child: Container(
                  width: Get.width / 2.0,
                  height: Get.height / 18,
                  decoration: BoxDecoration(
                    color: AppConstant.appScendoryColor, // Warna latar belakang tombol Confirm Order.
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Confirm Order", // Teks tombol Confirm Order.
                      style: TextStyle(
                        color: AppConstant.appTextColor, // Warna teks tombol Confirm Order.
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      showCustomBottomSheet(); // Tampilkan bottom sheet kustom saat tombol Confirm Order ditekan.
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

  // Fungsi untuk menampilkan bottom sheet kustom dengan QR code dan formulir order.
  void showCustomBottomSheet() async {
    String qrCodeUrl = await fetchQrCode(); // Ambil QR code dari fungsi fetchQrCode.
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8, // Tinggi bottom sheet 80% dari tinggi layar.
        decoration: BoxDecoration(
          color: Colors.white, // Warna latar belakang bottom sheet putih.
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(16.0), // Border radius bagian atas dengan sudut melengkung.
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Payment', // Teks judul "Payment".
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Image.network(qrCodeUrl), // Tampilkan QR code dari URL yang didapat.
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name', // Label untuk input nama.
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: phoneController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone', // Label untuk input nomor telepon.
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Address', // Label untuk input alamat.
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      phoneController.text.isNotEmpty &&
                      addressController.text.isNotEmpty) {
                    String name = nameController.text.trim();
                    String phone = phoneController.text.trim();
                    String address = addressController.text.trim();

                    // Panggil fungsi place order dengan parameter yang diperlukan.
                    placeOrder(
                      context: context,
                      customerName: name,
                      customerPhone: phone,
                      customerAddress: address,
                    );
                  } else {
                    EasyLoading.showError("Please fill in all fields"); // Tampilkan pesan error jika ada input yang kosong.
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appScendoryColor, // Warna latar belakang tombol Place Order.
                  padding: EdgeInsets.all(20.0), // Padding tombol.
                ),
                child: Text(
                  "Place Order", // Teks tombol Place Order.
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent, // Latar belakang bottom sheet transparan.
      isDismissible: true, // Bisa ditutup dengan mengklik di luar bottom sheet.
      enableDrag: true, // Memungkinkan untuk menarik bottom sheet.
      elevation: 6, // Elevasi bottom sheet.
      isScrollControlled: true, // Mengontrol scroll di dalam bottom sheet.
    );
  }
}
