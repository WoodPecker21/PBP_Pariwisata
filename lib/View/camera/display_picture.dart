import 'dart:typed_data';
import 'package:ugd1/database/sql_helper_user.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../camera/logging_utils.dart';
import '../profil.dart';
import 'package:ugd1/config/theme.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;
  final CameraController cameraController;
  final int id;

  const DisplayPictureScreen(
      {Key? key,
      required this.imagePath,
      required this.cameraController,
      required this.id})
      : super(key: key);

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  File? fileResult;

  @override
  void initState() {
    fileResult = File(widget.imagePath);
    super.initState();
  }

  Future<void> _saveImageToDatabase(File? imageFile, int id) async {
    if (imageFile != null) {
      Uint8List imageBytes = await imageFile.readAsBytes();
      SQLHelper.insertImage(id, imageBytes);
      print('Image saved to database to id $id');
    }
  }

  void _showSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Set Profil Picture Success'),
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Profile Picture')),
        body: WillPopScope(
          onWillPop: () async {
            widget.cameraController.resumePreview();
            return true;
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(fileResult!),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  _saveImageToDatabase(fileResult, widget.id);
                  if (fileResult != null) {
                    _showSnackBar(context);
                    Navigator.of(context).pop(
                        // MaterialPageRoute(builder: (context) => Profile()),
                        );
                  }
                },
                child: Text('Save Image', style: TextStyle(fontSize: 20)),
              ),
            ],
          ),
        ));
  }
}
