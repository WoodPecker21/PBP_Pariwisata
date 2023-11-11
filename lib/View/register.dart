import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd1/bloc/form_submission_state.dart';
import 'package:ugd1/bloc/register_state.dart';
import 'package:ugd1/bloc/register_bloc.dart';
import 'package:ugd1/model/user.dart';
//import 'package:ugd1/repository/register_repository.dart';
import 'package:ugd1/bloc/register_event.dart';
import 'package:ugd1/View/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/database/sql_helper_user.dart';
import 'package:ugd1/View/login.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';

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

  List<Map<String, dynamic>> users = [];

  void refresh() async {
    final data = await SQLHelper.getUser();
    setState(() {
      users = data;
    });
  }

  @override
  void initState() {
    refresh();
    super.initState();
  }

  bool cekEmailUnik(String emailInput, List<Map<String, dynamic>> users) {
    for (Map<String, dynamic> user in users) {
      String? userEmail = user['email'];
      if (userEmail == emailInput) {
        return false;
      }
      if (userEmail == null) {
        return true;
      }
    }
    return true;
  }

  final formKey = GlobalKey<FormState>();

  Future<void> saveUserToSharedPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', usernameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('phoneNumber', phoneNumberController.text);
    prefs.setString('birthdate', birthdateController.text.toString());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
        create: (context) => RegisterBloc(),
        child: Scaffold(
          body: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) {
              // if (state.formSubmissionState is SubmissionSuccess) {
              //   print('---sudah sukses---');
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text('Register Success'),
              //     ),
              //   );
              //   final user = User(
              //     name: usernameController.text,
              //     email: emailController.text,
              //     phoneNumber: phoneNumberController.text,
              //     birthDate: selectedDate,
              //   );
              //   saveUserToSharedPreferences(
              //       user); // This is where you save the user's data.

              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //       builder: (context) => Loginview(),
              //     ),
              //   );
              // }
              // if (state.formSubmissionState is SubmissionFailed) {
              //   print('---sudah gagal---');
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //         (state.formSubmissionState as SubmissionFailed)
              //             .exception
              //             .toString(),
              //       ),
              //     ),
              //   );
              // }
            },
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
                                    style: CustomTextStyles
                                        .headlineLargePoppinsBlack900,
                                  ),
                                  SizedBox(height: 95),
                                  _buildGambar(context),
                                  SizedBox(height: 30),
                                  CustomTextFormField(
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
                                    controller: emailController,
                                    hintText: "Email",
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
                                      } else if (!cekEmailUnik(value, users)) {
                                        return 'Email harus unik!';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  CustomTextFormField(
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
                                  CustomTextFormField(
                                    controller: phoneNumberController,
                                    hintText: "Nomor Telepon",
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    prefix: Container(
                                      margin:
                                          EdgeInsets.fromLTRB(15, 15, 15, 15),
                                      child: Icon(Icons.phone),
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
                                      if (value == '') {
                                        return 'Nomor telepon harus terisi!!';
                                      }
                                      if (value!.length < 5) {
                                        return 'Nomor Telepon harus 5 digit';
                                      }
                                      return null;
                                    },
                                  ),
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
                                  const SizedBox(height: 30),
                                  SizedBox(
                                    width: double.infinity,
                                    child: CustomElevatedButton(
                                      height: 50,
                                      text: "Register",
                                      margin: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                      ),
                                      buttonStyle:
                                          CustomButtonStyles.fillPrimary,
                                      buttonTextStyle:
                                          CustomTextStyles.titleLargeOnPrimary,
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
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
      await SQLHelper.addUser(
        usernameController.text,
        passwordController.text,
        emailController.text,
        phoneNumberController.text,
        birthdateController.text,
      );
      print('masuk add---------');
      // User added successfully
    } catch (e) {
      // Handle database insertion error here
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
}
