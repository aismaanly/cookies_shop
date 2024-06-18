// ignore_for_file: file_names, prefer_const_constructors, avoid_unnecessary_containers

import 'package:cookies_shop/screens/user-panel/all-categories-screen.dart';
import 'package:cookies_shop/screens/user-panel/all-flash-sale-products.dart';
import 'package:cookies_shop/screens/user-panel/all-products-screen.dart';
import 'package:cookies_shop/screens/user-panel/cart-screen.dart';
import 'package:cookies_shop/widgets/all-products-widget.dart';
import 'package:cookies_shop/widgets/banner-widget.dart';
import 'package:cookies_shop/widgets/category-widget.dart';
import 'package:cookies_shop/widgets/flash-sale-widget.dart';
import 'package:cookies_shop/widgets/heading-widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/app-constant.dart';
import '../../widgets/user-drawer-widget.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor),
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppConstant.appMainColor,
            statusBarIconBrightness: Brightness.light),
        title: Text(
          AppConstant.appMainName,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => Get.to(() => CartScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerWidget(),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 80.0,
              ),

              //banners
              BannerWidget(),

              //heading categories
              HeadingWidget(
                headingTitle: "Categories",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllCategoriesScreen()),
                buttonText: "See More >",
              ),

              CategoriesWidget(),

              //heading flash sale
              HeadingWidget(
                headingTitle: "Flash Sale",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllFlashSaleProductScreen()),
                buttonText: "See More >",
              ),

              FlashSaleWidget(),

              // //heading
              HeadingWidget(
                headingTitle: "All Products",
                headingSubTitle: "According to your budget",
                onTap: () => Get.to(() => AllProductsScreen()),
                buttonText: "See More >",
              ),

              AllProductsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
