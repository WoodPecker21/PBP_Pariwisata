import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd1/bloc/login_bloc.dart';
import 'package:ugd1/bloc/login_event.dart';
import 'package:ugd1/bloc/login_state.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:ugd1/client/UserClient.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  List<Map<String, dynamic>> users = [];

  // Future<bool> updatePassword(String emailInput, String passwordnew) async {
  //   try {
  //     final id = await UserClient.searchEmail(emailInput);
  //     if (id != null) {
  //       setState(() {
  //         idUser = id;
  //       });
  //     }
  //     if (id == -1) {
  //       return false;
  //     }
  //     try {
  //       // Call the updatePassword function
  //       var response = await UserClient.updatePassword(idUser, passwordnew);

  //       // Handle the response if needed
  //       print('Password updated successfully: $response');

  //       return true;
  //     } catch (e) {
  //       // Handle errors
  //       print('Error updating password: $e');
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  //}

  Future<void> updatePassword(String emailInput, String newPassword) async {
    try {
      await UserClient.updatePassword(emailInput, newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update password Success'),
        ),
      );
      print('Password updated successfully');
    } catch (e) {
      var errorMessage = e.toString();
      if (errorMessage.contains('Password cannot be the same as the old one')) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tidak boleh sama dengan password lama'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Update password Failed'),
          ),
        );
      }
      print('Error during update: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {},
            child:
                BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
              return MaterialApp(
                  theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
                  home: SafeArea(
                    child: Scaffold(
                      body: Form(
                        key: formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_back),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                SizedBox(height: 45),
                                Text(
                                  "Forgot Password",
                                  style: CustomTextStyles.titleForm,
                                ),
                                SizedBox(height: 95),
                                _buildGambar(context),
                                SizedBox(height: 30),
                                CustomTextFormField(
                                  controller: emailController,
                                  hintText: "Email",
                                  textInputType: TextInputType.emailAddress,
                                  keyboardType: TextInputType.emailAddress,
                                  prefix: Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 15),
                                CustomTextFormField(
                                  controller: passwordController,
                                  hintText: "New Password",
                                  prefix: Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child: const Icon(Icons.lock),
                                  ),
                                  prefixConstraints: BoxConstraints(
                                    maxHeight: 50,
                                  ),
                                  suffix: Container(
                                    child: IconButton(
                                      onPressed: () {
                                        context.read<LoginBloc>().add(
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
                                  validator: (value) => value == ''
                                      ? 'Please enter your password'
                                      : null,
                                ),
                                const SizedBox(height: 15),
                                CustomTextFormField(
                                  controller: confirmController,
                                  hintText: "Confirm Password",
                                  prefix: Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
                                    child: const Icon(Icons.lock),
                                  ),
                                  prefixConstraints: BoxConstraints(
                                    maxHeight: 50,
                                  ),
                                  suffix: Container(
                                    child: IconButton(
                                      onPressed: () {
                                        context.read<LoginBloc>().add(
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
                                      return 'Harus mengisi confirm password!!';
                                    } else if (value !=
                                        passwordController.text) {
                                      return 'Confirm password tidak sama!!';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 30),

                                //tombol save
                                GestureDetector(
                                  child: CustomElevatedButton(
                                    height: 50,
                                    text: "Save",
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    buttonStyle: CustomButtonStyles.fillPrimary,
                                    buttonTextStyle:
                                        CustomTextStyles.teksTombol,
                                    //tambah method  disini krn di ontapnya ga bisa
                                    onPressed: () async {
                                      try {
                                        if (formKey.currentState!.validate()) {
                                          await updatePassword(
                                              emailController.text,
                                              passwordController.text);
                                        }
                                      } catch (e) {
                                        print('Error during update: $e');
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(height: 25),
                              ],
                            ),
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          isDarkMode = !isDarkMode;
                          isTextWhite = !isTextWhite;
                        },
                        backgroundColor: isDarkMode
                            ? Colors.white
                            : ThemeHelper().themeColor().deepPurple500,
                        child: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode),
                      ),
                    ),
                  ));
            }),
          ),
        ));
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
