import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd1/bloc/register_state.dart';
import 'package:ugd1/bloc/register_bloc.dart';
import 'package:ugd1/bloc/register_event.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ugd1/client/UserClient.dart';
import 'package:ugd1/model/user.dart';
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:ugd1/widgets/custom_phone_number.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String gender = 'Laki-laki';
  bool check1 = false;
  bool genderValid = false;
  bool validasi = false;
  Country selectedCountry = CountryPickerUtils.getCountryByPhoneCode('62');

  @override
  void initState() {
    super.initState();
    selectedCountry = CountryPickerUtils.getCountryByPhoneCode('62');
  }

  final listProvider = FutureProvider<List<User>>((ref) async {
    return await UserClient.fetchAll();
  });

  bool isEmailUnik = false;

  Future<void> checkEmailUnik() async {
    try {
      // Call the cekEmailUnik method from UserClient
      bool getEmailUnik = await UserClient.cekEmailUnik(emailController.text);

      setState(() {
        isEmailUnik = getEmailUnik;
      });
      print('dapat email unik: $isEmailUnik');
    } catch (e) {
      // Handle errors as needed
      print('Error checking email uniqueness: $e');
    }
  }

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
        child: Scaffold(
          body: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {},
            child: BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
              return MaterialApp(
                  theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
                  home: SafeArea(
                    child: Scaffold(
                      body: Form(
                        key: formKey,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 10.0,
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: 55),
                                  Text(
                                    "Register",
                                    style: CustomTextStyles.titleForm,
                                  ),
                                  SizedBox(height: 95),
                                  _buildGambar(context),
                                  SizedBox(height: 30),
                                  CustomTextFormField(
                                    key: Key('username'),
                                    controller: usernameController,
                                    hintText: "Username",
                                    prefix: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      child: Icon(Icons.person),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Username harus terisi!!';
                                      } else if (value.length < 5) {
                                        return 'Username minimal memiliki 5 karakter!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextFormField(
                                    key: Key('email'),
                                    controller: emailController,
                                    hintText: "Email",
                                    textInputType: TextInputType.emailAddress,
                                    keyboardType: TextInputType.emailAddress,
                                    prefix: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      child: const Icon(Icons.email),
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
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Email harus terisi!!';
                                      } else if (!value.contains('@')) {
                                        return 'Email harus menggunakan @';
                                      } else if (isEmailUnik == false) {
                                        return 'Email harus unik!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextFormField(
                                      key: Key('password'),
                                      controller: passwordController,
                                      hintText: "Password",
                                      prefix: Container(
                                        margin:
                                            EdgeInsets.fromLTRB(15, 15, 15, 15),
                                        child: const Icon(Icons.lock),
                                      ),
                                      prefixConstraints: BoxConstraints(
                                        maxHeight: 50,
                                      ),
                                      suffix: Container(
                                        child: IconButton(
                                          onPressed: () {
                                            context.read<RegisterBloc>().add(
                                                  IsPasswordVisibleChanged(),
                                                );
                                          },
                                          icon: Icon(
                                            state.isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: state.isPasswordVisible
                                                ? Colors.grey
                                                : ThemeHelper()
                                                    .themeColor()
                                                    .deepPurple500,
                                          ),
                                        ),
                                      ),
                                      suffixConstraints: BoxConstraints(
                                        maxHeight: 50,
                                      ),
                                      borderDecoration:
                                          TextFormFieldStyleHelper.outlineBlack,
                                      fillColor: theme.colorScheme.onPrimary
                                          .withOpacity(1),
                                      obscureText: state.isPasswordVisible,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Password harus terisi!!';
                                        } else if (value.length < 5) {
                                          return 'Password minimal memiliki 5 karakter!';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(height: 15),
                                  CustomPhoneNumber(
                                      key: Key('hp'),
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
                                        if (value.length < 5) {
                                          return 'Nomor Telepon harus 5 digit';
                                        }
                                        return null;
                                      }),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                    onTap: () async {
                                      final selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(1900),
                                        lastDate: DateTime.now(),
                                      );
                                      if (selectedDate != null) {
                                        this.selectedDate = selectedDate;
                                        final formattedDate =
                                            "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
                                        birthdateController.text =
                                            formattedDate;
                                      }
                                    },
                                    child: AbsorbPointer(
                                      child: CustomTextFormField(
                                        key: Key('tanggallahir'),
                                        controller: birthdateController,
                                        hintText: "Tanggal Lahir",
                                        prefix: Container(
                                          margin: EdgeInsets.fromLTRB(
                                              15, 15, 15, 15),
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
                                            TextFormFieldStyleHelper
                                                .outlineBlack,
                                        fillColor: theme.colorScheme.onPrimary
                                            .withOpacity(1),
                                        //readOnly: true,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Tanggal lahir harus terisi!!';
                                          }
                                          if (selectedDate.year > 2005) {
                                            return 'Anda Harus Berumur 18 Tahun!!';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile(
                                          key: Key('laki'),
                                          title: const Text("Laki-Laki",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')),
                                          value: "Laki-Laki",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value.toString();
                                              genderValid = true;
                                            });
                                          },
                                          controlAffinity: ListTileControlAffinity
                                              .leading, // Move radio button to the left
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal:
                                                      1), // Adjust the spacing
                                        ),
                                      ),
                                      const SizedBox(
                                        width:
                                            6, // Add spacing between radio buttons
                                      ),
                                      Expanded(
                                        child: RadioListTile(
                                          title: const Text("Perempuan",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: 'Poppins')),
                                          value: "Perempuan",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value.toString();
                                              genderValid = true;
                                            });
                                          },
                                          controlAffinity: ListTileControlAffinity
                                              .leading, // Move radio button to the left
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal:
                                                      1), // Adjust the spacing
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (!genderValid && validasi == true)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8.0, left: 0),
                                      child: Text(
                                        'Jenis Kelamin harus dipilih!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 15),
                                  CheckboxListTile(
                                    key: Key('check'),
                                    value: check1,
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        check1 = value!;
                                      });
                                    },
                                    title: Semantics(
                                      excludeSemantics: true,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            _buildPrivacyPolicyText(context),
                                          ],
                                        ),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                  if (!check1 && validasi == true)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Centang setelah memahami kebijakan privasi!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CustomElevatedButton(
                                      key: Key('register'),
                                      height: 50,
                                      text: "Register",
                                      margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      buttonStyle:
                                          CustomButtonStyles.fillPrimary,
                                      buttonTextStyle:
                                          CustomTextStyles.teksTombol,
                                      onPressed: () async {
                                        setState(() {
                                          validasi = true;
                                        });
                                        await checkEmailUnik();
                                        if (formKey.currentState!.validate() &&
                                            genderValid == true &&
                                            check1 == true) {
                                          print('masuk validasi---------');

                                          await addUser();
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Register Success'),
                                            ),
                                          );

                                          Navigator.pushNamed(
                                              context, AppRoutes.login);
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                ],
                              ),
                            )),
                      ),
                    ),
                  ));
            }),
          ),
        ));
  }

  Future<void> addUser() async {
    try {
      String mergedPhoneNumber =
          '+${selectedCountry.phoneCode}${phoneNumberController.text}';
      print('phone: $mergedPhoneNumber');
      User user = User(
        name: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        phoneNumber: mergedPhoneNumber,
        birthDate: birthdateController.text,
        gender: gender,
        imageProfile: null,
      );

      await UserClient.create(user);

      print('User added successfully');
    } catch (e) {
      // Handle error during user creation
      print('Error adding user: $e');
    }
  }

  /// Section Widget
  Widget _buildGambar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 100,
        vertical: 27,
      ),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            ImageConstant.candi,
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          CustomImageView(
            imagePath: ImageConstant.logotripper,
            height: 85,
            width: 130,
          ),
        ],
      ),
    );
  }

  TextSpan _buildPrivacyPolicyText(BuildContext context) {
    return TextSpan(
      text: "Saya Telah Membaca dan Menyetujui ",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
        color: Colors.black,
      ),
      children: [
        TextSpan(
          text: " Kebijakan Privasi",
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: appTheme.blueA700,
          ),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, AppRoutes.privasiPage);
            },
        ),
      ],
    );
  }
}
