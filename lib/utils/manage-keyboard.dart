import 'package:flutter/material.dart';

// Deklarasi kelas utilitas bernama KeyboardUtil
class KeyboardUtil {
  // Metode statis untuk menyembunyikan keyboard
  static void hideKeyboard(BuildContext context) {
    // Mendapatkan objek FocusScopeNode saat ini dari konteks
    FocusScopeNode currentFocus = FocusScope.of(context);

    // Mengecek apakah currentFocus tidak memiliki primary focus
    if (!currentFocus.hasPrimaryFocus) {
      // Menghilangkan fokus dari currentFocus, yang menyebabkan keyboard ditutup
      currentFocus.unfocus();
    }
  }
}
