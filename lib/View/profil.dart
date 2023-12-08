import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/config/theme.dart';
//import 'package:ugd1/database/sql_helper_user.dart';
import 'package:flutter/services.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/client/UserClient.dart';
import 'package:ugd1/model/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  Uint8List? imageProfile;
  final formKey = GlobalKey<FormState>();

  String convertUint8ListToBase64String(Uint8List? uint8list) {
    if (uint8list != null && uint8list.isNotEmpty) {
      return base64Encode(uint8list);
    }
    return ''; // Return empty string or handle null case based on your requirement
  }

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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedImage = prefs.getString('user_image');
    if (storedImage != null && storedImage.isNotEmpty) {
      // If image is stored in SharedPreferences, decode and set it as the profile image
      setState(() {
        imageProfile = base64Decode(storedImage);
      });
    } else {
      // Load the default image if no image is stored in SharedPreferences
      Uint8List defaultImage = await loadDefaultImage();
      setState(() {
        imageProfile = defaultImage;
      });

      // Save the default image to SharedPreferences
      _saveImageToPrefs(defaultImage);

      // Update the default image in the database
      User user = await UserClient.find(idUser);
      String base64DefaultImage = base64Encode(defaultImage);
      await UserClient.updateImage(user, base64DefaultImage);
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
      String base64Image = convertUint8ListToBase64String(imageProfile);

      User userData = User(
        id: idUser,
        name: usernameController.text,
        password: passwordController.text,
        email: emailController.text,
        phoneNumber: phoneNumberController.text,
        birthDate: birthdateController.text,
        gender: genderController.text,
        imageProfile: base64Image,
      );

      setState(() {
        _isEditing = false;
      });
      await UserClient.update(userData);

      Fluttertoast.showToast(
        msg: 'Success update profile',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

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

  Future<void> updateProfileImage(Uint8List imageBytes) async {
    String base64Image = convertUint8ListToBase64String(imageBytes);

    // Update gambar di aplikasi
    setState(() {
      imageProfile = imageBytes;
    });

    // Mengambil user dari database
    User userData = await UserClient.find(idUser);

    // Memperbarui gambar di database
    await UserClient.updateImage(userData, base64Image);

    // Simpan gambar terpilih ke SharedPreferences
    _saveImageToPrefs(imageBytes);
  }

  // Contoh bagaimana Anda bisa memanggil fungsi updateProfileImage saat ada perubahan gambar profil
  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 25,
    );

    if (returnedImage == null) return;

    final imageFile = File(returnedImage.path);
    final imageBytes = await imageFile.readAsBytes();

    // Update gambar profil
    await updateProfileImage(imageBytes);
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      imageQuality: 25,
    );

    if (returnedImage == null) return;

    final imageFile = File(returnedImage.path);
    final imageBytes = await imageFile.readAsBytes();

    // Mengubah gambar menjadi base64
    String base64Image = base64Encode(imageBytes);

    // Simpan gambar terpilih ke SharedPreferences
    _saveImageToPrefs(imageBytes);

    // Update gambar di aplikasi
    setState(() {
      imageProfile = imageBytes;
    });

    // Mengambil user dari database
    User userData = await UserClient.find(idUser);

    // Memperbarui gambar di database
    await UserClient.updateImage(userData, base64Image);
  }

  Future<void> _saveImageToPrefs(Uint8List imageBytes) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String base64Image = base64Encode(imageBytes);
    await prefs.setString('user_image', base64Image);
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );

    if (pickedImage == null) return;

    final imageFile = File(pickedImage.path);
    final imageBytes = await imageFile.readAsBytes();
    final username = usernameController.text;

    // Update the image profile
    User user = await UserClient.find(idUser);
    String base64Image = base64Encode(imageBytes);
    user.imageProfile = base64Image;

    // Call the updateImage method with the updated User object
    await UserClient.updateImage(user, base64Image);

    setState(() {
      imageProfile = imageBytes;
      loadUserData();
    });
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
                      if (_isEditing) {
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
                                          Navigator.pop(context);
                                          _pickImageFromCamera();
                                        },
                                        icon: Icon(Icons.camera),
                                        label: Text("Camera"),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          _pickImageFromGallery();
                                        },
                                        icon: Icon(Icons.image),
                                        label: Text('Gallery'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 50.0,
                      backgroundImage:
                          imageProfile != null && imageProfile!.isNotEmpty
                              ? MemoryImage(imageProfile!)
                              : Image.asset('image/profilCat.jpg')
                                  .image, // Ubah bagian ini
                    ),
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
}
