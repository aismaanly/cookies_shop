// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cookies_shop/controllers/sign-up-controller.dart';  // Import controller untuk manajemen logika SignUp
import 'package:cookies_shop/screens/auth-ui/log-in-screen.dart';  // Import layar Login untuk navigasi
import 'package:cookies_shop/utils/app-constant.dart';  // Import konstanta aplikasi seperti warna dan teks
import 'package:firebase_auth/firebase_auth.dart';  // Import Firebase Authentication
import 'package:flutter/material.dart';  // Flutter framework utama
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';  // Package untuk mendeteksi visibilitas keyboard
import 'package:get/get.dart';  // Package GetX untuk manajemen state dan navigasi

class SignUpScreen extends StatefulWidget {  // Stateful widget untuk halaman SignUp
  const SignUpScreen({super.key});  // Constructor widget SignUpScreen

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();  // Override untuk membuat state dari SignUpScreen
}

class _SignUpScreenState extends State<SignUpScreen> {  // State dari SignUpScreen
  final SignUpController signUpController = Get.put(SignUpController());  // Controller SignUp menggunakan GetX
  TextEditingController username = TextEditingController();  // Controller untuk input username
  TextEditingController userEmail = TextEditingController();  // Controller untuk input email
  TextEditingController userPhone = TextEditingController();  // Controller untuk input nomor telepon
  TextEditingController userCity = TextEditingController();  // Controller untuk input kota
  TextEditingController userPassword = TextEditingController();  // Controller untuk input password
  RxBool isPasswordValid = true.obs;  // RxBool untuk validasi password

