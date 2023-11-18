import 'package:flutter/material.dart';
import '../database/sql_helper_objek.dart';
import '../model/objekWisata.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ugd1/View/pdf_view.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

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
  String id = const Uuid().v1();
  bool isUpdate = false;
  int updatedId = 0;

  void initState() {
    super.initState();
    cekUpdate();
  }

  Future<void> cekUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('idUpdate')) {
        int idObjekUpdate = prefs.getInt('idUpdate') ?? 0;

        //jika merupakan update maka retrieve dulu data dari database
        Map<String, dynamic>? objekWisata =
            await SQLHelper.getObjekWisataById(idObjekUpdate);
        if (objekWisata != null) {
          setState(() {
            _selectedValue = objekWisata['kategori'];
            _rating = objekWisata['rating'];
            controllerNama.text = objekWisata['nama'];
            controllerDeskripsi.text = objekWisata['deskripsi'];
            controllerHarga.text = objekWisata['harga'].toString();
            updatedId = objekWisata['id'];
          });
        }
        setState(() {
          isUpdate = true;
        });
      }
    } catch (e) {
      print('error di retrieve update data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Data Objek Wisata"),
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
              height: 150,
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
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
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
                color: Colors.amber,
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
                // Validasi Nama
                if (controllerNama.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nama tidak boleh kosong'),
                    ),
                  );
                  return;
                }

                // Validasi Deskripsi
                if (controllerDeskripsi.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deskripsi tidak boleh kosong'),
                    ),
                  );
                  return;
                }

                // Validasi Harga
                double hargaInput = 0.0;
                if (controllerHarga.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Harga tidak boleh kosong'),
                    ),
                  );
                  return;
                } else {
                  try {
                    hargaInput = double.parse(controllerHarga.text);
                    if (hargaInput <= 0) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Harga harus lebih dari 0'),
                        ),
                      );
                      return;
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Harga harus dalam format angka'),
                      ),
                    );
                    return;
                  }
                }

                // Validasi Rating
                if (_rating < 0 || _rating > 5) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Rating harus dalam rentang 0 hingga 5'),
                    ),
                  );
                  return;
                }

                if (isUpdate == false) {
                  print('ini add data');
                  initData();
                  await addObjectWisata();
                } else {
                  print('ini edit data');
                  await editObjekWisata(updatedId);
                }
                Navigator.pop(context);
              },
            ),
            buttonCreatePDF(context),
          ],
        ));
  }

  void initData() {
    String text = controllerHarga.text;

    try {
      hargaInput = double.parse(text);
    } catch (e) {
      hargaInput = 0.0;
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
    print('add data success');
    print('nama: ${controllerNama.text}');
    print('deskripsi: ${controllerDeskripsi.text}');
    print('kategori: $_selectedValue');
    print('gambar: $gambarPath');
    print('rating: $_rating');
    print('harga: $hargaInput');
  }

  Future<void> editObjekWisata(int id) async {
    await SQLHelper.editObjekWisata(
        id,
        controllerNama.text,
        controllerDeskripsi.text,
        _selectedValue,
        gambarPath,
        _rating,
        double.parse(controllerHarga.text));
  }

  Container buttonCreatePDF(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2),
      child: ElevatedButton(
        onPressed: () {
          if (_selectedValue.isEmpty ||
              controllerNama.text.isEmpty ||
              controllerDeskripsi.text.isEmpty ||
              controllerHarga.text.isEmpty) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Warning'),
                content: Text('Please fill all the fields.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
            return;
          } else {
            createPdf(controllerNama, controllerDeskripsi, controllerHarga,
                _selectedValue, gambarPath, _rating, context, id);
            setState(() {
              const uuid = Uuid();
              id = uuid.v1();
            });
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.amber,
          textStyle: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        child: Text('Create PDF'),
      ),
    );
  }
}
