import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/database/sql_helper_transaksi.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
          insertDataBooking();
          Navigator.popUntil(context, (route) {
            // stop di route home
            return route.settings.name == AppRoutes.home;
          });
        });
  }

  Future<void> insertDataBooking() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      int idUser = prefs.getInt('id') ?? 0;
      int idObjek = prefs.getInt('idObjek') ?? 0;
      String bookingName = prefs.getString('bookingName') ?? '';
      int bookingJumlah = prefs.getInt('bookingJumlah') ?? 0;
      String bookingEmail = prefs.getString('bookingEmail') ?? '';
      String bookingKTP = prefs.getString('bookingKTP') ?? '';
      String bookingPhone = prefs.getString('bookingPhone') ?? '';
      String bookingTanggal = prefs.getString('bookingTglStart') ?? '';
      int idBayar = prefs.getInt('bookingIdBayar') ?? 0;

      await SQLHelper.insertBooking(idUser, idObjek, bookingName, bookingJumlah,
          bookingEmail, bookingKTP, bookingPhone, bookingTanggal, idBayar);

      print('insert data booking success');

      //hapus key dari shared pref setelah insert ke db
      prefs.remove('idObjek');
      prefs.remove('bookingName');
      prefs.remove('bookingJumlah');
      prefs.remove('bookingEmail');
      prefs.remove('bookingKTP');
      prefs.remove('bookingPhone');
      prefs.remove('bookingTglStart');
      prefs.remove('bookingIdBayar');
      prefs.remove('bookingTotalHarga');
      prefs.remove('bookingPanjangKode');
      prefs.remove('namaObjek');

      print('remove shared pref');
    } catch (e) {
      print('error insert data booking: $e');
    }
  }
}
