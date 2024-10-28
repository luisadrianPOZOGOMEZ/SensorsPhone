import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QRScreen extends StatefulWidget {
  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  MobileScannerController cameraController = MobileScannerController();
  String? scannedData;

  // Verifies if the scanned text is a valid URL
  bool _isValidURL(String? url) {
    return Uri.tryParse(url ?? '')?.hasAbsolutePath ?? false;
  }

  // Opens the link in the browser if it's valid
  Future<void> _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      _showSnackBar('Could not open link: $url');
    }
  }

  // Shows a message at the bottom of the screen
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: [
          IconButton(
            icon: Icon(Icons.flip_camera_android),
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: MobileScanner(
              controller: cameraController,
              onDetect: (BarcodeCapture capture) {
                // Check if there's a barcode and retrieve raw value
                if (capture.barcodes.isNotEmpty) {
                  final String? code = capture.barcodes.first.rawValue;
                  if (code != null && scannedData != code) {
                    setState(() {
                      scannedData = code;
                    });

                    cameraController.stop();

                    if (_isValidURL(code)) {
                      _openURL(code);
                    } else {
                      _showSnackBar('Scanned code: $code');
                    }
                  }
                }
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(
              child: scannedData != null
                  ? Text(
                      'Scanned code: $scannedData',
                      style: TextStyle(fontSize: 16),
                    )
                  : Text(
                      'Scan a QR code',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => scannedData = null);
              cameraController.start();
            },
            child: Text('Restart Scanning'),
          ),
        ],
      ),
    );
  }
}
