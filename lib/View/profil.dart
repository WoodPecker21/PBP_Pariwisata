import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/config/theme.dart';
import 'package:flutter/services.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/widgets/custom_elevated_button.dart';
import 'package:ugd1/client/UserClient.dart';
import 'package:ugd1/model/user.dart';
import 'package:ugd1/View/landing_page_screen.dart';

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
  bool _obscurePassword = true;

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
    Uint8List defaultImage = Uint8List.fromList(await loadDefaultImage());
    setState(() {
      imageProfile = defaultImage;
    });
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
          actions: [],
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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10.0),
              bottomRight: Radius.circular(10.0),
            ),
          ),
          child: GestureDetector(
            onTap: () {
              // Trigger the image picker when the profile image is tapped
              showModalBottomSheet(
                context: context,
                builder: ((builder) {
                  return Container(
                    height: 150.0,
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context); // Close the modal
                                _pickImageFromCamera();
                              },
                              icon: Icon(Icons.camera),
                              label: Text("Camera"),
                            ),
                            TextButton.icon(
                              onPressed: () {
                                Navigator.pop(context); // Close the modal
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
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Profile Image
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: imageProfile.isNotEmpty
                          ? Image.memory(
                              imageProfile,
                              fit: BoxFit.cover,
                            ).image
                          : AssetImage('image/profilCat.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Camera/Edit Icon
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: usernameController,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: _isEditing ? Colors.black : Colors.grey,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          readOnly: !_isEditing,
                        ),
                      ),
                      if (_isEditing)
                        IconButton(
                          icon: Icon(Icons.save),
                          onPressed: () {
                            // Save logic here
                            print('Save button clicked');
                            // Call your function to save the edited data
                            saveEditedData();
                          },
                        ),
                      if (!_isEditing)
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Enter editing mode
                            setState(() {
                              _isEditing = true;
                            });
                          },
                        ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.email,
                    color: Colors.black,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: emailController,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: _isEditing ? Colors.black : Colors.grey,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.password,
                    color: Colors.black,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: passwordController,
                          obscureText:
                              _obscurePassword, // Use the _obscurePassword flag
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: _isEditing ? Colors.black : Colors.grey,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                // Toggle the password visibility
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.person_2_outlined,
                    color: Colors.black,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: genderController,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: _isEditing ? Colors.black : Colors.grey,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 25),
        Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '5',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 38, 82, 125),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'trips',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '79',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 38, 82, 125),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'photos',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(width: 2),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '20',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 38, 82, 125),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'comments',
                    style: TextStyle(color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        )),
        SizedBox(height: 25),
        InkWell(
          onTap: () {
            // Navigasi ke halaman landingPage.dart
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      LandingPageScreen()), // Sesuaikan dengan nama halaman dan path sebenarnya
            );
          },
          child: Container(
            child: ListTile(
              leading: Icon(
                Icons.dangerous,
                color: Colors.black,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontFamily: 'Poppins',
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ),
        ),
        SizedBox(height: 25),
        SizedBox(height: 25),
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
  }

  Future _pickImageFromCamera() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);

    if (returnedImage == null) return;
    final imageFile = File(returnedImage.path);
    final imageBytes = await imageFile.readAsBytes();
    final username = usernameController.text;
  }
}
