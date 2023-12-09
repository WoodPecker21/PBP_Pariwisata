import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/app_bar/appbar_leading_image.dart';
import 'package:ugd1/widgets/app_bar/custom_app_bar.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/model/transaksi.dart';
import 'package:ugd1/client/TransaksiClient.dart';
import 'package:intl/intl.dart';

class EditBooking extends StatefulWidget {
  const EditBooking({Key? key}) : super(key: key);

  @override
  State<EditBooking> createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
  TextEditingController guestNameController = TextEditingController();
  TextEditingController numberOfPersonsController = TextEditingController();
  TextEditingController kTPNumberController = TextEditingController();
  TextEditingController tglstartController = TextEditingController();
  TextEditingController durasiController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController objekNamaController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  int id = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    loadIsiForm();
  }

  Future<void> loadIsiForm() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int idEditedBooking = prefs.getInt('idEditBooking') ?? 0;

      if (idEditedBooking != 0) {
        setState(() {
          id = idEditedBooking;
        });
        //get data dari api
        Transaksi t = await TransaksiClient.find(idEditedBooking);

        // Update TextControllers with the retrieved data
        setState(() {
          guestNameController.text = t.name!;
          numberOfPersonsController.text = t.jumlahTamu.toString();
          kTPNumberController.text = t.ktpNumber!;
          tglstartController.text = t.tglStart!;
          selectedDate = DateTime.parse(t.tglStart!);
          durasiController.text = t.objek!.durasi.toString();
          hargaController.text = t.bayar!.price.toString();
          objekNamaController.text = t.objek!.nama!;
        });
      }

      print('Data loaded');
    } catch (e) {
      print('Error loading data : $e');
    }
  }

  Future<void> editTanggal() async {
    try {
      //update tanggal start
      await TransaksiClient.update(id, tglstartController.text);
      print('data updated');
    } catch (e) {
      print('Error update data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: formKey,
                  child: Container(
                      width: double.maxFinite,
                      padding:
                          EdgeInsets.symmetric(horizontal: 22, vertical: 7),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Booking Data",
                                style: CustomTextStyles.titleBooking),
                            SizedBox(height: 2),
                            Text('You may edit your booking date here',
                                style: CustomTextStyles.subtitleBooking),
                            SizedBox(height: 25),
                            Text("Nama Objek Wisata",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 1),
                            _buildNamaObjek(context),
                            SizedBox(height: 14),
                            Text("Nama Tamu",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 1),
                            _buildGuestName(context),
                            SizedBox(height: 14),
                            Text("Jumlah Tamu",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 2),
                            _buildNumberOfPersons(context),
                            SizedBox(height: 14),
                            Text("No. KTP",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 1),
                            _buildKTPNumber(context),
                            SizedBox(height: 14),
                            Text("Tanggal Start",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 1),
                            _buildTanggal(context),
                            SizedBox(height: 14),
                            Text("Durasi",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 1),
                            _buildDurasi(context),
                            SizedBox(height: 14),
                            Text("Harga Total",
                                style: CustomTextStyles.labelFormBooking),
                            SizedBox(height: 1),
                            _buildHarga(context),
                            SizedBox(height: 5)
                          ]))),
            ),
            bottomNavigationBar: _buildFrame(context)));
  }

  Widget _buildFrame(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(left: 18, right: 18, bottom: 10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 110,
                margin: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Rp 300.000 \n",
                        style: CustomTextStyles.labelHargaBooking,
                      ),
                      TextSpan(
                        text: "/ Booking",
                        style: CustomTextStyles.labelJumOrang,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              CustomElevatedButton(
                  width: 150,
                  text: "Next",
                  margin: EdgeInsets.only(left: 10),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      editTanggal();
                      Navigator.pushNamed(
                          context, AppRoutes.editBayar); //LANJUT KE BAYAR DENDA
                    }
                  })
            ]));
  }

  /// Section Widget
  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return CustomAppBar(
        leadingWidth: double.maxFinite,
        leading: AppbarLeadingImage(
            imagePath: ImageConstant.imgBackAppbar,
            margin: EdgeInsets.fromLTRB(22, 5, 320, 5),
            onTap: () {
              Navigator.pop(context);
            }));
  }

  /// Section Widget
  Widget _buildGuestName(BuildContext context) {
    return CustomTextFormField(
      controller: guestNameController,
      readOnly: true,
    );
  }

  /// Section Widget
  Widget _buildNumberOfPersons(BuildContext context) {
    return CustomTextFormField(
      controller: numberOfPersonsController,
      readOnly: true,
    );
  }

  /// Section Widget
  Widget _buildKTPNumber(BuildContext context) {
    return CustomTextFormField(
      controller: kTPNumberController,
      readOnly: true,
    );
  }

  Widget _buildDurasi(BuildContext context) {
    return CustomTextFormField(
      controller: durasiController,
      readOnly: true,
    );
  }

  Widget _buildHarga(BuildContext context) {
    return CustomTextFormField(
      controller: hargaController,
      readOnly: true,
    );
  }

  Widget _buildNamaObjek(BuildContext context) {
    return CustomTextFormField(
      controller: objekNamaController,
      readOnly: true,
    );
  }

  /// Section Widget
  Widget _buildTanggal(BuildContext context) {
    return //tanggal keberangkatan
        GestureDetector(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: this.selectedDate,
          firstDate: DateTime.now(), // Set firstDate to today
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (selectedDate != null) {
          this.selectedDate = selectedDate;
          final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          tglstartController.text = formattedDate;
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
          borderDecoration: TextFormFieldStyleHelper.outlineBlack,
          fillColor: theme.colorScheme.onPrimary.withOpacity(1),
          autofocus: false,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Tanggal keberangkatan harus terisi!!';
            }

            return null;
          },
        ),
      ),
    );
  }
}
