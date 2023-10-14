import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ugd1/bloc/form_submission_state.dart';
//import 'package:ugd_bloc/bloc/login_bloc.dart';
//import 'package:ugd_bloc/bloc/login_event.dart';
//import 'package:ugd_bloc/bloc/login_state.dart';
import 'package:ugd1/bloc/register_state.dart';
import 'package:ugd1/bloc/register_bloc.dart';
import 'package:ugd1/model/user.dart';
import 'package:ugd1/repository/register_repository.dart';
import 'package:ugd1/bloc/register_event.dart';
import 'package:ugd1/View/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// ...

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  //kasih nilai default supaya bisa disubmit, klu disini nullable ga bisa
  Future<bool> checkEmailUniqueness(String email) async {
    for (int i = 0; i < RegisterRepository.userAccount.length; i++) {
      if(RegisterRepository.userAccount[i].email == email){
        return false; //email sudah digunakan
      }
    }
    return true; //email unik
  }

  final formKey = GlobalKey<FormState>(); // Tambahkan ini untuk Form

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterBloc>(
      create: (context) => RegisterBloc(),
      child: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            //nanti cek apa masih form succes
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Register Success'),
              ),
            );
            // Buat balik ke login lagi cuy
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => Loginview(),
              ),
            );
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (state.formSubmissionState as SubmissionFailed)
                      .exception
                      .toString(),
                ),
              ),
            );
          }
        },
        child:
            BlocBuilder<RegisterBloc, RegisterState>(builder: (context, state) {
          return SafeArea(
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
                        validator: (value) =>
                            value == '' ? 'Username harus terisi!!' : null,
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
                        validator: (value) =>
                            value == '' ? 'Password harus terisi!!' : null,
                      ),
                      TextFormField(
                        controller: phoneNumberController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter
                              .digitsOnly, //biar inputan cuman angka
                        ],
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone),
                          labelText: 'Nomor Telepon',
                        ),
                        validator: (value) {
                          if (value == '') {
                            return 'Nomor telepon harus terisi!!';
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
                              if (selectedDate.year > 2023) {
                                return 'Tahun lebih dari tahun ini!!';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              // await Future.delayed(const Duration(seconds: 3));
                              bool isEmailUnique = await checkEmailUniqueness(emailController.text);
                              
                              if(isEmailUnique){
                                context.read<RegisterBloc>().add(
                                    RegisterButtonPressed(
                                      username: usernameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phoneNumber: phoneNumberController.text,
                                      birthDate: selectedDate,
                                    ),
                                  );
                              }else{
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Center(
                                    child: Text(
                                      'Email is already in use. Please use a different email.',
                                    ),
                                  ),
                                ));
                              }
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 16.0,
                            ),
                            child: state.formSubmissionState is FormSubmitting
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text('Register'),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Sudah mempunyai akun?   ",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const Loginview(),
                                ),
                              );
                            },
                            child: const Text(
                              "LogIn",
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
            ),
          );
        }),
      ),
    );
  }
}
