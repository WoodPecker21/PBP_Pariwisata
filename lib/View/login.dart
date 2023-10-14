import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd1/View/home.dart';
//import 'package:ugd1/View/profile.dart';
import 'package:ugd1/bloc/form_submission_state.dart';
import 'package:ugd1/bloc/login_bloc.dart';
import 'package:ugd1/bloc/login_event.dart';
import 'package:ugd1/bloc/login_state.dart';
import 'package:ugd1/View/register.dart';
import 'package:ugd1/config/theme.dart';

class Loginview extends StatefulWidget {
  const Loginview({super.key});

  @override
  State<Loginview> createState() => _LoginviewState();
}

class _LoginviewState extends State<Loginview> {
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: Scaffold(
          body: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state.formSubmissionState is SubmissionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Login Success'),
                  ),
                );

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => HomeView(),
                  ),
                );
              }
              if (state.formSubmissionState is SubmissionFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        (state.formSubmissionState as SubmissionFailed)
                            .exception
                            .toString()),
                  ),
                );
              }
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  prefixIcon: Icon(Icons.person),
                                  labelText: 'Username',
                                ),
                                validator: (value) => value == ''
                                    ? 'Please enter your username'
                                    : null,
                              ),
                              TextFormField(
                                controller: passwordController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock),
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
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
                                          : Colors.blue,
                                    ),
                                  ),
                                ),
                                obscureText: state.isPasswordVisible,
                                validator: (value) => value == ''
                                    ? 'Please enter your password'
                                    : null,
                              ),
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<LoginBloc>().add(
                                            FormSubmitted(
                                              username: usernameController.text,
                                              password: passwordController.text,
                                            ),
                                          );
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16.0,
                                      horizontal: 16.0,
                                    ),
                                    child: state.formSubmissionState
                                            is FormSubmitting
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : const Text("Login"),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 25),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Belum mempunyai akun?   ",
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const RegisterPage(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            isDarkMode = !isDarkMode;
                            isTextWhite = !isTextWhite;
                          });
                        },
                        child: Icon(
                            isDarkMode ? Icons.light_mode : Icons.dark_mode),
                      ),
                    ),
                  ));
            }),
          ),
        ));
  }
}
