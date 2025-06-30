import 'package:epicor/core_packages.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScreenQrScan extends StatefulWidget {
  const ScreenQrScan({super.key});

  @override
  State<ScreenQrScan> createState() => _ScreenQrScanState();
}

class _ScreenQrScanState extends State<ScreenQrScan> {
  bool isScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        onDetect: (capture) {
          if (!isScanned) {
            final barcode = capture.barcodes.first;
            if (barcode.rawValue != null) {
              isScanned = true;
              Navigator.pop(context, barcode.rawValue);
            }
          }
        },
      ),
    );
  }
}
