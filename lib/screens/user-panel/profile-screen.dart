// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:cookies_shop/models/user-model.dart'; // Import model UserModel untuk data pengguna.
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi untuk styling konsisten.
import 'package:flutter/material.dart'; // Import package flutter/material.dart untuk widget Material Design.

class ProfileScreen extends StatelessWidget {
  UserModel userModel; // Properti untuk menyimpan model UserModel.

  ProfileScreen({
    Key? key,
    required this.userModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Tema warna ikon pada app bar dari konstanta aplikasi.
        centerTitle: true,
        title: Text(
          "Profile", // Judul pada app bar.
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appScendoryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(15), // Padding pada kontainer sebesar 15.
        child: ListView(
          padding: EdgeInsets.all(5), // Padding pada ListView sebesar 5.
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50.0, // Radius avatar lingkaran sebesar 50.
                      backgroundColor: AppConstant.appMainColor, // Warna latar belakang avatar dari konstanta aplikasi.
                      backgroundImage: userModel.userImg.isNotEmpty 
                          ? NetworkImage(userModel.userImg) // Memuat gambar pengguna jika tersedia.
                          : null, // Gambar kosong jika tidak ada.
                    ),
                    if (userModel.userImg.isEmpty)
                      Text(
                        userModel.username[0], // Teks inisial nama pengguna.
                        style: TextStyle(
                          color: AppConstant.appTextColor, // Warna teks dari konstanta aplikasi.
                          fontSize: 24,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 15), // Spasi kosong vertikal sebesar 15.
            _buildUserInfoBox(context, userModel), // Memanggil fungsi untuk membangun kotak informasi pengguna.
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun kotak informasi pengguna.
  Widget _buildUserInfoBox(BuildContext context, UserModel userModel) {
    return Container(
      padding: const EdgeInsets.all(15), // Padding pada kontainer sebesar 15.
      width: MediaQuery.of(context).size.width, // Lebar kontainer sesuai dengan lebar layar.
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15), // Bentuk tepi kotak bulat dengan radius 15.
        color: AppConstant.appCardColor, // Warna latar belakang kotak dari konstanta aplikasi.
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(Icons.person, 'Username', userModel.username), // Baris informasi untuk nama pengguna.
          _buildInfoRow(Icons.email, 'Email', userModel.email), // Baris informasi untuk email pengguna.
          _buildInfoRow(Icons.phone, 'Phone', userModel.phone), // Baris informasi untuk nomor telepon pengguna.
          _buildInfoRow(Icons.location_city, 'City', userModel.city), // Baris informasi untuk kota tempat tinggal pengguna.
          _buildInfoRow(Icons.home, 'Address', userModel.userAddress), // Baris informasi untuk alamat pengguna.
          _buildInfoRow(Icons.location_on, 'Country', userModel.country), // Baris informasi untuk negara pengguna.
          _buildInfoRow(Icons.streetview, 'Street', userModel.street), // Baris informasi untuk nama jalan pengguna.
        ],
      ),
    );
  }

  // Widget untuk membangun baris informasi dengan ikon, judul, dan nilai.
  Widget _buildInfoRow(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: AppConstant.appScendoryColor), // Ikon di sebelah kiri dengan warna dari konstanta aplikasi.
      title: Text(title), // Judul baris informasi.
      subtitle: Text(value), // Nilai atau isi dari informasi tersebut.
    );
  }
}
