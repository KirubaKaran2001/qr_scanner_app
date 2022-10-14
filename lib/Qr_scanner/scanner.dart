import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});
  @override
  State<QrScanner> createState() => _QrScannerState();
}
class _QrScannerState extends State<QrScanner> {
  final qrKey = GlobalKey(debugLabel: 'Qr');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    controller!.resumeCamera();
    
  }
  
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            scanQr(),
            Positioned(
              bottom: 20,
              child: Row(
                children: [
                  Card(
                    color: Colors.transparent,
                    child: scannresult(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget scanQr() {
    return QRView(
      key: qrKey,
      overlay: QrScannerOverlayShape(
        borderColor: const Color(0xFFE1C884)),
      onQRViewCreated: qrCreated,
    );
  }
  qrCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (barcode) {
        setState(
          () {
            this.barcode = barcode;
          },
        );
      },
    );
  }
  Widget scannresult() => Text(
        barcode != null ? 'Result :${barcode!.code}' : 'Scan A Code ',
        style: const TextStyle(color: Colors.white, fontSize: 25),
      );
}
