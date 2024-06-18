// ignore_for_file: file_names, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace, unused_import, unused_local_variable

import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookies_shop/controllers/category-dropdown_controller.dart';
import 'package:cookies_shop/controllers/edit-product-controller.dart';
import 'package:cookies_shop/controllers/is-sale-controller.dart';
import 'package:cookies_shop/models/product-model.dart';
import 'package:cookies_shop/utils/app-constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class EditProductScreen extends StatefulWidget {
  ProductModel productModel;
  EditProductScreen({super.key, required this.productModel});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  IsSaleController isSaleController = Get.put(IsSaleController());
  CategoryDropDownController categoryDropDownController =
      Get.put(CategoryDropDownController());
  TextEditingController productNameController = TextEditingController();
  TextEditingController productImageController = TextEditingController();
  TextEditingController salePriceController = TextEditingController();
  TextEditingController fullPriceController = TextEditingController();
  TextEditingController deliveryTimeController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productNameController.text = widget.productModel.productName;
    productImageController.text = widget.productModel.productImages.join(',');
    salePriceController.text = widget.productModel.salePrice;
    fullPriceController.text = widget.productModel.fullPrice;
    deliveryTimeController.text = widget.productModel.deliveryTime;
    productDescriptionController.text = widget.productModel.productDescription;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EditProductController>(
      init: EditProductController(productModel: widget.productModel),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: AppConstant.appScendoryColor),
            centerTitle: true,
            title: Text(
              "Edit Product ${widget.productModel.productName}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstant.appScendoryColor,
                fontSize: 20,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 20,
                      height: Get.height / 4.0,
                      child: GridView.builder(
                        itemCount: controller.images.length,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 2,
                          crossAxisSpacing: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: controller.images[index],
                                fit: BoxFit.contain,
                                height: Get.height / 5.5,
                                width: Get.width / 2,
                                placeholder: (context, url) =>
                                    Center(child: CupertinoActivityIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                              Positioned(
                                right: 10,
                                top: 0,
                                child: InkWell(
                                  onTap: () async {
                                    EasyLoading.show();
                                    await controller.deleteImageFromFireStore(
                                        controller.images[index].toString(),
                                        widget.productModel.productId);
                                    EasyLoading.dismiss();
                                  },
                                  child: CircleAvatar(
                                    backgroundColor:
                                        AppConstant.appScendoryColor,
                                    child: Icon(
                                      Icons.close,
                                      color: AppConstant.appTextColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  //drop down
                  GetBuilder<CategoryDropDownController>(
                    init: CategoryDropDownController(),
                    builder: (categoriesDropDownController) {
                      return Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0.0),
                            child: Card(
                              elevation: 10,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: DropdownButton<String>(
                                  value: categoriesDropDownController
                                      .selectedCategoryId?.value,
                                  items: categoriesDropDownController.categories
                                      .map((category) {
                                    return DropdownMenuItem<String>(
                                      value: category['categoryId'],
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              category['categoryImg']
                                                  .toString(),
                                            ),
                                          ),
                                          const SizedBox(width: 20),
                                          Text(category['categoryName']),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? selectedValue) async {
                                    categoriesDropDownController
                                        .setSelectedCategory(selectedValue);
                                    String? categoryName =
                                        await categoriesDropDownController
                                            .getCategoryName(selectedValue);
                                    categoriesDropDownController
                                        .setSelectedCategoryName(categoryName);
                                  },
                                  hint: const Text(
                                    'Select a category',
                                  ),
                                  isExpanded: true,
                                  elevation: 10,
                                  underline: const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  //isSale
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
                      return Card(
                        elevation: 10,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Is Sale"),
                              Switch(
                                value: isSaleController.isSale.value,
                                activeColor: AppConstant.appScendoryColor,
                                onChanged: (value) {
                                  isSaleController.toggleIsSale(value);
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  //form
                  SizedBox(height: 15.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appScendoryColor,
                      textInputAction: TextInputAction.next,
                      controller: productNameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Product Name",
                        hintText: "Enter category name",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 65,
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: productImageController,
                      cursorColor: AppConstant.appScendoryColor,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Image Product (Comma separated URLs)",
                        hintText: "Enter image product URLs separated by comma",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GetBuilder<IsSaleController>(
                    init: IsSaleController(),
                    builder: (isSaleController) {
                      return isSaleController.isSale.value
                          ? Container(
                              height: 65,
                              margin: EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                cursorColor: AppConstant.appScendoryColor,
                                textInputAction: TextInputAction.next,
                                controller: salePriceController,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  labelText: "Sale Price",
                                  hintText: "Enter sale price",
                                  hintStyle: TextStyle(fontSize: 12.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appScendoryColor,
                      textInputAction: TextInputAction.next,
                      controller: fullPriceController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Full Price",
                        hintText: "Enter full price",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appScendoryColor,
                      textInputAction: TextInputAction.next,
                      controller: deliveryTimeController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Delivery time",
                        hintText: "Enter delivery time",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Container(
                    height: 65,
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      cursorColor: AppConstant.appScendoryColor,
                      textInputAction: TextInputAction.next,
                      controller: productDescriptionController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        labelText: "Product Description",
                        hintText: "Enter product description",
                        hintStyle: TextStyle(fontSize: 12.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () async {
                      EasyLoading.show(status: "Updating...");

                      List<String> productImages = productImageController.text
                          .trim()
                          .split(',')
                          .map((image) => image.trim())
                          .toList();

                      ProductModel newProductModel = ProductModel(
                        productId: widget.productModel.productId,
                        categoryId: categoryDropDownController
                            .selectedCategoryId
                            .toString(),
                        productName: productNameController.text.trim(),
                        categoryName: categoryDropDownController
                            .selectedCategoryName
                            .toString(),
                        salePrice: salePriceController.text != ''
                            ? salePriceController.text.trim()
                            : '',
                        fullPrice: fullPriceController.text.trim(),
                        productImages: widget.productModel.productImages,
                        deliveryTime: deliveryTimeController.text.trim(),
                        isSale: isSaleController.isSale.value,
                        productDescription:
                            productDescriptionController.text.trim(),
                        createdAt: widget.productModel.createdAt,
                      );

                      await FirebaseFirestore.instance
                          .collection('products')
                          .doc(widget.productModel.productId)
                          .update(newProductModel.toMap())
                          .then((_) {
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess("Product Updated");
                      }).catchError((error) {
                        EasyLoading.dismiss();
                        EasyLoading.showError("Failed to update product");
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appScendoryColor,
                      padding: EdgeInsets.all(20.0),
                    ),
                    child: Text(
                      "Update",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
