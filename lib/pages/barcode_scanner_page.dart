import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String? scannedBarcode;

  Future<void> scanBarcode() async {
    try {
      final barcode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', // Couleur du scanner
        'Annuler', // Texte du bouton d'annulation
        true, // Activer le flash
        ScanMode.BARCODE, // Mode de scan
      );
      if (barcode != '-1') {
        setState(() {
          scannedBarcode = barcode;
        });
      }
    } catch (e) {
      setState(() {
        scannedBarcode = 'Erreur lors du scan : $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(211, 180, 156, 50),
        title: Text('Scanner un Livre'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (scannedBarcode != null)
              Text(
                'Code-barres scanné : $scannedBarcode',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text('Scanner un code-barres'),
            ),
          ],
        ),
      ),
    );
  }
}
