import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd1/bloc/login_bloc.dart';
import 'package:ugd1/bloc/login_event.dart';
import 'package:ugd1/bloc/login_state.dart';
import 'package:ugd1/config/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/model/user.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ugd1/client/UserClient.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int userLogin = -1;
  List<Map<String, dynamic>> users = [];

  Future<bool> checkUserExist(
      String usernameInput, String passwordInput) async {
    try {
      // Call the searchUser method to check if the user exists
      final userId = await UserClient.searchUser(usernameInput, passwordInput);

      if (userId != -1) {
        userLogin = userId!;
        //save id utk login
        final prefs = await SharedPreferences.getInstance();
        prefs.setInt('id', userId);
        print('User id login: $userId');
        return true; //user exist
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // Future<void> getUserByIdAndProcess(int userId) async {
  //   final user = await SQLHelper.getUserById(userId);

  //   if (user != null) {
  //     final prefs = await SharedPreferences
  //         .getInstance(); // This is where you save the user's data.
  //     prefs.setInt('id', user['id']);
  //   } else {
  //     print('User not found');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              // if (state.formSubmissionState is SubmissionSuccess) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     const SnackBar(
              //       content: Text('Login Success'),
              //     ),
              //   );

              //   Navigator.of(context).pushReplacement(
              //     MaterialPageRoute(
              //       builder: (context) => HomeView(),
              //     ),
              //   );
              // }
              // if (state.formSubmissionState is SubmissionFailed) {
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(
              //       content: Text(
              //           (state.formSubmissionState as SubmissionFailed)
              //               .exception
              //               .toString()),
              //     ),
              //   );
              // }
            },
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
                                SizedBox(height: 55),
                                Text(
                                  "Login",
                                  style: CustomTextStyles.titleForm,
                                ),
                                SizedBox(height: 95),
                                _buildGambar(context),
                                SizedBox(height: 30),
                                CustomTextFormField(
                                  controller: usernameController,
                                  hintText: "Username",
                                  prefix: Container(
                                    margin: EdgeInsets.fromLTRB(15, 15, 15, 15),
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
                                  validator: (value) => value == ''
                                      ? 'Please enter your username'
                                      : null,
                                ),
                                SizedBox(height: 15),
                                CustomTextFormField(
                                  controller: passwordController,
                                  hintText: "Password",
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
                                const SizedBox(height: 30),

                                //tombol login
                                GestureDetector(
                                  child: CustomElevatedButton(
                                    height: 50,
                                    text: "Login",
                                    margin: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                    ),
                                    buttonStyle: CustomButtonStyles.fillPrimary,
                                    buttonTextStyle:
                                        CustomTextStyles.teksTombol,
                                    //tambah method login disini krn di ontapnya ga bisa
                                    onPressed: () async {
                                      try {
                                        if (formKey.currentState!.validate()) {
                                          if (await checkUserExist(
                                              usernameController.text,
                                              passwordController.text)) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text('Login Success'),
                                              ),
                                            );
                                            Navigator.pushNamed(
                                                context, AppRoutes.home);
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text('Login Failed'),
                                              ),
                                            );
                                          }
                                        }
                                      } catch (e) {
                                        print('Error during login: $e');
                                      }
                                    },
                                  ),
                                ),

                                const SizedBox(height: 25),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context,
                                            AppRoutes
                                                .forgotpassword); //route ke halaman forget pass
                                      },
                                      child: Text(
                                        "Forgot Password?     ",
                                        style:
                                            CustomTextStyles.labelAkunRegister,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AppRoutes.register);
                                      },
                                      child: Text(
                                        "Register",
                                        style: CustomTextStyles.labelRegister
                                            .copyWith(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
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
