import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ugd1/constant/app_constant.dart';
import 'package:ugd1/scanQr/scan_qr_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ugd1/scanQr/scanner_error_widget.dart';
// import '../database/sql_helper_qr.dart';
// import '../model/qr.dart';

class BarcodeScannerPageView extends StatefulWidget {
  const BarcodeScannerPageView({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPageView> createState() => _BarcodeScannerPageViewState();
}

class _BarcodeScannerPageViewState extends State<BarcodeScannerPageView>
    with SingleTickerProviderStateMixin {
  BarcodeCapture? barcodeCapture;

  void getURLResult() {
    final qrCode = barcodeCapture?.barcodes.first.rawValue;
    if (qrCode != null) {
      if (qrCode.startsWith('https://')) {
        // setState(() {
        //   msg = qrCode;
        // });
        getURLResult();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Qr Hanya Bisa https://'),
          ),
        );
      }
    }
  }

  // String msg = "";
  // int idQR = 0;

  // void validateQRCode(String? dataqr) {
  //   if (dataqr != null) {
  //     int? qrId = SQLHelper.getQRId(dataqr) as int?;

  //     if (qrId != null) {
  //       print('-------- QR ID DARI DATABASE --------- $qrId');
  //       String? hasUsed = SQLHelper.getQRHasUsed(qrId) as String?;
  //       if (hasUsed == null) {
  //         hasUsed = 'false';
  //       }
  //       setState(() {
  //         idQR = qrId;
  //       });

  //       if (hasUsed == 'false') {
  //         // QR code exists and has not been used
  //         // Perform actions for valid QR code
  //         print('Valid QR code!');
  //         SQLHelper.setHasUsedQR(idQR);
  //         //return true;
  //       } else {
  //         // QR code has already been used
  //         print('Fail.. QR code has already been used.');
  //         setState(() {
  //           msg = 'QR code has already been used.';
  //         });
  //         //return false;
  //       }
  //     } else {
  //       // QR code does not exist in the database
  //       print('Invalid QR code.');
  //       setState(() {
  //         msg = 'Invalid QR code.';
  //       });
  //       //return false;
  //     }
  //   } else {
  //     setState(() {
  //       msg = LabelTextConstant.scanQrPlaceHolderLabel;
  //     });
  //     //return false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView(
        children: [
          cameraView(),
          Container(),
        ],
      ),
    );
  }

  Widget cameraView() {
    return Builder(
      builder: (context) {
        return Stack(
          children: [
            MobileScanner(
              startDelay: true,
              controller: MobileScannerController(torchEnabled: false),
              fit: BoxFit.contain,
              errorBuilder: (context, error, child) {
                return ScannerErrorWidget(error: error);
              },
              onDetect: (capture) => setBarcodeCapture(capture),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 100,
                color: Colors.black.withOpacity(0.4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 120,
                        height: 50,
                        child: FittedBox(
                          child: GestureDetector(
                            onTap: () => getURLResult(),
                            child: barcodeCaptureTextResult(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Text barcodeCaptureTextResult(BuildContext context) {
    return Text(
      barcodeCapture?.barcodes.first.rawValue ??
          LabelTextConstant.scanQrPlaceHolderLabel,
      overflow: TextOverflow.fade,
      style: Theme.of(context)
          .textTheme
          .headlineMedium!
          .copyWith(color: Colors.white),
    );
  }

  void setBarcodeCapture(BarcodeCapture capture) {
    setState(() {
      barcodeCapture = capture;
    });
  }
}
