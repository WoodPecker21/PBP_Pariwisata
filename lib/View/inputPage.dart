import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ugd1/client/objekWisataClient.dart';
import 'package:ugd1/model/objekWisata.dart';
import 'package:ugd1/widgets/custom_text_form_field.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ugd1/View/pdf_view.dart';

class InputPage extends StatefulWidget {
  const InputPage({Key? key}) : super(key: key);

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  TextEditingController controllerHarga = TextEditingController();
  TextEditingController controllerAkomodasi = TextEditingController();
  TextEditingController controllerDurasi = TextEditingController();
  TextEditingController controllerPulau = TextEditingController();
  TextEditingController controllerTransportasi = TextEditingController();
  double _rating = 0.0;
  double hargaInput = 0;
  String _selectedValue = 'Alam';
  String gambarPath = 'image/alam.jpg';
  String id = Uuid().v1();
  bool isUpdate = false;
  int updatedId = 0;
  File? _imageFile;

  void initState() {
    super.initState();
    cekUpdate();
  }

  Future<void> cekUpdate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.containsKey('idUpdate')) {
        int idObjekUpdate = prefs.getInt('idUpdate') ?? 0;

        final objekWisata = await ObjekWisataClient.find(idObjekUpdate);

        setState(() {
          _selectedValue = objekWisata.kategori ?? '';
          _rating = objekWisata.rating ?? 0;
          controllerNama.text = objekWisata.nama ?? '';
          controllerDeskripsi.text = objekWisata.deskripsi ?? '';
          controllerHarga.text = objekWisata.harga.toString();
          controllerAkomodasi.text = objekWisata.akomodasi ?? '';
          controllerDurasi.text = objekWisata.durasi.toString();
          controllerPulau.text = objekWisata.pulau ?? '';
          controllerTransportasi.text = objekWisata.transportasi ?? '';
          updatedId = objekWisata.id ?? 0;
        });

        setState(() {
          isUpdate = true;
        });
      }
    } catch (e) {
      print('error di retrieve update data: $e');
    }
  }

  // Tambahkan method untuk menyimpan objek wisata
  Future<void> insertData() async {
    try {
      ObjekWisata objek = ObjekWisata(
        nama: controllerNama.text,
        deskripsi: controllerDeskripsi.text,
        harga: double.parse(controllerHarga.text),
        akomodasi: controllerAkomodasi.text,
        durasi: int.parse(controllerDurasi.text),
        pulau: controllerPulau.text,
        transportasi: controllerTransportasi.text,
        kategori: _selectedValue,
        rating: _rating,
        gambar: null,
      );

      await ObjekWisataClient.create(objek);
      print('Data berhasil disimpan');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      ObjekWisata objek = ObjekWisata(
        id: updatedId,
        nama: controllerNama.text,
        deskripsi: controllerDeskripsi.text,
        harga: double.parse(controllerHarga.text),
        akomodasi: controllerAkomodasi.text,
        durasi: int.parse(controllerDurasi.text),
        pulau: controllerPulau.text,
        transportasi: controllerTransportasi.text,
        kategori: _selectedValue,
        rating: _rating,
        gambar: null,
      );

      await ObjekWisataClient.update(objek);
      prefs.remove('idUpdate');
      print('Data berhasil diupdate');
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _pickImageFromGallery() async {
    final returnedImage = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (returnedImage == null) return;
    final imageFile = File(returnedImage.path);

    setState(() {
      _imageFile = imageFile;
    });
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
        title: Text(isUpdate ? "Update Objek Wisata" : "Insert Objek Wisata"),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: <Widget>[
          CustomTextFormField(
            controller: controllerNama,
            hintText: 'Nama',
            validator: (value) =>
                value == '' ? 'Nama tidak boleh kosong' : null,
          ),
          SizedBox(height: 12),
          Container(
            height: 200,
            child: CustomTextFormField(
              controller: controllerDeskripsi,
              hintText: 'Deskripsi',
              maxLines: 10,
              contentPadding: EdgeInsets.all(10),
              validator: (value) =>
                  value == '' ? 'Deskripsi tidak boleh kosong' : null,
            ),
          ),
          SizedBox(height: 12),
          CustomTextFormField(
            controller: controllerHarga,
            hintText: 'Harga',
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == '' ? 'Harga tidak boleh kosong' : null,
          ),
          SizedBox(height: 12),
          CustomTextFormField(
            controller: controllerAkomodasi,
            hintText: 'Akomodasi',
            validator: (value) =>
                value == '' ? 'Akomodasi tidak boleh kosong' : null,
          ),
          SizedBox(height: 12),
          CustomTextFormField(
            controller: controllerDurasi,
            hintText: 'Durasi',
            validator: (value) =>
                value == '' ? 'Durasi tidak boleh kosong' : null,
          ),
          SizedBox(height: 12),
          CustomTextFormField(
            controller: controllerPulau,
            hintText: 'Pulau',
            validator: (value) =>
                value == '' ? 'Pulau tidak boleh kosong' : null,
          ),
          SizedBox(height: 12),
          CustomTextFormField(
            controller: controllerTransportasi,
            hintText: 'Transportasi',
            validator: (value) =>
                value == '' ? 'Transportasi tidak boleh kosong' : null,
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
                    fontFamily: 'Poppins'),
              )),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    'Kategori  : ',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontFamily: 'Poppins'),
                  )),
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
                    child: Text(value,
                        style: TextStyle(fontFamily: 'Poppins', fontSize: 13)),
                  );
                }).toList(),
              ),
            ],
          ),
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
              Navigator.pop(context);
            },
            child: Text("Simpan Data"),
          ),
          buttonCreatePDF(context),
        ],
      ),
    );
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
