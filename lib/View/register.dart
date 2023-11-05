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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Username',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Username harus terisi!!';
                                  } else if (value.length < 5) {
                                    return 'Username minimal memiliki 5 karakter!';
                                  }
                                  return null;
                                },
                              ),
                              TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.email),
                                  labelText: 'Email',
                                ),
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
                              TextFormField(
                                  controller: passwordController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.lock),
                                    labelText: 'Password',
                                    suffixIcon: IconButton(
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
                                            : Colors.blue,
                                      ),
                                    ),
                                  ),
                                  obscureText: state.isPasswordVisible,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password harus terisi!!';
                                    } else if (value.length < 5) {
                                      return 'Password minimal memiliki 5 karakter!';
                                    }
                                    return null;
                                  }),
                              TextFormField(
                                controller: phoneNumberController,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.phone),
                                  labelText: 'Nomor Telepon',
                                ),
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
                                    birthdateController.text = formattedDate;
                                  }
                                },
                                child: AbsorbPointer(
                                  child: TextFormField(
                                    controller: birthdateController,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.calendar_today),
                                      labelText: 'Tanggal Lahir',
                                    ),
                                    readOnly: true,
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
                                child: ElevatedButton(
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
                                      // final user = User(
                                      //   name: usernameController.text,
                                      //   email: emailController.text,
                                      //   phoneNumber: phoneNumberController.text,
                                      //   birthDate: birthdateController.text,
                                      // );
                                      // saveUserToSharedPreferences(
                                      //     user); // This is where you save the user's data.

                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) => Loginview(),
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 16.0,
                                    ),
                                    child: const Text('Register'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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
}
