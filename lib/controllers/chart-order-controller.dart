// ignore_for_file: avoid_function_literals_in_foreach_calls

// Import package Firebase Firestore untuk akses database
import 'package:cloud_firestore/cloud_firestore.dart';
// Import package GetX untuk state management
import 'package:get/get.dart';
// Import model ChartData
import 'package:cookies_shop/models/chart-order-model.dart';

// Definisikan class GetAllOrdersChart yang meng-extend GetxController
class GetAllOrdersChart extends GetxController {
  // Instance Firestore untuk akses database
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Deklarasi variabel monthlyOrderData yang merupakan RxList dari ChartData
  // RxList adalah tipe data reaktif dari GetX yang memungkinkan perubahan
  // pada list secara reaktif dan otomatis memperbarui UI yang terkait
  final RxList<ChartData> monthlyOrderData = RxList<ChartData>();

  // Override metode onInit yang merupakan lifecycle method dari GetxController
  @override
  void onInit() {
    super.onInit();
    // Panggil fungsi fetchMonthlyOrders untuk mengambil data pesanan bulanan
    fetchMonthlyOrders();
  }

  // Fungsi asinkron untuk mengambil data pesanan bulanan dari Firestore
  Future<void> fetchMonthlyOrders() async {
    // Mendapatkan referensi koleksi 'orders' dari Firestore
    final CollectionReference ordersCollection =
        _firestore.collection('orders');

    // Menghitung tanggal 180 hari yang lalu dari tanggal sekarang
    final DateTime dateMonthAgo = DateTime.now().subtract(const Duration(days: 180));
    // Mengambil semua dokumen dalam koleksi 'orders'
    final QuerySnapshot allUserSnapshot = await ordersCollection.get();
    // Membuat map untuk menyimpan jumlah pesanan per bulan
    final Map<String, int> monthlyCount = {};

    // Iterasi melalui setiap dokumen dalam snapshot
    for (QueryDocumentSnapshot userSnapshot in allUserSnapshot.docs) {
      // Mengambil semua pesanan yang dibuat dalam 180 hari terakhir
      final QuerySnapshot userOrdersSnapshot = await ordersCollection
          .doc(userSnapshot.id)
          .collection('confirmOrders')
          .where("createdAt", isGreaterThanOrEqualTo: dateMonthAgo)
          .get();

      // Iterasi melalui setiap dokumen pesanan dalam snapshot
      userOrdersSnapshot.docs.forEach((order) {
        // Mengambil timestamp dari pesanan
        final Timestamp timestamp = order['createdAt'];
        // Mengkonversi timestamp menjadi DateTime
        final DateTime orderDate = timestamp.toDate();
        // Membuat kunci bulan-tahun untuk map
        final String monthYearKey = '${orderDate.year}-${orderDate.month}';

        // Menambahkan atau memperbarui jumlah pesanan dalam map
        monthlyCount[monthYearKey] = (monthlyCount[monthYearKey] ?? 0) + 1;
      });
    }

    // Mengkonversi map menjadi list ChartData
    final List<ChartData> monthlyData = monthlyCount.entries
        .map((entry) => ChartData(entry.key, entry.value.toDouble()))
        .toList();

    // Menambahkan data ke monthlyOrderData
    if (monthlyData.isEmpty) {
      // Jika tidak ada data, tambahkan pesan "Data not found!"
      monthlyOrderData.add(ChartData("Data not found!", 0));
    } else {
      // Urutkan data berdasarkan bulan
      monthlyData.sort((a, b) => a.month.compareTo(b.month));
      // Assign semua data ke monthlyOrderData
      monthlyOrderData.assignAll(monthlyData);
    }
  }
}
