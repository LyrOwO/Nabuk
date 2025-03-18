import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class BarcodeScannerPage extends StatefulWidget {
  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  String _scanResult = "No result";

  Future<void> startBarcodeScan() async {
    try {
      final scanResult = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", // Scanner overlay color
        "Cancel",  // Cancel button text
        true,      // Show flash icon
        ScanMode.BARCODE,
      );

      if (scanResult != "-1") {
        setState(() {
          _scanResult = scanResult;
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = "Failed to scan: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Scanner"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Scan Result:",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              _scanResult,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startBarcodeScan,
              child: Text("Start Scanning"),
            ),
          ],
        ),
      ),
    );
  }
}
