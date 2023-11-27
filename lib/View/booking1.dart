import 'package:flutter/material.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:ugd1/widgets/app_bar/custom_app_bar.dart';
import 'package:ugd1/widgets/app_bar/appbar_image.dart';
import 'package:ugd1/widgets/app_bar/appbar_subtitle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/model/objekWisata.dart';
import 'package:ugd1/client/ObjekWisataClient.dart';

class Booking1Page extends StatefulWidget {
  const Booking1Page({Key? key}) : super(key: key);

  @override
  State<Booking1Page> createState() => _Booking1PageState();
}

class _Booking1PageState extends State<Booking1Page> {
  final TextEditingController tglstartController = TextEditingController();
  final TextEditingController tglendController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final formKey = GlobalKey<FormState>();

  //untuk tampung nama, id, durasi objek dari shared pref
  String namaObjekWisata = '';
  int idObjekWisata = 0;
  int durasi = 3; //default 3 hari

  @override
  void initState() {
    super.initState();
    loadData();
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
                                  .imgBookingHeader, //gambar nanti ambil dari database
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
                                            .headerBooking), // ambil dari shared pref
                                    SizedBox(height: 2),
                                    Text("Objek Wisata ID #$idObjekWisata",
                                        style: CustomTextStyles
                                            .headerSubtitleBooking)
                                  ]))
                        ])),
                SizedBox(height: 16),
                Divider(),
                SizedBox(height: 13),
                _buildDurasi(context),
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
                            Text(
                                "Tanggal pulang secara otomatis terisi berdasarkan durasi",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyles.labelKeteranganTanggal
                                    .copyWith(height: 1.43)),
                            SizedBox(height: 60),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Tanggal Keberangkatan",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            //tanggal keberangkatan
                            GestureDetector(
                              onTap: () async {
                                final selectedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate:
                                      DateTime.now(), // Set firstDate to today
                                  lastDate:
                                      DateTime.now().add(Duration(days: 365)),
                                );
                                if (selectedDate != null) {
                                  this.selectedDate = selectedDate;
                                  final formattedDate =
                                      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                                  tglstartController.text = formattedDate;

                                  final tglend = selectedDate.add(Duration(
                                      days: durasi)); //durasi dari shared pref

                                  final formattedDate2 =
                                      "${tglend.year}-${tglend.month}-${tglend.day}";
                                  tglendController.text = formattedDate2;
                                }
                              },
                              child: AbsorbPointer(
                                child: CustomTextFormField(
                                  controller: tglstartController,
                                  hintText: "yyyy-mm-dd",
                                  prefix: Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child: Icon(Icons.calendar_today),
                                  ),
                                  prefixConstraints: BoxConstraints(
                                    maxHeight: 50,
                                  ),
                                  contentPadding: EdgeInsets.only(
                                    top: 5,
                                    right: 30,
                                    bottom: 5,
                                  ),
                                  borderDecoration:
                                      TextFormFieldStyleHelper.outlineBlack,
                                  fillColor: theme.colorScheme.onPrimary
                                      .withOpacity(1),
                                  autofocus: false,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Tanggal keberangkatan harus terisi!!';
                                    }

                                    return null;
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: const Text("Tanggal Pulang",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins')),
                            ),
                            CustomTextFormField(
                              controller: tglendController,
                              hintText: "yyyy-mm-dd",
                              prefix: Container(
                                margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                child: Icon(Icons.calendar_today),
                              ),
                              prefixConstraints: BoxConstraints(
                                maxHeight: 50,
                              ),
                              contentPadding: EdgeInsets.only(
                                top: 5,
                                right: 30,
                                bottom: 5,
                              ),
                              readOnly: true,
                              autofocus: false,
                              borderDecoration:
                                  TextFormFieldStyleHelper.outlineBlack,
                              fillColor:
                                  theme.colorScheme.onPrimary.withOpacity(1),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      )),
                ),
              ]),
            ),
            bottomNavigationBar: _buildFrame(context),
          ),
        ));
  }

  //ini sharedpref utk simpan tanggal start, nanti di langkah booking 3 (pembayaran),
  //baru insert semua data sharedpref ke databse
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('bookingTglStart', tglstartController.text);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final tanggal = prefs.getString('bookingTglStart');
    final idObjek = prefs.getInt('idObjek');
    final namaObjek = prefs.getString('namaObjek') ?? '';
    final durasiObjek = prefs.getInt('durasiObjek') ?? 3;

    if (idObjek != null) {
      setState(() {
        idObjekWisata = idObjek;
        namaObjekWisata = namaObjek;
        durasi = durasiObjek;
      });
    }
    print('durasi $durasi dari id objek $idObjek');

    if (tanggal != null) {
      setState(() {
        tglstartController.text = tanggal;
        DateTime startDate = DateTime.parse(tanggal);
        DateTime endDate = startDate.add(Duration(days: durasi ?? 3));
        tglendController.text = endDate.toString().substring(0, 10);
      });
    }
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
                      Navigator.pushNamed(context, AppRoutes.booking2);
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
            text: "Pilih Tanggal Keberangkatan",
            margin: EdgeInsets.only(left: 18)),
        styleType: Style.bgFill);
  }

  /// Section Widget
  Widget _buildDurasi(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Padding(
          padding: EdgeInsets.only(top: 4, bottom: 1),
          child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: "Durasi", style: CustomTextStyles.subHeaderBooking),
                TextSpan(text: "  "),
              ]),
              textAlign: TextAlign.left)),
      RichText(
          text: TextSpan(
              text: "$durasi days ",
              style: CustomTextStyles.labelPembayaran), //dari database
          textAlign: TextAlign.left)
    ]);
  }
}
