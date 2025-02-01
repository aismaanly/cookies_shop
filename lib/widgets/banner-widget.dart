import 'package:cached_network_image/cached_network_image.dart';  // Package untuk mengambil gambar dari jaringan dengan cache
import 'package:carousel_slider/carousel_slider.dart';  // Package untuk widget slider carousel
import 'package:cookies_shop/controllers/banners-controller.dart';  // Controller untuk mengelola banner
import 'package:flutter/cupertino.dart';  // Package untuk widget Cupertino (iOS style)
import 'package:flutter/material.dart';  // Package untuk komponen UI Flutter
import 'package:get/get.dart';  // Package untuk manajemen state dan navigasi dengan GetX

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselController carouselController = CarouselController();  // Controller untuk mengontrol slider carousel
  final bannerController _bannerController = Get.put(bannerController());  // Menggunakan GetX untuk mendapatkan instance dari BannerController

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      child: Obx(() {
        return CarouselSlider(
          // Menampilkan daftar gambar banner dari controller
          items: _bannerController.bannerUrls
              .map(
                (imageUrls) => ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(
                    imageUrl: imageUrls,
                    fit: BoxFit.cover,
                    width: Get.width - 10,
                    placeholder: (context, url) => ColoredBox(
                      color: Colors.white,
                      child: Center(
                        child: CupertinoActivityIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            scrollDirection: Axis.horizontal,  // Arah scroll horizontal
            autoPlay: true,  // Memulai autoplay slider
            aspectRatio: 2.5,  // Rasio aspek gambar
            viewportFraction: 1,  // Jumlah tampilan gambar dalam viewport
          ),
        );
      }),
    );
  }
}