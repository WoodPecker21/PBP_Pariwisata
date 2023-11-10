import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:ugd1/View/preview_screen.dart';

Future<void> createPdf(
  TextEditingController controllerNama,
  TextEditingController controllerDeskripsi,
  TextEditingController controllerHarga,
  String kategori,
  gambarPath,
  double rating,
  BuildContext context,
  String id,
) async {
  final doc = pw.Document();
  final now = DateTime.now();
  final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
  final image = (await rootBundle.load(gambarPath)).buffer.asUint8List();
  final imagetampil = pw.MemoryImage(image);

  //ambil gambar dari asset utk ditampilkan pada pdf (head pdf dan logo invoice)
  // final imageLogo =
  //     (await rootBundle.load('assets/logo.png')).buffer.asUint8List();
  // final imageInvoice = pw.MemoryImage(imageLogo);

  //ambil gambar dari galeri atau kamera
  // pw.ImageProvider pdfImageProvider(Uint8List imageBytes) {
  //   return pw.MemoryImage(imageBytes);
  //}

  //final imageBytes = image.readAsBytesSync();

  //beri border di pdf
  final pdfTheme = pw.PageTheme(
    pageFormat: PdfPageFormat.a4,
    buildBackground: (pw.Context context) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
            color: PdfColor.fromHex('#FFBD59'),
            width: 1,
          ),
        ),
      );
    },
  );

  //utk atur tampilan halaman pdf
  doc.addPage(
    pw.Page(
      pageTheme: pdfTheme,
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                margin: pw.EdgeInsets.symmetric(horizontal: 2, vertical: 2),
              ),
              headerPDF(),
              pw.SizedBox(height: 30),
              imageTampil(imagetampil),
              pw.SizedBox(height: 30),
              personalDataFromInput(controllerNama, controllerDeskripsi,
                  controllerHarga, kategori, rating),
              pw.SizedBox(height: 40),
              bawah(),
              pw.SizedBox(height: 10),
              barcodeGaris(id),
              pw.SizedBox(height: 10),
              footerPDF(formattedDate),
            ],
          ),
        );
      },
    ),
  );

  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(doc: doc),
      ));
}

pw.Widget headerPDF() {
  return pw.Container(
    margin: pw.EdgeInsets.zero,
    decoration: pw.BoxDecoration(
      shape: pw.BoxShape.rectangle,
      gradient: pw.LinearGradient(
        colors: [
          PdfColor.fromHex('#FCDF8A'),
          PdfColor.fromHex('#F38381'),
        ],
        begin: pw.Alignment.topLeft,
        end: pw.Alignment.bottomRight,
      ),
    ),
    child: pw.Center(
      child: pw.Text(
        '- Input Objek Wisata -',
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 25,
        ),
      ),
    ),
  );
}

pw.Padding imageTampil(
  pw.MemoryImage img,
) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 2, vertical: 1),
    child: pw.FittedBox(
      child: pw.Image(img, height: 220),
      fit: pw.BoxFit.fitHeight,
      alignment: pw.Alignment.center,
    ),
  );
}

pw.Padding personalDataFromInput(
  TextEditingController nameController,
  TextEditingController deskripiController,
  TextEditingController hargaController,
  String kategori,
  double rating,
) {
  return pw.Padding(
    padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: pw.Table(
      border: pw.TableBorder.all(),
      children: [
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                'Nama',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                nameController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                'Deskripsi',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                deskripiController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                'Harga',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                hargaController.text,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                'Kategori',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                kategori,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
        pw.TableRow(
          children: [
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                'Rating',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
            pw.Padding(
              padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: pw.Text(
                rating.toString(),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 10,
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

pw.Padding bawah() {
  return pw.Padding(
    padding: pw.EdgeInsets.all(8.0),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Container(
            height: 100,
            decoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(2.0)),
              color: PdfColors.amberAccent,
            ),
            padding: const pw.EdgeInsets.only(
                left: 40, top: 10, bottom: 10, right: 40),
            alignment: pw.Alignment.centerLeft,
            child: pw.DefaultTextStyle(
              style:
                  const pw.TextStyle(color: PdfColors.amber100, fontSize: 12),
              child: pw.GridView(
                crossAxisCount: 2,
                children: [
                  pw.Text('TRIPPER',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.Text('Anggrek Street 12',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.SizedBox(height: 1),
                  pw.Text('Jakarta 5111',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.SizedBox(height: 1),
                  pw.SizedBox(height: 1),
                  pw.Text('Contact Us',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.SizedBox(height: 1),
                  pw.Text('Phone Number',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.Text('0812345678',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.Text('Email',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                  pw.Text('tripper@gmail.com',
                      style:
                          pw.TextStyle(fontSize: 10, color: PdfColors.black)),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

pw.Center footerPDF(String formattedDate) => pw.Center(
      child: pw.Text(
        'Created at $formattedDate',
        style: pw.TextStyle(
          color: PdfColors.black,
          fontSize: 10,
        ),
      ),
    );

pw.Container barcodeGaris(String id) {
  return pw.Container(
    child: pw.Padding(
      padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: pw.BarcodeWidget(
        barcode: Barcode.code128(escapes: true),
        data: id,
        width: 80,
        height: 40,
      ),
    ),
  );
}
