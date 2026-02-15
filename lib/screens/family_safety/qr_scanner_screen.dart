import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );

  bool _isScanning = true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: () => _controller.toggleTorch(),
          ),
          IconButton(
            icon: const Icon(Icons.flip_camera_ios),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: (capture) {
              if (!_isScanning) return;

              final List<Barcode> barcodes = capture.barcodes;
              for (final barcode in barcodes) {
                if (barcode.rawValue != null) {
                  _handleScannedCode(barcode.rawValue!);
                  break;
                }
              }
            },
          ),
          _buildOverlay(),
          _buildInstructions(),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
      child: Column(
        children: [
          Expanded(flex: 1, child: Container(color: Colors.transparent)),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 3),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                Expanded(flex: 1, child: Container(color: Colors.transparent)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Container(color: Colors.transparent)),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10),
          ],
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.green, size: 32),
            SizedBox(height: 8),
            Text(
              'Position the QR code within the frame',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4),
            Text(
              'The code will be scanned automatically',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleScannedCode(String code) {
    if (!_isScanning) return;

    setState(() => _isScanning = false);

    // Validate the code format (should be 6 characters alphanumeric)
    if (code.length == 6 && RegExp(r'^[A-Z0-9]+$').hasMatch(code)) {
      // Valid join code
      Navigator.pop(context, code);
    } else {
      // Invalid code format
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid QR Code'),
          content: const Text(
            'This QR code does not contain a valid family group join code. '
            'Please scan a QR code shared by a group admin.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() => _isScanning = true);
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      );
    }
  }
}
