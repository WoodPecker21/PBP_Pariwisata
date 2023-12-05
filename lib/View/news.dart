import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ugd1/client/NewsClient.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:ugd1/model/news.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ugd1/View/newsUser.dart';

// Buat model untuk data berita
class NewsData {
  final String namaDestinasi;
  final String pulau;
  final String deskripsi;
  final double rating;

  NewsData({
    required this.namaDestinasi,
    required this.pulau,
    required this.deskripsi,
    required this.rating,
  });
}

// Halaman input untuk menambahkan data berita
class NewsPageInput extends StatefulWidget {
  const NewsPageInput({Key? key}) : super(key: key);

  @override
  State<NewsPageInput> createState() => _NewsPageInputState();
}

class _NewsPageInputState extends State<NewsPageInput> {
  TextEditingController controllerNamaDestinasi = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  TextEditingController controllerProvinsi = TextEditingController();
  double _rating = 0.0;
  File? _imageFile;
  bool isUpdate = false;
  int updatedId = 0;

  @override
  void initState() {
    super.initState();
    cekUpdate();
  }

  Future<void> cekUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('idUpdate')) {
        int idNewsUpdate = prefs.getInt('idUpdate') ?? 0;

        final news = await NewsClient.find(idNewsUpdate);

        setState(() {
          _rating = news.rating ?? 0;
          controllerNamaDestinasi.text = news.namaDestinasi ?? '';
          controllerDeskripsi.text = news.deskripsi ?? '';
          controllerProvinsi.text =
              news.provinsi ?? ''; // Assign the selected province
          updatedId = news.id ?? 0;
        });

        setState(() {
          isUpdate = true;
        });
      }
    } catch (e) {
      print('error di retrieve update data: $e');
    }
  }

  Future<void> insertData() async {
    try {
      News objek = News(
        namaDestinasi: controllerNamaDestinasi.text,
        deskripsi: controllerDeskripsi.text,
        provinsi: controllerProvinsi.text,
        rating: _rating,
        gambar: null,
      );

      await NewsClient.create(objek);
      print('Data berhasil disimpan');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      News objek = News(
        id: updatedId,
        namaDestinasi: controllerNamaDestinasi.text,
        deskripsi: controllerDeskripsi.text,
        provinsi: controllerProvinsi.text,
        rating: _rating,
        gambar: null,
      );

      await NewsClient.update(objek);
      prefs.remove('idUpdate');
      print('Data berhasil diupdate');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> navigateToNewsPage(BuildContext context) async {
    NewsData data = NewsData(
      namaDestinasi: controllerNamaDestinasi.text,
      pulau: controllerProvinsi.text,
      deskripsi: controllerDeskripsi.text,
      rating: _rating,
    );

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsPage(newsData: data),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (returnedImage == null) return;
    final imageFile = File(returnedImage.path);

    setState(() {
      _imageFile = imageFile;
    });

    await navigateToNewsPage(context);
  }

  Future<void> _pickImageFromCamera() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 25);

    if (returnedImage == null) return;
    final imageFile = File(returnedImage.path);

    setState(() {
      _imageFile = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isUpdate ? "Update News" : "Insert News"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerNamaDestinasi,
            decoration: InputDecoration(labelText: 'Destination Name'),
          ),
          SizedBox(height: 24),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Pilih Pulau',
              border: OutlineInputBorder(),
            ),
            items: ['Kalimantan', 'Jawa', 'Sumatera'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              // Handle dropdown value change
            },
          ),
          SizedBox(height: 24),
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border
                  .all(), // Just for demonstration, you can adjust the border
            ),
            child: SingleChildScrollView(
              child: TextFormField(
                controller: controllerDeskripsi,
                decoration: InputDecoration(
                  hintText: 'Isi Berita',
                  contentPadding: EdgeInsets.all(8.0),
                  border: InputBorder.none, // Remove the default border
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Isi Berita tidak boleh kosong';
                  }
                  return null; // Return null when the input is valid
                },
                maxLines: null,
              ),
            ),
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
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                'Rating   : $_rating',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontFamily: 'Poppins'),
              )),
          RatingBar.builder(
            initialRating: _rating,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemSize: 48,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () async {
              if (isUpdate) {
                await updateData();
              } else {
                await insertData();
              }
              Navigator.pop(context); // Kembali ke halaman sebelumnya setelah penyimpanan berhasil

              // Navigasi ke halaman NewsPage setelah penyimpanan berhasil
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsPage(
                    newsData: NewsData(
                      namaDestinasi: controllerNamaDestinasi.text,
                      pulau: controllerProvinsi.text, // Dapat diubah sesuai dengan nilai Dropdown
                      deskripsi: controllerDeskripsi.text,
                      rating: _rating,
                    ),
                  ),
                ),
              );
            },
            child: Text("Simpan Data"),
          )
        ],
      ),
    );
  }
}

// Halaman untuk menampilkan detail berita
// class NewsPage extends StatelessWidget {
//   final NewsData newsData;

//   const NewsPage({Key? key, required this.newsData}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("News Details"),
//       ),
//       body: Container(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text("Destination: ${newsData.namaDestinasi}"),
//             Text("Island: ${newsData.pulau}"),
//             Text("Description: ${newsData.deskripsi}"),
//             Text("Rating: ${newsData.rating}"),
//             // ... Other details
//           ],
//         ),
//       ),
//     );
//   }
// }
