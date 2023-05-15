import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:ymcc_presence/api.dart';
import 'package:ymcc_presence/globals.dart' as globals;

class QRCodeScanner extends StatefulWidget {
  const QRCodeScanner({Key? key}) : super(key: key);

  @override
  State<QRCodeScanner> createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  @override
  Widget build(BuildContext context) {
    globals.cameraController = MobileScannerController();
    MobileScannerController cameraController = globals.cameraController;
    return Scaffold(
      // https://github.com/eclectifyTutorials/YT_Tutorial_Pkg_Mobile_Scanner
      appBar: AppBar(
        title: const Text("QRcode Scanner"),
        leading: IconButton(
          onPressed: () {
            cameraController.stop();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: MobileScanner(
        // allowDuplicates: true,
        controller: cameraController,
        onDetect: (barcode) {
          cameraController.stop();
          _foundBarcode(barcode);
        },
      ),
    );
  }

  void _foundBarcode(BarcodeCapture barcode) {
    /// open screen
    final String code = barcode.raw[0]['rawValue'];
    debugPrint('Barcode found! $code');
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FoundCodeScreen(value: code),
        ));
  }
}

class FoundCodeScreen extends StatefulWidget {
  final String value;

  const FoundCodeScreen({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  State<FoundCodeScreen> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  @override
  Widget build(BuildContext context) {
    var eventId = globals.selectedEventId;
    var enc = widget.value;
    // make request here
    return Scaffold(
      appBar: AppBar(
        title: const Text("QRcode information"),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            globals.cameraController.start();
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_outlined,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Scanned Code",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                future: API.attend(enc, eventId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data.toString());
                  } else {
                    return const Text('Loading...');
                  }
                },
              ),
              // Text(
              //   API.getEvent().then((data) => data).toString(),
              //   style: const TextStyle(
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
