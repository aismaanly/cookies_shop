import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookies_shop/models/cart-model.dart';
import 'package:cookies_shop/utils/app-constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../controllers/cart-price-controller.dart';
import 'checkout-screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final ProductPriceController productPriceController =
      Get.put(ProductPriceController());

  Future<void> deleteProduct(String productId) async {
    await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .doc(productId)
        .delete();

    // Periksa apakah keranjang kosong setelah penghapusan
    var snapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user!.uid)
        .collection('cartOrders')
        .get();

    if (snapshot.docs.isEmpty) {
      productPriceController.totalPrice.value = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor),
        centerTitle: true,
        title: Text(
          "Cart",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: Get.height / 5,
              child: Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text("No products found!"),
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
                        title: "Delete",
                        forceAlignmentToBoundary: true,
                        performsFirstActionWithFullSwipe: true,
                        onTap: (CompletionHandler handler) async {
                          await Get.defaultDialog(
                            title: "Remove Product",
                            content: const Text(
                                "Are you sure you want to remove this product from your cart?"),
                            textCancel: "Cancel",
                            textConfirm: "Delete",
                            contentPadding: const EdgeInsets.all(10.0),
                            confirmTextColor: Colors.white,
                            onCancel: () {},
                            onConfirm: () async {
                              Get.back();
                              await deleteProduct(cartModel.productId);
                            },
                            buttonColor: Colors.red,
                            cancelTextColor: Colors.black,
                          );
                        },
                        color: Colors.red,
                      ),
                    ],
                    child: Card(
                      elevation: 5,
                      color: AppConstant.appCardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppConstant.appMainColor,
                              backgroundImage:
                                  NetworkImage(cartModel.productImages[0]),
                              radius: 30,
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
                                      color: Colors.brown,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () async {
                                    if (cartModel.productQuantity > 1) {
                                      await FirebaseFirestore.instance
                                          .collection('cart')
                                          .doc(user!.uid)
                                          .collection('cartOrders')
                                          .doc(cartModel.productId)
                                          .update({
                                        'productQuantity':
                                            cartModel.productQuantity - 1,
                                        'productTotalPrice':
                                            (double.parse(cartModel.fullPrice) *
                                                (cartModel.productQuantity - 1))
                                      });
                                    } else {
                                      await Get.defaultDialog(
                                        title: "Remove Product",
                                        content: const Text(
                                            "Are you sure you want to remove this product from your cart?"),
                                        textCancel: "Cancel",
                                        textConfirm: "Remove",
                                        contentPadding:
                                            const EdgeInsets.all(10.0),
                                        confirmTextColor: Colors.white,
                                        buttonColor: Colors.red,
                                        cancelTextColor: Colors.black,
                                        onCancel: () {},
                                        onConfirm: () async {
                                          Get.back();
                                          await deleteProduct(
                                              cartModel.productId);
                                        },
                                      );
                                    }
                                  },
                                  color: AppConstant.appScendoryColor,
                                ),
                                Text(
                                  cartModel.productQuantity.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user!.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity':
                                          cartModel.productQuantity + 1,
                                      'productTotalPrice':
                                          double.parse(cartModel.fullPrice) *
                                              (cartModel.productQuantity + 1)
                                    });
                                  },
                                  color: AppConstant.appScendoryColor,
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

          return Container();
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
                    "Total : ${productPriceController.totalPrice.value.toStringAsFixed(0)}",
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
                    color: AppConstant.appScendoryColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: TextButton(
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        color: AppConstant.appTextColor,
                        fontSize: 18.0,
                      ),
                    ),
                    onPressed: () {
                      Get.to(() => CheckOutScreen());
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
