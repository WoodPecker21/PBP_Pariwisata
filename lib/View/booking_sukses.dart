import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ugd1/model/transaksi.dart';
import 'package:ugd1/client/TransaksiClient.dart';
import 'package:ugd1/model/pembayaran.dart';
import 'package:ugd1/client/PembayaranClient.dart';

class BookingSukses extends StatelessWidget {
  const BookingSukses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Container(
                width: mediaQueryData.size.width,
                height: mediaQueryData.size.height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0.5, 0),
                        end: Alignment(0.5, 1),
                        colors: [
                      theme.colorScheme.primary,
                      appTheme.indigo200
                    ])),
                child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(left: 50, top: 140, right: 50),
                    child: Column(children: [
                      CustomImageView(
                          imagePath: ImageConstant.tripperbumi,
                          height: 120,
                          width: 130),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Booking",
                              style: CustomTextStyles.titleBookingSukses)),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Successfull",
                              style: theme.textTheme.displaySmall)),
                      SizedBox(height: 10),
                      SizedBox(
                          width: 250,
                          child: Text(
                              "Data booking akan tampil di halaman Future Booking. Buka halaman tersebut untuk melihat, mengubah tanggal keberangkatan ataupun membatalkan booking.",
                              maxLines: 8,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: CustomTextStyles.labelBookingSukses))
                    ]))),
            bottomNavigationBar: _buildBackToHome(context)));
  }

  /// Section Widget
  Widget _buildBackToHome(BuildContext context) {
    return CustomElevatedButton(
        text: "OK",
        textColor: theme.colorScheme.primary,
        margin: EdgeInsets.only(left: 40, right: 34, bottom: 16),
        onPressed: () {
          insertDataPembayaran();
          insertDataBooking();
          Navigator.popUntil(context, (route) {
            return route.settings.name == AppRoutes.home;
          });
        });
  }

  Future<void> insertDataPembayaran() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      double pricePembayaran = prefs.getDouble('bookingTotalHarga') ?? 0;
      String metodePembayaran = prefs.getString('bookingMetode') ?? '';

      //Simpan pembayaran ke database
      Pembayaran pembayaran =
          Pembayaran(price: pricePembayaran, metode: metodePembayaran);
      var insertedIdBayar = await PembayaranClient.create(pembayaran);

      print('insert data pembayaran success');

      await prefs.setInt('bookingIdBayar', insertedIdBayar);

      //hapus key dari shared pref setelah insert ke db
      prefs.remove('bookingTotalHarga');
      prefs.remove('bookingMetode');
    } catch (e) {
      print('error insert data pembayaran: $e');
    }
  }

  Future<void> insertDataBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      int idUser = prefs.getInt('id') ?? 0;
      int idObjek = prefs.getInt('idObjek') ?? 0;
      String bookingName = prefs.getString('bookingName') ?? '';
      int bookingJumlah = prefs.getInt('bookingJumlah') ?? 0;
      String bookingKTP = prefs.getString('bookingKTP') ?? '';
      String bookingTanggal = prefs.getString('bookingTglStart') ?? '';
      int idBayar = prefs.getInt('bookingIdBayar') ?? 0;

      //Simpan booking ke database
      Transaksi booking = Transaksi(
          idUser: idUser,
          idObjek: idObjek,
          name: bookingName,
          jumlahTamu: bookingJumlah,
          ktpNumber: bookingKTP,
          tglStart: bookingTanggal,
          idBayar: idBayar);
      await TransaksiClient.create(booking);

      print('insert data booking success');

      //hapus key dari shared pref setelah insert ke db
      prefs.remove('idObjek');
      prefs.remove('namaObjek');
      prefs.remove('durasiObjek');
      prefs.remove('bookingName');
      prefs.remove('bookingJumlah');
      prefs.remove('bookingKTP');
      prefs.remove('bookingTglStart');
      prefs.remove('bookingIdBayar');

      print('removed shared pref');
    } catch (e) {
      print('error insert data booking: $e');
    }
  }
}
