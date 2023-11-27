import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/database/sql_helper_user.dart';
import 'package:flutter/services.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ugd1/client/UserClient.dart';
import 'package:ugd1/model/user.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  bool _isEditing = false;
  int idUser = 0;
  String username = "";
  Uint8List imageProfile = Uint8List(0);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadProfileData();
    print('initState');
    super.initState();
  }

  Future<void> loadProfileData() async {
    await loadUserData();
    await loadImageProfile();
  }

  Future<void> loadImageProfile() async {
    Uint8List? imageData = await SQLHelper.getImageProfile(idUser);
    if (imageData != null && imageData.isNotEmpty) {
      setState(() {
        imageProfile = imageData;
      });
    } else {
      // Set default image when imageData is null or empty
      Uint8List defaultImage = Uint8List.fromList(await loadDefaultImage());
      setState(() {
        imageProfile = defaultImage;
      });
    }
    print('load image');
  }

  Future<Uint8List> loadDefaultImage() async {
    // Load the default asset image and convert it to Uint8List
    final ByteData data = await rootBundle.load('image/profilCat.jpg');
    return data.buffer.asUint8List();
  }

  Future<void> loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      idUser = prefs.getInt('id') ?? 0;
      print('idUser: $idUser');

      User res = await UserClient.find(idUser);
      setState(() {
        usernameController.value = TextEditingValue(text: res.name!);
        emailController.value = TextEditingValue(text: res.email!);
        phoneNumberController.value = TextEditingValue(text: res.phoneNumber!);
        birthdateController.value = TextEditingValue(text: res.birthDate!);
        passwordController.value = TextEditingValue(text: res.password!);
        genderController.value = TextEditingValue(text: res.gender!);
        username = res.name!;
      });
    } catch (e) {
      print('Error load user data: $e');
    }
  }

  Future<void> saveEditedData() async {
    try {
      User user = User(
        id: idUser,
        name: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        birthDate: birthdateController.text,
        gender: genderController.text,
        imageProfile: null, //biarkan dulu
      );

      setState(() {
        _isEditing = false;
      });
      await UserClient.update(user);

      print('User updated successfully');
    } catch (e) {
      // Handle error during user creation
      print('Error updating user: $e');
    }
  }

  bool isEmailUnik = false;

  Future<void> checkEmailUnik() async {
    try {
      // Call the cekEmailUnik method from UserClient
      bool getEmailUnik =
          await UserClient.cekEmailUnikEdit(emailController.text, idUser);

      setState(() {
        isEmailUnik = getEmailUnik;
      });
      print('dapat email unik: $isEmailUnik');
    } catch (e) {
      // Handle errors as needed
      print('Error checking email uniqueness: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            children: [
              _isEditing
                  ? const Text(
                      'Editing Profile..',
                      style: TextStyle(color: Colors.black),
                    )
                  : const Text(
                      'Profile',
                      style: TextStyle(color: Colors.black),
                    ), // Judul "Profile" di sebelah kiri
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                setState(() {
                  _isEditing = !_isEditing;
                });
                loadUserData();
              },
              color: Colors.black,
            ),
          ],
        ),
        body: buildProfileContent(),
      ),
    );
  }

  Widget buildProfileContent() {
    return ListView(
      children: <Widget>[
        Container(
          height: 250,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      await showModalBottomSheet(
                        context: context,
                        builder: ((builder) {
                          return Container(
                            height: 110.0,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 20,
                            ),
                            child: Column(
                              children: <Widget>[
                                Text(
                                  "Choose Profile Photo",
                                  style: TextStyle(
                                    fontSize: 20.0,
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    TextButton.icon(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the modal
                                          _pickImageFromCamera();
                                        },
                                        icon: Icon(Icons.camera),
                                        label: Text("Camera")),
                                    TextButton.icon(
                                        onPressed: () {
                                          Navigator.pop(
                                              context); // Close the modal
                                          _pickImageFromGallery();
                                        },
                                        icon: Icon(Icons.image),
                                        label: Text('Gallery'))
                                  ],
                                )
                              ],
                            ),
                          );
                        }),
                      );
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: imageProfile.isNotEmpty
                              ? Image.memory(
                                  imageProfile, // Uint8List image data
                                  fit: BoxFit
                                      .cover, // Choose the appropriate BoxFit
                                ).image // Use MemoryImage for Uint8List
                              : const AssetImage(
                                  'image/profilCat.jpg'), // Default image if imageProfile is empty
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                username,
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        Container(
            child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20),
              ListTile(
                title: Text('Username',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontFamily: 'Poppins',
                    )),
                subtitle: TextFormField(
                  controller: usernameController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: _isEditing ? Colors.black : Colors.grey,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username harus terisi!!';
                    } else if (value.length <= 5) {
                      return 'Username minimal memiliki 5 karakter!';
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                subtitle: TextFormField(
                  controller: passwordController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: _isEditing ? Colors.black : Colors.grey,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password harus terisi!!';
                    } else if (value.length < 5) {
                      return 'Password minimal memiliki 5 karakter!';
                    }
                    return null;
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                    fontFamily: 'Poppins',
                  ),
                ),
                subtitle: TextFormField(
                  controller: emailController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: _isEditing ? Colors.black : Colors.grey,
                  ),
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
              ),
              ListTile(
                title: Text(
                  'Nomor Telepon',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                subtitle: TextFormField(
                  controller: phoneNumberController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: _isEditing ? Colors.black : Colors.grey,
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
              ),
              ListTile(
                title: Text(
                  'Tanggal Lahir',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: TextFormField(
                  controller: birthdateController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: _isEditing ? Colors.black : Colors.grey,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tanggal lahir harus terisi!!';
                    }

                    return null;
                  },
                ),
              ),
              ListTile(
                title: Text(
                  'Jenis Kelamin',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                ),
                subtitle: TextFormField(
                  controller: genderController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: _isEditing ? Colors.black : Colors.grey,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jenis Kelamin harus terisi!!';
                    } else if (value != 'Laki-Laki' && value != 'Perempuan') {
                      return 'Jenis kelamin hanya bisa Laki-laki atau Perempuan';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 20),
              if (_isEditing) // Conditionally show the Save button
                CustomElevatedButton(
                  height: 50,
                  text: "Simpan",
                  margin: EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  buttonStyle: CustomButtonStyles.fillPrimary,
                  buttonTextStyle: CustomTextStyles.teksTombol,
                  onPressed: () async {
                    await checkEmailUnik();
                    if (formKey.currentState!.validate()) {
                      await saveEditedData();
                    }
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        ))
      ],
    );
  }

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (returnedImage == null) return;
    final imageFile = File(returnedImage.path);
    final imageBytes = await imageFile.readAsBytes();
    final username = usernameController.text;

    final result = await SQLHelper.updateProfileImages(username, imageBytes);

    if (result > 0) {
      setState(() {
        imageProfile = imageBytes;
        loadUserData();
      });
    }
  }

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);

    if (returnedImage == null) return;
    final imageFile = File(returnedImage.path);
    final imageBytes = await imageFile.readAsBytes();
    final username = usernameController.text;

    final result = await SQLHelper.updateProfileImages(username, imageBytes);

    if (result > 0) {
      setState(() {
        imageProfile = imageBytes;
        loadUserData();
      });
    }
  }
}
