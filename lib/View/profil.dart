import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/database/sql_helper_user.dart';
import 'package:flutter/services.dart';

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

  bool _isEditing = false;
  int idUser = 0;
  String username = "";
  Uint8List imageProfile = Uint8List(0);
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    loadProfileData();
    refresh();
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    idUser = prefs.getInt('id') ?? 0;
    print('idUser: $idUser');

    final user = await SQLHelper.getUserById(idUser);
    if (user != null) {
      usernameController.text = user['name'] ?? '';
      emailController.text = user['email'] ?? '';
      phoneNumberController.text = user['phoneNumber'] ?? '';
      passwordController.text = user['password'] ?? '';
      birthdateController.text = user['birthDate'] ?? '';
      setState(() {
        username = user['name'] ?? '';
      });
    } else {
      // Handle the case when user is null
      print('User not found or is null.');
    }
    print('load data');
  }

  Future<void> saveEditedData() async {
    try {
      final username = usernameController.text;
      await SQLHelper.updateProfileImages(username, imageProfile);

      await SQLHelper.editUser(
        idUser,
        username,
        emailController.text,
        phoneNumberController.text,
        birthdateController.text,
        imageProfile,
      );

      setState(() {
        _isEditing = false;
      });
      print('edited di database id user: $idUser');

      // User edited successfully
    } catch (e) {
      // Handle database insertion error here
      print('Error editing user: $e');
    }
  }

  List<Map<String, dynamic>> users = [];

  void refresh() async {
    final data = await SQLHelper.getUser();
    setState(() {
      users = data;
    });
  }

  bool cekEmailUnik(String emailInput, List<Map<String, dynamic>> users) {
    for (Map<String, dynamic> user in users) {
      String? userEmail = user['email'];
      if (userEmail == emailInput) {
        if (idUser != user['id']) {
          return false;
        }
      }
      if (userEmail == null) {
        return true;
      }
    }
    return true;
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
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 10, 76, 131),
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
                            height: 100.0,
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
                title: const Text(
                  'Username',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: TextFormField(
                  controller: usernameController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
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
                title: const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                subtitle: TextFormField(
                  controller: passwordController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
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
                title: const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                subtitle: TextFormField(
                  controller: emailController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
                    color: _isEditing ? Colors.black : Colors.grey,
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
              ),
              ListTile(
                title: const Text(
                  'Nomor Telepon',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                subtitle: TextFormField(
                  controller: phoneNumberController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
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
                title: const Text(
                  'Tanggal Lahir',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: TextFormField(
                  controller: birthdateController,
                  readOnly: !_isEditing,
                  style: TextStyle(
                    fontSize: 18,
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
              const SizedBox(height: 20),
              if (_isEditing) // Conditionally show the Save button
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await saveEditedData();
                    }
                  },
                  child: const Text('SIMPAN', style: TextStyle(fontSize: 20)),
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