  @override
  Widget build(BuildContext context) {  // Build method untuk membangun UI halaman SignUp
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {  // Memanfaatkan KeyboardVisibilityBuilder untuk mendeteksi keyboard
      return Scaffold(  // Scaffold sebagai struktur utama halaman
        appBar: AppBar(  // AppBar kosong (tanpa judul)
          title: Text(""),  // Judul AppBar kosong
        ),
        body: SingleChildScrollView(  // SingleChildScrollView untuk scroll jika konten lebih panjang dari layar
          physics: BouncingScrollPhysics(),  // Efek bouncing saat scrolling
          child: Container(  // Container utama dalam body
            child: Column(  // Column untuk menyusun elemen secara vertikal
              children: [  // Children berisi elemen-elemen dalam Column
                SizedBox(  // SizedBox untuk spasi vertikal
                  height: Get.height / 30,  // Tinggi spasi sesuai dengan 1/30 dari tinggi layar
                ),
                Container(  // Container untuk judul dan deskripsi
                  alignment: Alignment.center,  // Posisi konten di tengah
                  child: Column(  // Column untuk menyusun elemen judul dan deskripsi
                    children: [
                      Text(  // Judul "Sign Up"
                        "Sign Up",
                        style: TextStyle(  // Style teks judul
                          color: AppConstant.appScendoryColor,  // Warna teks dari konstanta aplikasi
                          fontWeight: FontWeight.bold,  // Tebal teks judul
                          fontSize: 24,  // Ukuran teks judul
                        ),
                      ),
                      SizedBox(  // SizedBox untuk spasi vertikal
                        height: 30,
                      ),
                      Text(  // Deskripsi "Pertama buat akun Anda"
                        "Pertama buat akun Anda",
                        style: TextStyle(  // Style teks deskripsi
                          color: AppConstant.appMainColor,  // Warna teks dari konstanta aplikasi
                          fontWeight: FontWeight.bold,  // Tebal teks deskripsi
                          fontSize: 15,  // Ukuran teks deskripsi
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(  // SizedBox untuk spasi vertikal
                  height: Get.height / 20,  // Tinggi spasi sesuai dengan 1/20 dari tinggi layar
                ),
                Container(  // Container untuk input email
                  margin: EdgeInsets.symmetric(horizontal: 5.0),  // Margin horizontal 5.0
                  width: Get.width,  // Lebar sesuai dengan lebar layar
                  child: Padding(  // Padding untuk memuat TextFormField
                    padding: const EdgeInsets.all(10.0),  // Padding all 10.0
                    child: TextFormField(  // TextFormField untuk input email
                      controller: userEmail,  // Menggunakan controller userEmail
                      cursorColor: AppConstant.appScendoryColor,  // Warna kursor dari konstanta aplikasi
                      keyboardType: TextInputType.emailAddress,  // Keyboard type untuk email
                      decoration: InputDecoration(  // Decoration untuk styling input
                        labelText: "Email",  // Label teks "Email"
                        hintText: "Masukkan email Anda",  // Hint text "Masukkan email Anda"
                        contentPadding: EdgeInsets.symmetric(  // Padding konten vertikal dan horizontal
                            vertical: 15.0, horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(  // Border saat tidak di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna abu-abu
                              color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        focusedBorder: OutlineInputBorder(  // Border saat di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna dari konstanta aplikasi
                              color: AppConstant.appScendoryColor),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        filled: true,  // Terisi dengan warna latar belakang
                        fillColor: Colors.grey[200],  // Warna latar belakang abu-abu
                      ),
                    ),
                  ),
                ),
              // Lanjutan dari komentar sebelumnya...

                Container(  // Container untuk input username
                  margin: EdgeInsets.symmetric(horizontal: 5.0),  // Margin horizontal 5.0
                  width: Get.width,  // Lebar sesuai dengan lebar layar
                  child: Padding(  // Padding untuk memuat TextFormField
                    padding: const EdgeInsets.all(10.0),  // Padding all 10.0
                    child: TextFormField(  // TextFormField untuk input username
                      controller: username,  // Menggunakan controller username
                      cursorColor: AppConstant.appScendoryColor,  // Warna kursor dari konstanta aplikasi
                      keyboardType: TextInputType.name,  // Keyboard type untuk nama
                      decoration: InputDecoration(  // Decoration untuk styling input
                        labelText: "Username",  // Label teks "Username"
                        hintText: "Masukkan username Anda",  // Hint text "Masukkan username Anda"
                        contentPadding: EdgeInsets.symmetric(  // Padding konten vertikal dan horizontal
                            vertical: 15.0, horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(  // Border saat tidak di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna abu-abu
                              color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        focusedBorder: OutlineInputBorder(  // Border saat di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna dari konstanta aplikasi
                              color: AppConstant.appScendoryColor),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        filled: true,  // Terisi dengan warna latar belakang
                        fillColor: Colors.grey[200],  // Warna latar belakang abu-abu
                      ),
                    ),
                  ),
                ),
                Container(  // Container untuk input nomor telepon
                  margin: EdgeInsets.symmetric(horizontal: 5.0),  // Margin horizontal 5.0
                  width: Get.width,  // Lebar sesuai dengan lebar layar
                  child: Padding(  // Padding untuk memuat TextFormField
                    padding: const EdgeInsets.all(10.0),  // Padding all 10.0
                    child: TextFormField(  // TextFormField untuk input nomor telepon
                      controller: userPhone,  // Menggunakan controller userPhone
                      cursorColor: AppConstant.appScendoryColor,  // Warna kursor dari konstanta aplikasi
                      keyboardType: TextInputType.number,  // Keyboard type untuk angka
                      decoration: InputDecoration(  // Decoration untuk styling input
                        labelText: "Phone",  // Label teks "Phone"
                        hintText: "Masukkan nomor telepon Anda",  // Hint text "Masukkan nomor telepon Anda"
                        contentPadding: EdgeInsets.symmetric(  // Padding konten vertikal dan horizontal
                            vertical: 15.0, horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(  // Border saat tidak di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna abu-abu
                              color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        focusedBorder: OutlineInputBorder(  // Border saat di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna dari konstanta aplikasi
                              color: AppConstant.appScendoryColor),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        filled: true,  // Terisi dengan warna latar belakang
                        fillColor: Colors.grey[200],  // Warna latar belakang abu-abu
                      ),
                    ),
                  ),
                ),

                Container(  // Container untuk input kota
                  margin: EdgeInsets.symmetric(horizontal: 5.0),  // Margin horizontal 5.0
                  width: Get.width,  // Lebar sesuai dengan lebar layar
                  child: Padding(  // Padding untuk memuat TextFormField
                    padding: const EdgeInsets.all(10.0),  // Padding all 10.0
                    child: TextFormField(  // TextFormField untuk input kota
                      controller: userCity,  // Menggunakan controller userCity
                      cursorColor: AppConstant.appScendoryColor,  // Warna kursor dari konstanta aplikasi
                      keyboardType: TextInputType.streetAddress,  // Keyboard type untuk alamat
                      decoration: InputDecoration(  // Decoration untuk styling input
                        labelText: "City",  // Label teks "City"
                        hintText: "Masukkan kota Anda",  // Hint text "Masukkan kota Anda"
                        contentPadding: EdgeInsets.symmetric(  // Padding konten vertikal dan horizontal
                            vertical: 15.0, horizontal: 15.0),
                        enabledBorder: OutlineInputBorder(  // Border saat tidak di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna abu-abu
                              color: Colors.grey[400]!),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        focusedBorder: OutlineInputBorder(  // Border saat di-focus
                          borderSide: BorderSide(  // Sisi border dengan warna dari konstanta aplikasi
                              color: AppConstant.appScendoryColor),
                          borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                        ),
                        filled: true,  // Terisi dengan warna latar belakang
                        fillColor: Colors.grey[200],  // Warna latar belakang abu-abu
                      ),
                    ),
                  ),
                ),

                Container(  // Container untuk input password
                  margin: EdgeInsets.symmetric(horizontal: 5.0),  // Margin horizontal 5.0
                  width: Get.width,  // Lebar sesuai dengan lebar layar
                  child: Padding(  // Padding untuk memuat TextFormField dan validasi password
                    padding: const EdgeInsets.all(10.0),  // Padding all 10.0
                    child: Obx(  // Widget Obx untuk memantau perubahan state
                      () => Column(  // Column untuk menyusun TextFormField dan pesan error
                        crossAxisAlignment: CrossAxisAlignment.start,  // Penyusunan elemen secara horizontal
                        children: [
                          TextFormField(  // TextFormField untuk input password
                            controller: userPassword,  // Menggunakan controller userPassword
                            obscureText: !signUpController.isPasswordVisible.value,  // Teks tersembunyi atau tidak tergantung pada isPasswordVisible
                            cursorColor: AppConstant.appScendoryColor,  // Warna kursor dari konstanta aplikasi
                            keyboardType: TextInputType.visiblePassword,  // Keyboard type untuk password
                            decoration: InputDecoration(  // Decoration untuk styling input
                              labelText: "Password",  // Label teks "Password"
                              hintText: "Masukkan password Anda",  // Hint text "Masukkan password Anda"
                              contentPadding: EdgeInsets.symmetric(  // Padding konten vertikal dan horizontal
                                  vertical: 15.0, horizontal: 15.0),
                              enabledBorder: OutlineInputBorder(  // Border saat tidak di-focus
                                borderSide: BorderSide(  // Sisi border dengan warna abu-abu
                                    color: Colors.grey[400]!),
                                borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                              ),
                              focusedBorder: OutlineInputBorder(  // Border saat di-focus
                                borderSide: BorderSide(  // Sisi border dengan warna dari konstanta aplikasi
                                    color: AppConstant.appScendoryColor),
                                borderRadius: BorderRadius.circular(10.0),  // Border radius 10.0
                              ),
                              filled: true,  // Terisi dengan warna latar belakang
                              fillColor: Colors.grey[200],  // Warna latar belakang abu-abu
                              suffixIcon: GestureDetector(  // Ikona suffix untuk toggle visibilitas password
                                onTap: () {
                                  signUpController.isPasswordVisible.toggle();  // Toggle visibilitas password
                                },
                                child: Icon(  // Icon sesuai dengan visibilitas password saat ini
                                  signUpController.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                          ),
                          if (!isPasswordValid.value)  // Menampilkan pesan error jika password tidak valid
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0, top: 8.0),
                              child: Text(
                                "Password harus minimal 8 karakter",  // Pesan error jika password kurang dari 8 karakter
                                style: TextStyle(color: Colors.red),  // Teks warna merah untuk pesan error
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(  // SizedBox untuk spasi vertikal antara input dan tombol
                  height: Get.height / 20,  // Tinggi spasi sesuai dengan 1/20 dari tinggi layar
                ),

                Material(  // Material widget untuk styling tombol
                  child: Container(  // Container untuk tombol SIGN UP
                    width: Get.width / 2,  // Lebar tombol setengah dari lebar layar
                    height: Get.height / 18,  // Tinggi tombol sesuai dengan 1/18 dari tinggi layar
                    decoration: BoxDecoration(  // Decoration untuk styling tombol
                      color: AppConstant.appScendoryColor,  // Warna tombol dari konstanta aplikasi
                      borderRadius: BorderRadius.circular(20.0),  // Border radius 20.0
                    ),
                    child: TextButton(  // TextButton sebagai isi dari tombol
                      child: Text(  // Teks "SIGN UP"
                        "SIGN UP",
                        style: TextStyle(color: AppConstant.appTextColor),  // Warna teks dari konstanta aplikasi
                      ),
                      onPressed: () async {  // Event handler saat tombol ditekan
                        String name = username.text.trim();  // Mengambil nilai username yang telah di-trim
                        String email = userEmail.text.trim();  // Mengambil nilai email yang telah di-trim
                        String phone = userPhone.text.trim();  // Mengambil nilai nomor telepon yang telah di-trim
                        String city = userCity.text.trim();  // Mengambil nilai kota yang telah di-trim
                        String password = userPassword.text.trim();  // Mengambil nilai password yang telah di-trim

                        if (name.isEmpty ||  // Jika salah satu field kosong
                            email.isEmpty ||
                            phone.isEmpty ||
                            city.isEmpty ||
                            password.isEmpty) {
                          Get.snackbar(  // Menampilkan snackbar error jika ada field yang kosong
                            "Error",
                            "Silakan isi semua detail",
                            snackPosition: SnackPosition.BOTTOM,  // Snack position di bagian bawah
                            backgroundColor: AppConstant.appScendoryColor,  // Warna latar belakang snackbar dari konstanta aplikasi
                            colorText: AppConstant.appTextColor,  // Warna teks dari konstanta aplikasi
                          );
                        } else if (password.length < 8) {  // Jika panjang password kurang dari 8 karakter
                          isPasswordValid.value = false;  // Set nilai isPasswordValid menjadi false
                        } else {  // Jika semua field terisi dan password valid
                          isPasswordValid.value = true;  // Set nilai isPasswordValid menjadi true
                          UserCredential? userCredential =  // Mencoba melakukan sign up user
                              await signUpController.signUpMethod(  // Memanggil metode signUpMethod dari controller
                            name,
                            email,
                            phone,
                            city,
                            password,
                          );
                          if (userCredential != null) {  // Jika sign up berhasil
                            Get.snackbar(  // Menampilkan snackbar sukses
                              "Verifikasi email terkirim",
                              "Silakan cek email Anda",
                              snackPosition: SnackPosition.BOTTOM,  // Snack position di bagian bawah
                              backgroundColor: AppConstant.appScendoryColor,  // Warna latar belakang snackbar dari konstanta aplikasi
                              colorText: AppConstant.appTextColor,  // Warna teks dari konstanta aplikasi
                            );

                            FirebaseAuth.instance.signOut();  // Keluar dari Firebase Authentication
                            Get.offAll(() => LogInScreen());  // Navigasi ke halaman Login
                          }
                        }
                      },
                    ),
                  ),
                ),

                SizedBox(  // SizedBox untuk spasi vertikal setelah tombol SIGN UP
                  height: Get.height / 20,  // Tinggi spasi sesuai dengan 1/20 dari tinggi layar
                ),

                Row(  // Row untuk teks "Sudah memiliki akun?" dan link "Log In"
                  mainAxisAlignment: MainAxisAlignment.center,  // Penyusunan elemen di tengah secara horizontal
                  children: [
                    Text(  // Teks "Sudah memiliki akun?"
                      "Sudah memiliki akun? ",
                      style: TextStyle(color: AppConstant.appScendoryColor),  // Warna teks dari konstanta aplikasi
                    ),
                    GestureDetector(  // GestureDetector untuk menangani interaksi tap pada teks "Log In"
                      onTap: () => Get.offAll(() => LogInScreen()),  // Navigasi ke halaman LogIn saat teks "Log In" ditekan
                      child: Text(  // Teks "Log In"
                        "Log In",
                        style: TextStyle(  // Style teks "Log In"
                            color: AppConstant.appScendoryColor,  // Warna teks dari konstanta aplikasi
                            fontWeight: FontWeight.bold),  // Tebal teks "Log In"
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
