import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/bloc/chat/chant_qr_screen_cubit.dart';
import 'package:map_pro/bloc/chat/chat_bloc.dart';
import 'package:map_pro/repository/firebe_repository.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

class ChatController
{
  final ChatBloc chatBloc;

  ChatController({required this.chatBloc});

  final myIdController = TextEditingController();
  final peerIdController = TextEditingController();
  final textController = TextEditingController();
  final scrollController = ScrollController();
  final ValueNotifier<bool> started = ValueNotifier(false);
  final GlobalKey<FormState> formKey = GlobalKey();
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
    QRViewController? controller;
  bool scannedOnce = false;
   String? fcmToken ;
  final FirebaseRepository firebaseRepository = FirebaseRepository();
  final ValueNotifier<String?> scannedCode = ValueNotifier(null);

  void getToken() async
  {
     fcmToken = await firebaseRepository.getToken();
     if (fcmToken == null)
     {
       print("FCM token unavailable. Check internet or permissions.");
     }
  }

  void shareQrCode()
  {

  }
  void scanQrCode()
  {

  }
  void onPermissionSet(BuildContext context, bool isGranted)
  {
    if (!isGranted)
    {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera permission not granted')),
      );
    }
  }
  void onQRViewCreated(BuildContext context, QRViewController controller)
  {
    controller.scannedDataStream.listen((scanData)
    {
      scannedCode.value = scanData.code;
      context.read<QrViewCubit>().showTokenData();
      controller.pauseCamera(); // optional: pause after scan
    });
  }
  //  onQRViewCreated(BuildContext context, QRViewController qrController) {
  //   controller = qrController;
  //
  //   controller!.scannedDataStream.listen((scanData) async {
  //     if (!scannedOnce && scanData.code != null) {
  //       scannedOnce = true;
  //       await controller!.pauseCamera();
  //       Navigator.pop(context, scanData.code); // Return result
  //     }
  //   });
  // }




}