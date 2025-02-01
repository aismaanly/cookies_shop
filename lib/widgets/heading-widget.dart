// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

// Mengimpor paket yang diperlukan
import 'package:cookies_shop/utils/app-constant.dart';
import 'package:flutter/material.dart';

// Deklarasi widget Stateless bernama HeadingWidget
class HeadingWidget extends StatelessWidget {
  // Deklarasi properti yang diterima oleh widget
  final String headingTitle;
  final String headingSubTitle;
  final VoidCallback onTap;
  final String buttonText;

  // Konstruktor untuk inisialisasi properti dengan penanda required
  const HeadingWidget({
    super.key,
    required this.headingTitle,
    required this.headingSubTitle,
    required this.onTap,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // Margin di sekitar container
      margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Padding(
        // Padding di dalam container
        padding: EdgeInsets.all(5.0),
        child: Row(
          // Membuat jarak antara elemen-elemen di dalam row
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Kolom pertama: berisi judul dan subjudul
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Teks judul
                Text(
                  headingTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                // Teks subjudul
                Text(
                  headingSubTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            // GestureDetector untuk menangani event onTap pada tombol
            GestureDetector(
              onTap: onTap,
              child: Container(
                // Dekorasi untuk tombol, termasuk border dan radius
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: AppConstant.appScendoryColor,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  // Padding di dalam tombol
                  padding: const EdgeInsets.all(8.0),
                  // Teks di dalam tombol
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12.0,
                      color: AppConstant.appScendoryColor,
                    ),
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
