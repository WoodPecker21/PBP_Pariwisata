import 'package:flutter/material.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/app_bar/custom_app_bar.dart';
import 'package:ugd1/widgets/app_bar/appbar_image.dart';
import 'package:ugd1/widgets/app_bar/appbar_subtitle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/database/sql_helper_pembayaran.dart';

class Booking3Page extends StatefulWidget {
  const Booking3Page({super.key});

  @override
  State<Booking3Page> createState() => _Booking3PageState();
}

class _Booking3PageState extends State<Booking3Page> {
  final formKey = GlobalKey<FormState>();
  int selectedPayment = 0, jumlahTamu = 0;
  double hargaPembayaran = 0;
  //untuk tampung nama dan id objek dari shared pref
  String namaObjekWisata = '';
  int idObjekWisata = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    double totalHarga = prefs.getDouble('bookingTotalHarga') ?? 0;
    int jumlahPerson = prefs.getInt('bookingJumlah') ?? 0;

    print('total harga: $totalHarga, jumlah person: $jumlahPerson');
    setState(() {
      hargaPembayaran = totalHarga;
      jumlahTamu = jumlahPerson;
    });

    final idObjek = prefs.getInt('idObjek');
    final namaObjek = prefs.getString('namaObjek') ?? '';

    if (idObjek != null) {
      setState(() {
        idObjekWisata = idObjek;
        namaObjekWisata = namaObjek;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return MaterialApp(
        theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
        home: SafeArea(
          child: Scaffold(
            appBar: _buildAppBar(context),
            body: Container(
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Column(children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomImageView(
                              imagePath: ImageConstant
                                  .imgBookingHeader, //nanti ambil dari database
                              height: 47,
                              width: 47,
                              radius: BorderRadius.circular(5)),
                          Padding(
                              padding: EdgeInsets.only(left: 8, bottom: 6),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("$namaObjekWisata",
                                        style: CustomTextStyles
                                            .headerBooking), // ambil dari database
                                    SizedBox(height: 2),
                                    Text("Objek Wisata ID #$idObjekWisata",
                                        style: CustomTextStyles
                                            .headerSubtitleBooking)
                                  ]))
                        ])),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 13),
                _buildHarga(context),
                SizedBox(height: 14),
                Divider(),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 10.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          customPaymentCardButton(ImageConstant.bca, 1),
                          const SizedBox(
                            height: 20,
                          ),
                          customPaymentCardButton(ImageConstant.dana, 2),
                          if (selectedPayment == 0)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0, left: 0),
                              child: Text(
                                'Metode Pembayaran harus dipilih!',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ]),
            ),
            bottomNavigationBar: _buildFrame(context),
          ),
        ));
  }

  //ini sharedpref utk simpan id pembayaran
  Future<void> saveData() async {
    try {
      String metode = "";
      if (selectedPayment == 1) {
        metode = "BCA";
      } else if (selectedPayment == 2) {
        metode = "DANA";
      }

      final prefs = await SharedPreferences.getInstance();
      double totalHarga = prefs.getDouble('bookingTotalHarga') ?? 0;
      int insertedIdBayar = await SQLHelper.addPembayaran(metode, totalHarga);

      await prefs.setInt('bookingIdBayar', insertedIdBayar);

      print(
          'sukses inserted id pembayaran: $insertedIdBayar, dengan metode: $metode dan total harga: $totalHarga');
    } catch (e) {
      print('Error saving pembayaran to database: $e');
    }
  }

  Widget customPaymentCardButton(String assetName, int index) {
    return Column(children: [
      OutlinedButton(
        onPressed: () {
          setState(() {
            selectedPayment = index;
          });
          if (selectedPayment == 2)
            Navigator.pushNamed(context, AppRoutes.paymentPage);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          side: BorderSide(
              width: (selectedPayment == index) ? 3 : 1,
              color: (selectedPayment == index) ? Colors.green : Colors.black),
        ),
        child: Center(
          child: Image.asset(
            assetName,
            fit: BoxFit.contain,
            width: 200,
            height: 100,
          ),
        ),
      )
    ]);
  }

  Widget _buildFrame(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 18, right: 18, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomElevatedButton(
                  width: 150,
                  text: "Back",
                  buttonStyle: CustomButtonStyles.fillGray,
                  buttonTextStyle: CustomTextStyles.teksButtonBack,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CustomElevatedButton(
                  width: 150,
                  text: "Next",
                  margin: EdgeInsets.only(left: 10),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      saveData();
                      Navigator.pushNamed(
                          context, AppRoutes.bookingSukses); //ke booking sukses
                    }
                  })
            ]));
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        height: 53,
        leadingWidth: 47,
        leading: Container(
            margin: EdgeInsets.only(left: 18, top: 11, bottom: 11),
            padding: EdgeInsets.symmetric(horizontal: 9, vertical: 7),
            decoration: AppDecoration.fillOnPrimary
                .copyWith(borderRadius: BorderRadiusStyle.roundedBorder15),
            child: AppbarImage(
                imagePath: ImageConstant.imgBackAppbar,
                margin: EdgeInsets.only(right: 1),
                onTap: () {
                  Navigator.pop(context);
                })),
        title: AppbarSubtitle(
            text: "Confirm Pembayaran", margin: EdgeInsets.only(left: 18)),
        styleType: Style.bgFill);
  }

  /// Section Widget
  Widget _buildHarga(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: EdgeInsets.only(top: 4, bottom: 1),
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Total Harga ",
                    style: CustomTextStyles.subHeaderBooking),
                TextSpan(text: "  "),
                TextSpan(
                    text: "(inc. tax)", style: CustomTextStyles.labelJumOrang)
              ]),
              textAlign: TextAlign.left)),
      RichText(
          text: TextSpan(
              text:
                  "Rp $hargaPembayaran / $jumlahTamu px", //nanti dari database
              style: CustomTextStyles.labelPembayaran),
          textAlign: TextAlign.left)
    ]);
  }
}
