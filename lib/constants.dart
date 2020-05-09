import 'package:flutter/material.dart';

class Constants {
  static const titleStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
  static const counterStyle = TextStyle(fontSize: 10, color: Colors.black);
  static const guidenceStyle = TextStyle(fontSize: 12, color: Colors.black);

  static const nonNegativeDecimalNumber = r'^\d+(\.\d{0,999})?|\.?\d{1,2}$';

  static const Color primaryColor = Color(0xffFFFFFF);
  static const Color accentColor = Color(0xffC82247);

  static const String appName = 'Quick ISK';
  static const String newSimulation = 'Simulasi Baru';
  static const String simulationHistory = 'Riwayat Simulasi';

  static const String tipe3Subtitle =
      'Pilih salah satu yang sesuai dengan kondisi Program Studi Anda';
  static const String tipe5Subtitle =
      'Isikan presentase setiap kriteria dengan kondisi Program Studi Anda (%)';

  static const String lulusanNormal = '# Jumlah Lulusan Dalam 3 Tahun';
  static const String lulusanTerlacak =
      '# Jumlah Lulusan Dalam 3 Tahun Yang Terlacak';
  static const String lulusanTanggap =
      '# Jumlah Pengguna Lulusan Yang Memberi Tanggapan Atas Studi Pelacakan Lulusan Dalam 3 Thn';

  static const String baik = 'BAIK';
  static const String baikSekali = 'BAIK SEKALI';
  static const String unggul = 'UNGGUL';

  static const String desc1 = '*Untuk Saran Klik Tanda Tanya';
  static const String desc2 =
      'Sesuai aturan BAN-PT untuk konversi predikat akreditasi adalah one on one yaitu \nA konversi ke Unggul; \nB konversi ke Baik Sekali; \nC konversi ke Baik';
  static const desc1Style = TextStyle(fontSize: 8, color: Color(0xff544D4D));
  static const desc2Style = TextStyle(fontSize: 8, color: Color(0xff544D4D));

  static const String multiNumberValidationMessage =
      'Silahkan isi dengan nilai yang sesuai, isikan total nilai maksimal 100 dan total minimal 100';
  static const String errorMsgDefault =
      'Terdapat indicator yang masih tidak valid/kosong.';
}
