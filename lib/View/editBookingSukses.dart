import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ugd1/model/pembayaran.dart';
import 'package:ugd1/client/PembayaranClient.dart';

class EditBookingSukses extends StatelessWidget {
  const EditBookingSukses({Key? key}) : super(key: key);

  Future<void> insertDataPembayaran() async {
    try {
      // final prefs = await SharedPreferences.getInstance();
      // double pricePembayaran = prefs.getDouble('bookingTotalHarga') ?? 0;
      // String metodePembayaran = prefs.getString('bookingMetode') ?? '';

      //Simpan pembayaran ke database
      // Pembayaran pembayaran =
      //     Pembayaran(price: pricePembayaran, metode: metodePembayaran);
      // var insertedIdBayar = await PembayaranClient.create(pembayaran);
      final prefs = await SharedPreferences.getInstance();
      int? id = prefs.getInt('idEditBooking');

      Pembayaran pembayaran = await PembayaranClient.find(id);
      await PembayaranClient.updateDenda(id!, pembayaran.price! + 300000);
      prefs.remove('idEditBooking');

      // if (insertedIdBayar != null) {
      //   print('insert data pembayaran success, id = $insertedIdBayar');
      //   await prefs.setInt('bookingIdBayar', insertedIdBayar);

      //   //hapus key dari shared pref setelah insert ke db
      //   prefs.remove('bookingTotalHarga');
      //   prefs.remove('bookingMetode');
      //   prefs.remove('idEditBooking');
      // }
    } catch (e) {
      print('error insert data pembayaran: $e');
    }
  }

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
                          child: Text("Edit Booking",
                              style: CustomTextStyles.titleBookingSukses)),
                      Align(
                          alignment: Alignment.center,
                          child: Text("Successfull",
                              style: theme.textTheme.displaySmall)),
                      SizedBox(height: 10),
                      SizedBox(
                          width: 250,
                          child: Text(
                              "Tanggal Start perjalanan anda sudah di-update.",
                              maxLines: 3,
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
          Navigator.popUntil(context, (route) {
            return route.settings.name == AppRoutes.homeUser;
          });
        });
  }
}
