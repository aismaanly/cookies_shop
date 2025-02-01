// ignore_for_file: avoid_print, file_names

// Import package Firebase Messaging untuk mendapatkan token perangkat
import 'package:firebase_messaging/firebase_messaging.dart';

// Fungsi async getCustomerDeviceToken untuk mendapatkan token perangkat pengguna
Future<String> getCustomerDeviceToken() async {
  try {
    // Mendapatkan token perangkat menggunakan FirebaseMessaging
    String? token = await FirebaseMessaging.instance.getToken();
    
    // Jika token tidak null, kembalikan token
    if (token != null) {
      return token;
    } else {
      // Jika token null, lempar Exception
      throw Exception("Error");
    }
  } catch (e) {
    // Menangkap dan mencetak error menggunakan print statement
    print("Error $e");
    
    // Melempar Exception untuk error yang terjadi
    throw Exception("Error");
  }
}
