import 'package:flutter/material.dart';
import 'package:ugd1/core/app_export.dart';
import 'package:image_picker/image_picker.dart';

class CustomeNews extends StatefulWidget {
  const CustomeNews({Key? key}) : super(key: key);

  @override
  _CustomeNewsState createState() =>
      _CustomeNewsState();
}

class _CustomeNewsState
    extends State<CustomeNews> {
  String? imagePath; // Variabel untuk menyimpan path gambar

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 101,
      child: imagePath != null // Check apakah imagePath sudah diisi
          ? CustomImageView(
              imagePath: imagePath!, // Gunakan imagePath jika sudah diisi
              height: 91,
              width: 101,
              radius: BorderRadius.circular(15),
            )
          : GestureDetector(
              onTap: () async {
                final picker = ImagePicker();
                final pickedImage = await picker.pickImage(
                    source: ImageSource
                        .gallery); // Ganti dengan ImageSource.camera jika ingin menggunakan kamera

                if (pickedImage != null) {
                  // Jika gambar berhasil dipilih, update imagePath dan refresh tampilan
                  setState(() {
                    imagePath = pickedImage
                        .path; // Set imagePath dengan path gambar yang diunggah
                  });
                }
              },
              child: Container(
                // Widget placeholder ketika imagePath masih null
                height: 91,
                width: 101,
                decoration: BoxDecoration(
                  color: Colors.grey, // Warna placeholder bisa disesuaikan
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  Icons
                      .camera_alt, // Icon misalnya untuk menandakan upload gambar
                  color: Colors.white,
                ),
              ),
            ),
    );
  }
}
