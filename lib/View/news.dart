import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ugd1/client/NewsClient.dart';
import 'package:ugd1/model/news.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ugd1/View/newsUser.dart';

// Buat model untuk data berita
class NewsData {
  final String judul;
  final String isiBerita;
  final String pengarang;

  NewsData({
    required this.judul,
    required this.isiBerita,
    required this.pengarang,
  });
}

// Halaman input untuk menambahkan data berita
class NewsPageInput extends StatefulWidget {
  const NewsPageInput({Key? key}) : super(key: key);

  @override
  State<NewsPageInput> createState() => _NewsPageInputState();
}

class _NewsPageInputState extends State<NewsPageInput> {
  final formKey = GlobalKey<FormState>();
  TextEditingController controllerJudul = TextEditingController();
  TextEditingController controllerIsiBerita = TextEditingController();
  TextEditingController controllerPengarang = TextEditingController();
  File? _imageFile;

  Future<void> insertData() async {
    try {
      if (controllerJudul.text.isEmpty ||
          controllerIsiBerita.text.isEmpty ||
          controllerPengarang.text.isEmpty) {
        print('All fields are required');
        return;
      }

      News objek = News(
        judul: controllerJudul.text,
        isiBerita: controllerIsiBerita.text,
        pengarang: controllerPengarang.text,
        gambar: null,
      );

      await NewsClient.create(objek);
      print('Data berhasil disimpan');
    } catch (e) {
      print('Error: $e');
    }

    print('Judul: ${controllerJudul.text}');
    print('Isi Berita: ${controllerIsiBerita.text}');
    print('Pengarang: ${controllerPengarang.text}');
    print(
        'Gambar: ${_imageFile != null ? _imageFile!.path : 'No image selected'}');
  }

  // Future<void> navigateToNewsPage(BuildContext context) async {
  //   NewsData data = NewsData(
  //     judul: controllerJudul.text,
  //     isiBerita: controllerIsiBerita.text,
  //     pengarang: controllerPengarang.text,
  //   );

  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => NewsPage(newsData: data),
  //     ),
  //   );
  // }
  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );

    if (pickedImage == null) return;
    final imageFile = File(pickedImage.path);

    setState(() {
      _imageFile = imageFile;
    });
  }

  Future<void> _pickImageFromGallery() async {
    await _pickImage(ImageSource.gallery);
  }

  Future<void> _pickImageFromCamera() async {
    await _pickImage(ImageSource.camera);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Insert News"),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              controller: controllerJudul,
              decoration: InputDecoration(
                labelText: 'Judul',
                hintText: 'Masukkan judul',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Judul tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 24),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: SingleChildScrollView(
                child: TextFormField(
                  controller: controllerIsiBerita,
                  decoration: InputDecoration(
                    hintText: 'Isi Berita',
                    contentPadding: EdgeInsets.all(8.0),
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Isi Berita tidak boleh kosong';
                    }
                    return null;
                  },
                  maxLines: null,
                ),
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: controllerPengarang,
              decoration: InputDecoration(
                labelText: 'Nama Pengarang',
                hintText: 'Masukkan nama pengarang',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama Pengarang tidak boleh kosong';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Pick Image',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            Row(
              children: <Widget>[
                ElevatedButton(
                  onPressed: _pickImageFromGallery,
                  child: Text("Gallery"),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _pickImageFromCamera,
                  child: Text("Camera"),
                ),
              ],
            ),
            SizedBox(height: 24),
            _imageFile != null
                ? Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(_imageFile!),
                      ),
                    ),
                  )
                : Container(),
            SizedBox(height: 24),
            ElevatedButton(
              key: Key('simpan'),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await insertData();
                }
              },
              child: Text("Simpan Data"),
            ),
          ],
        ),
      ),
    );
  }
}
