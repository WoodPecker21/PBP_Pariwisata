import 'package:flutter/material.dart';
import '../database/sql_helper.dart';
import '../model/objekWisata.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class InputPage extends StatefulWidget {
  const InputPage(
      {super.key,
      required this.title,
      required this.id,
      required this.nama,
      required this.deskripsi,
      required this.kategori,
      required this.gambar,
      required this.rating,
      required this.harga});

  final String? title, nama, deskripsi, kategori, gambar;
  final int? id, rating;
  final double? harga;

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  TextEditingController controllerHarga = TextEditingController();
  double _rating = 0.0;
  double hargaInput = 0;
  String _selectedValue = 'Alam';
  String gambarPath = 'image/alam.jpg'; //defaultnya path ke gambar alam

  @override
  Widget build(BuildContext context) {
    if (widget.id != null) {
      //isi juga dropdown + rating nanti
      controllerNama.text = widget.nama!;
      controllerDeskripsi.text = widget.deskripsi!;
      controllerHarga.text = widget.harga.toString();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("INPUT OBJEK WISATA"),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerNama,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nama',
              ),
            ),
            SizedBox(height: 24),
            Container(
              height: 150, // Set a specific height for the TextField
              child: TextField(
                controller: controllerDeskripsi,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Deskripsi',
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: controllerHarga,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Harga',
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Kategori: ',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(width: 24),
                DropdownButton<String>(
                  value: _selectedValue,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    }
                  },
                  items: <String>[
                    'Alam',
                    'Budaya',
                    'Komersial',
                    'Kuliner',
                    'Maritim',
                    'Religius'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text(
              'Rating: $_rating',
              style: TextStyle(fontSize: 20),
            ),
            RatingBar.builder(
              initialRating: _rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 48,
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber, // Set star color to gold
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _rating = rating;
                });
              },
            ),
            SizedBox(height: 48),
            ElevatedButton(
              child: Text('Save'),
              onPressed: () async {
                if (widget.id == null) {
                  initData();
                  await addObjectWisata();
                } else {
                  await editObjekWisata(widget.id!);
                }
                Navigator.pop(context);
              },
            )
          ],
        ));
  }

  void initData() {
    String text = controllerHarga.text;

    try {
      hargaInput = double.parse(text);
    } catch (e) {
      // Handle the case where the input cannot be converted to a double
      hargaInput = 0.0; // Set a default value to handle the error
    }

    switch (_selectedValue) {
      case 'Alam':
        gambarPath = 'image/alam.jpg';
        break;

      case 'Budaya':
        gambarPath = 'image/budaya.jpeg';
        break;

      case 'Komersial':
        gambarPath = 'image/komersial.jpg';
        break;

      case 'Kuliner':
        gambarPath = 'image/kuliner.jpg';
        break;

      case 'Maritim':
        gambarPath = 'image/maritim.jpg';
        break;

      case 'Religius':
        gambarPath = 'image/religius.jpg';
        break;
    }
  }

  Future<void> addObjectWisata() async {
    await SQLHelper.addObjekWisata(
        controllerNama.text,
        controllerDeskripsi.text,
        _selectedValue,
        gambarPath,
        _rating,
        hargaInput);
  }

  Future<void> editObjekWisata(int id) async {
    await SQLHelper.editObjekWisata(
        id,
        controllerNama.text,
        controllerDeskripsi.text,
        _selectedValue,
        gambarPath,
        _rating,
        hargaInput);
  }
}
