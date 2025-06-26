import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class ScanQrCodeScreen extends StatefulWidget {
  const ScanQrCodeScreen({super.key});

  @override
  State<ScanQrCodeScreen> createState() => _ScanQrCodeScreenState();
}

class _ScanQrCodeScreenState extends State<ScanQrCodeScreen> {
  final MobileScannerController controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    returnImage: false,
  );

  bool _hasScanned = false;

  void _handleScan(String code) async {
    if (_hasScanned) return;
    setState(() => _hasScanned = true);

    await controller.stop();

    if (code.startsWith('http')) {
      final Uri url = Uri.parse(code);
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membuka link')),
        );
      }

      // Tunggu lalu izinkan scan ulang
      await Future.delayed(Duration(seconds: 2));
      controller.start();
      setState(() => _hasScanned = false);
    } else {
      // Tampilkan dialog untuk isi QR selain link
      if (!context.mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Isi QR Code"),
          content: Text(code),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                controller.start();
                setState(() => _hasScanned = false);
              },
              child: Text("Scan Lagi"),
            ),
          ],
        ),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scanner')),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            onDetect: (BarcodeCapture capture) {
              final barcode = capture.barcodes.first;
              final String? code = barcode.rawValue;
              if (code != null) {
                _handleScan(code);
              }
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black54,
              padding: EdgeInsets.all(12),
              child: Text(
                'Arahkan kamera ke QR Code',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
