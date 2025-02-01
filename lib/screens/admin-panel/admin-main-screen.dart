// ignore_for_file: prefer_const_constructors, file_names

import 'package:cookies_shop/controllers/chart-order-controller.dart'; // Import controller untuk chart order
import 'package:cookies_shop/models/chart-order-model.dart'; // Import model untuk chart order
import 'package:cookies_shop/utils/app-constant.dart'; // Import konstanta aplikasi seperti warna dan tema
import 'package:cookies_shop/widgets/admin-drawer-widget.dart'; // Import widget drawer admin
import 'package:flutter/cupertino.dart'; // Import widget dari Cupertino untuk UI
import 'package:flutter/material.dart'; // Import library dasar dari Flutter
import 'package:get/get.dart'; // Import package GetX untuk manajemen state
import 'package:syncfusion_flutter_charts/charts.dart'; // Import chart dari Syncfusion

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  @override
  Widget build(BuildContext context) {
    final GetAllOrdersChart getAllOrdersChart = Get.put(GetAllOrdersChart()); // Menginisialisasi controller chart order

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppConstant.appScendoryColor), // Mengatur warna ikon di app bar
        centerTitle: true,
        title: Text(
          "Admin", // Judul halaman
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppConstant.appScendoryColor,
              fontSize: 20),
        ),
      ),
      drawer: AdminDrawerWidget(), // Drawer untuk navigasi admin
      body: Container(
        child: Column(
          children: [
            Obx(() {
              final monthlyData = getAllOrdersChart.monthlyOrderData; // Mengambil data bulanan dari controller

              if (monthlyData.isEmpty) { // Jika data bulanan kosong, tampilkan indikator loading
                return Container(
                    height: Get.height / 2,
                    child: Center(
                      child: CupertinoActivityIndicator(),
                    ));
              } else {
                return SizedBox(
                  height: Get.height / 2,
                  child: SfCartesianChart(
                    tooltipBehavior: TooltipBehavior(enable: true), // Menampilkan tooltip pada chart
                    primaryXAxis: CategoryAxis(arrangeByIndex: true), // Axis X dengan pengaturan kategori
                    series: <LineSeries<ChartData, String>>[
                      LineSeries<ChartData, String>(
                        dataSource: monthlyData, // Menggunakan data bulanan sebagai sumber data
                        width: 2.5,
                        color: AppConstant.appScendoryColor, // Warna garis chart
                        xValueMapper: (ChartData data, _) => data.month, // Mapper untuk nilai X (bulan)
                        yValueMapper: (ChartData data, _) => data.value, // Mapper untuk nilai Y (jumlah pesanan)
                        name: "Monthly Orders", // Nama series
                        markerSettings: MarkerSettings(isVisible: true), // Pengaturan marker (titik) pada garis
                      ),
                    ],
                  ),
                );
              }
            })
          ],
        ),
      ),
    );
  }
}
