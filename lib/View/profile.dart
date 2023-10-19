import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/config/theme.dart';
import 'package:ugd1/database/sql_helper_user.dart';

// void main() {
//   runApp(Profile());
// }
class ProfileData {
  final String username;
  final String email;
  final String phoneNumber;
  final String birthdate;

  ProfileData({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.birthdate,
  });
}

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String username = "";
  String email = "";
  String phoneNumber = "";
  String birthdate = "";
  int idUser = 0;

  @override
  void initState() {
    super.initState();
    // Mengambil data dari SharedPreferences saat tampilan profil dimuat
    _loadProfileData();
  }

  _loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? "";
      email = prefs.getString('email') ?? "";
      phoneNumber = prefs.getString('phoneNumber') ?? "";
      birthdate = prefs.getString('birthdate') ?? "";
      idUser = prefs.getInt('id') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile',
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Row(
            children: [
              Text('Profile'), // Judul "Profile" di sebelah kiri
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                final updatedProfile = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditProfilePage(
                      username: username,
                      email: email,
                      phoneNumber: phoneNumber,
                      birthdate: birthdate,
                      id: idUser,
                    ),
                  ),
                );

                if (updatedProfile != null) {
                  // Jika ada data yang dikirim kembali, perbarui data profil
                  setState(() {
                    username = updatedProfile.username;
                    email = updatedProfile.email;
                    phoneNumber = updatedProfile.phoneNumber;
                    birthdate = updatedProfile.birthdate;
                  });
                }
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white70,
                        minRadius: 60.0,
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: AssetImage('image/kuliner.jpg'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
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
              child: Column(
                children: <Widget>[
                  Divider(),
                  ListTile(
                    title: const Text(
                      'Email',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      email,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: const Text(
                      'Nomor Telepon',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(
                    title: const Text(
                      'Tanggal Lahir',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      birthdate,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Divider(),
                  ListTile(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class EditProfilePage extends StatefulWidget {
  final String username;
  final String email;
  final String phoneNumber;
  final String birthdate;
  final int id;

  EditProfilePage({
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.birthdate,
    required this.id,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController phoneNumberController;
  late TextEditingController birthdateController;
  late int idUser;

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data profil saat ini
    usernameController = TextEditingController(text: widget.username);
    emailController = TextEditingController(text: widget.email);
    phoneNumberController = TextEditingController(text: widget.phoneNumber);
    birthdateController = TextEditingController(text: widget.birthdate);
    idUser = widget.id;
  }

  @override
  void dispose() {
    // Pastikan untuk menghentikan controller saat widget di-dispose untuk menghindari memory leaks
    usernameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    birthdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Center(
          child: const Text('Edit Profile'),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(labelText: 'Username'),
          ),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextFormField(
            controller: phoneNumberController,
            decoration: InputDecoration(labelText: 'Nomor Telepon'),
          ),
          TextFormField(
            controller: birthdateController,
            decoration: InputDecoration(labelText: 'Tanggal Lahir'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final updatedProfile = ProfileData(
                username: usernameController.text,
                email: emailController.text,
                phoneNumber: phoneNumberController.text,
                birthdate: birthdateController.text,
              );
              //save ke sql
              SQLHelper.editUser(
                  idUser,
                  usernameController.text,
                  emailController.text,
                  phoneNumberController.text,
                  birthdateController.text);

              // Kirim data yang diperbarui ke halaman Profile
              Navigator.of(context).pop(updatedProfile);

              // Tampilkan SnackBar sebagai notifikasi
              final snackBar = SnackBar(
                content: Text('Data berhasil diperbarui'),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text('Simpan Perubahan'),
          ),
        ],
      ),
    );
  }

  final snackBar = SnackBar(
    content: Text('Data berhasil diperbarui'),
    duration: Duration(seconds: 3), // Durasi tampilan SnackBar
    action: SnackBarAction(
      label: 'Tutup', // Label tombol aksi
      onPressed: () {
        // Aksi yang dijalankan saat tombol aksi ditekan (misalnya, untuk menutup SnackBar)
      },
    ),
  );

  void _saveUpdatedProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', usernameController.text);
    prefs.setString('email', emailController.text);
    prefs.setString('phoneNumber', phoneNumberController.text);
    prefs.setString('birthdate', birthdateController.text);
  }
}
