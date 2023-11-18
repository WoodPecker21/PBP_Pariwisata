import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/app_bar/appbar_leading_image.dart';
import 'package:ugd1/widgets/app_bar/custom_app_bar.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_phone_number.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/database/sql_helper_objek.dart';

class Booking2Page extends StatefulWidget {
  const Booking2Page({Key? key}) : super(key: key);

  @override
  State<Booking2Page> createState() => _Booking2PageState();
}

class _Booking2PageState extends State<Booking2Page> {
  TextEditingController guestNameController = TextEditingController();
  TextEditingController numberOfPersonsController = TextEditingController();
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('62');
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController kTPNumberController = TextEditingController();
  double harga = 0;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryPickerUtils.getCountryByPhoneCode('62');
    loadIsiForm();
  }

  Future<void> loadIsiForm() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      if (prefs.containsKey('bookingName') &&
          prefs.containsKey('bookingJumlah') &&
          prefs.containsKey('bookingEmail') &&
          prefs.containsKey('bookingKTP') &&
          prefs.containsKey('bookingPhone') &&
          prefs.containsKey('bookingPanjangKode')) {
        // Retrieve data from shared preferences
        String bookingName = prefs.getString('bookingName') ?? '';
        int bookingJumlah = prefs.getInt('bookingJumlah') ?? 0;
        String bookingEmail = prefs.getString('bookingEmail') ?? '';
        String bookingKTP = prefs.getString('bookingKTP') ?? '';
        String bookingPhone = prefs.getString('bookingPhone') ?? '';
        int bookingPanjangKode = prefs.getInt('bookingPanjangKode') ?? 0;

        // Update TextControllers with the retrieved data
        setState(() {
          guestNameController.text = bookingName;
          numberOfPersonsController.text = bookingJumlah.toString();
          emailController.text = bookingEmail;
          kTPNumberController.text = bookingKTP;

          // Extract phone number without the country code
          if (bookingPhone.isNotEmpty) {
            String phoneNumberWithoutPlus = bookingPhone.replaceAll('+', '');
            String phoneWithoutCode =
                phoneNumberWithoutPlus.substring(bookingPanjangKode + 1);
            phoneNumberController.text = phoneWithoutCode;

            String countryCode =
                phoneNumberWithoutPlus.substring(0, bookingPanjangKode);
            selectedCountry =
                CountryPickerUtils.getCountryByPhoneCode(countryCode);
          }
        });
      }

      print('Data loaded from shared preferences');
    } catch (e) {
      print('Error loading data from shared preferences: $e');
    }
  }

  Future<void> addDetailTransaksi() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      //simpan data form ke shared preferences
      String mergedPhoneNumber =
          '+${selectedCountry.phoneCode}${phoneNumberController.text}';
      await prefs.setString('bookingName', guestNameController.text);
      await prefs.setInt(
          'bookingJumlah', int.tryParse(numberOfPersonsController.text) ?? 0);
      await prefs.setString('bookingEmail', emailController.text);
      await prefs.setString('bookingKTP', kTPNumberController.text);
      await prefs.setString('bookingPhone', mergedPhoneNumber);
      await prefs.setInt(
          'bookingPanjangKode', selectedCountry.phoneCode.length);
      await prefs.setDouble('bookingTotalHarga', harga);

      print('phone: $mergedPhoneNumber');
      print('data saved to shared preferences');
    } catch (e) {
      print('Error saving data to shared preferences: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return SafeArea(
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: _buildAppBar(context),
            body: Form(
                key: formKey,
                child: Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 7),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Booking Trip",
                              style: CustomTextStyles.titleBooking),
                          SizedBox(height: 2),
                          Text("Masukkan detail Tamu",
                              style: CustomTextStyles.subtitleBooking),
                          SizedBox(height: 25),
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
                          Text("No. Telp",
                              style: CustomTextStyles.labelFormBooking),
                          _buildPhoneNumber(context),
                          SizedBox(height: 12),
                          Text("Email",
                              style: CustomTextStyles.labelFormBooking),
                          SizedBox(height: 2),
                          _buildEmail(context),
                          SizedBox(height: 14),
                          Text("No. KTP",
                              style: CustomTextStyles.labelFormBooking),
                          SizedBox(height: 1),
                          _buildKTPNumber(context),
                          SizedBox(height: 5)
                        ]))),
            bottomNavigationBar: _buildFrame(context)));
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
        hintText: "John",
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nama Tamu harus terisi!!';
          }
          return null;
        });
  }

  /// Section Widget
  Widget _buildNumberOfPersons(BuildContext context) {
    return CustomTextFormField(
        controller: numberOfPersonsController,
        hintText: "2",
        textInputType: TextInputType.number,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Jumlah Tamu harus terisi!!';
          } else {
            // Convert the string to an integer
            int numberOfPersons = int.tryParse(value) ?? 0;

            if (numberOfPersons <= 0) {
              return 'Jumlah Tamu harus lebih dari 0!!';
            }
          }
          return null;
        });
  }

  /// Section Widget
  Widget _buildPhoneNumber(BuildContext context) {
    return CustomPhoneNumber(
        country: selectedCountry,
        controller: phoneNumberController,
        onTap: (Country country) {
          setState(() {
            selectedCountry = country;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nomor HP harus terisi!!';
          }
          return null;
        });
  }

  /// Section Widget
  Widget _buildEmail(BuildContext context) {
    return CustomTextFormField(
        controller: emailController,
        hintText: "john.ux@gmail.com",
        textInputType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Email harus terisi!!';
          } else if (value.contains('@') == false) {
            return 'Email harus mengandung @ !!';
          }
          return null;
        });
  }

  /// Section Widget
  Widget _buildKTPNumber(BuildContext context) {
    return CustomTextFormField(
        controller: kTPNumberController,
        hintText: "252637736246424",
        keyboardType: TextInputType.number,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Nomor KTP harus terisi!!';
          }
          return null;
        });
  }

  Future<double> getHarga() async {
    final prefs = await SharedPreferences.getInstance();
    int idObjek = prefs.getInt('idObjek') ?? 0;
    double? harga;
    harga = await SQLHelper.getHarga(idObjek);
    if (harga == null) {
      harga = 0;
    }
    if (numberOfPersonsController.text.isEmpty) {
      numberOfPersonsController.text = '1';
    }
    int numberOfPersons = int.parse(numberOfPersonsController.text);
    harga = harga * numberOfPersons;
    print('id objek: $idObjek, dan harganya: $harga');
    return harga;
  }

  /// Section Widget, future builder utk menampilkan harga sesuai databse x jumlah orang
  Widget _buildFrame(BuildContext context) {
    return FutureBuilder<double>(
      future: getHarga(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          harga = snapshot.data ?? 0;
          return Container(
            margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
            decoration: AppDecoration.outlineBlack,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 110,
                  margin: EdgeInsets.only(top: 10, left: 15, bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Rp $harga\n",
                          style: CustomTextStyles.labelHargaBooking,
                        ),
                        TextSpan(
                          text: "/ ${numberOfPersonsController.text}  Person",
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
                  margin: EdgeInsets.only(top: 10, left: 50, bottom: 10),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      addDetailTransaksi();
                      Navigator.pushNamed(context, AppRoutes.booking3);
                    }
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
