import 'package:flutter/material.dart';
import 'package:map_pro/controller/chat_controller.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class QRScanScreen extends StatelessWidget {
  final ChatController chatController;

  const QRScanScreen({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final qrSize = (size.width < 400 || size.height < 400) ? 250.0 : 300.0;

    return Center(
      child: SizedBox(
        width: qrSize,
        height: qrSize,
        child: QRView(
          key: chatController.qrKey,
          onQRViewCreated: (ctrl) => chatController.onQRViewCreated(context, ctrl),
          overlay: QrScannerOverlayShape(
            borderColor: Colors.red,
            borderRadius: 10,
            borderLength: 30,
            borderWidth: 10,
            cutOutSize: qrSize - 40, // ensure cutout fits inside the QRView
          ),
          onPermissionSet: (ctrl, p) => chatController.onPermissionSet(context, p),
        ),
      ),
    );
  }
}
