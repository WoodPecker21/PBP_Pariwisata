import 'package:flutter/material.dart';
import 'package:ugd1/View/login.dart';
import 'package:intl/intl.dart';
import 'package:ugd1/component/form_component.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController notelpController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  Future<void> showDatePickerDialog(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  bool? check1 = false;
  String? gender;

  void _showAlertDialog(BuildContext context) {
    AlertDialog alertDialog = AlertDialog(
      title: Text('Perhatian!'),
      content: Text('Apakah Data Sudah Benar?'),
      actions: <Widget>[
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).push(LoginView.route());
          },
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                child: Text(selectedDate != null
                    ? 'Tanggal Lahir: ${selectedDate!.toLocal()}'.split(' ')[0]
                    : 'Pilih Tanggal Lahir'),
              ),
              inputForm((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Username Tidak Boleh Kosong';
                }
                if (p0.toLowerCase() == 'anjing') {
                  return 'Tidak Boleh Menggunakan Kata Kasar';
                }
                return null;
              },
                  controller: usernameController,
                  hintTxt: "Username",
                  helperTxt: "Ucup Surucup",
                  iconData: Icons.person),

              // idel-------------
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 17), // Adjust the horizontal margin
                child: Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Laki-Laki"),
                        value: "Laki-Laki",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, // Move radio button to the left
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 3), // Adjust the spacing
                      ),
                    ),
                    const SizedBox(
                      width: 8, // Add spacing between radio buttons
                    ),
                    Expanded(
                      child: RadioListTile(
                        title: const Text("Perempuan"),
                        value: "Perempuan",
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                        controlAffinity: ListTileControlAffinity
                            .leading, // Move radio button to the left
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 3), // Adjust the spacing
                      ),
                    ),
                  ],
                ),
              ),
              // -----------------------
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Email Tidak Boleh Kosong';
                }
                if (!p0.contains('@')) {
                  return 'Email harus menggunakan @';
                }
                return null;
              }),
                  controller: emailController,
                  hintTxt: "Email",
                  helperTxt: "ucup@gmail.com",
                  iconData: Icons.email),
              inputForm(//*pola validasi bisa pakai regex
                  ((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Password Tidak Boleh Kosong';
                }
                if (p0.length < 5) {
                  return 'Password minimal 5 digit';
                }
                return null;
              }),
                  controller: passwordController,
                  hintTxt: "Password",
                  helperTxt: "xxxxxxx",
                  iconData: Icons.password,
                  password: true),
              inputForm(((p0) {
                if (p0 == null || p0.isEmpty) {
                  return 'Nomor Telepon Tidak Boleh Kosong';
                }
                //*contoh regex
                //* final RegExp regex = RegExp(r'^\0?[1-9]\d{1,14}$');
                //* if(!!regex.hasMatch(p0)){
                //*   return 'Nomor Telepon tidak valid';}
                return null;
              }),
                  controller: notelpController,
                  hintTxt: "No Telp",
                  helperTxt: "082123456789",
                  iconData: Icons.phone_android),

              //* --------------------------idel-------------------------

              Padding(
                padding: const EdgeInsets.only(left: 8, top: 10),
                child: CheckboxListTile(
                  value: check1,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (bool? value) {
                    setState(() {
                      check1 = value;
                    });
                  },
                  title: const Text("Saya Turis Domestik"),
                ),
              ),
              //------------ until here----------------

              inputForm(
                (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
                controller: dateController,
                hintTxt: "Tanggal",
                helperTxt: DateFormat('dd/MM/yyyy').format(selectedDate),
                iconData: Icons.calendar_today,
                onTap: () => showDatePickerDialog(context),
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> formData = {};
                      formData['username'] = usernameController.text;
                      formData['password'] = passwordController.text;
                      formData['date'] = dateController.text;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => LoginView(
                                    data: formData,
                                  )));
                    }
                  },
                  child: const Text('Register'))
            ],
          ),
        ),
      ),
    );
  }
}
