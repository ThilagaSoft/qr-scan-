import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/bloc/chat/chant_qr_screen_cubit.dart';
import 'package:map_pro/controller/chat_controller.dart';
import 'package:map_pro/repository/firebe_repository.dart';
import 'package:map_pro/utility/common_extension.dart';
import 'package:map_pro/utility/config/static_text.dart';
import 'package:map_pro/utility/theme/app_color.dart';
import 'package:map_pro/view/chat/qr_code_generator.dart';
import 'package:map_pro/view/chat/qr_scan_page.dart';
import 'package:map_pro/view/widgets/common_appBar.dart';

class ChatPage extends StatelessWidget {
  final ChatController chatController;

  const ChatPage({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    FirebaseRepository.configureFCMListeners(context);

    return Scaffold(
      appBar: CommonAppBar(title: StaticText.chat, backButton: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Column(
              children: [
                ListTile(
                  tileColor: AppColors.primary.withOpacity(0.1),
                  onTap: () {
                    context.read<QrViewCubit>().showGenerate();
                  },
                  leading: const Icon(Icons.share),
                  title: const Text("Share Your QR Code", style: TextStyle(fontSize: 18)),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.boxShade),
                ),
                const SizedBox(height: 10),
                ListTile(
                  tileColor: AppColors.primary.withOpacity(0.1),
                  onTap: ()
                  {
                    context.read<QrViewCubit>().showScan();
                  },
                  leading: const Icon(Icons.qr_code_scanner),
                  title: const Text("Scan other's QR Code", style: TextStyle(fontSize: 18)),
                  trailing: Icon(Icons.arrow_forward_ios, color: AppColors.boxShade),
                ),
              ],
            ),
            const SizedBox(height: 20),
            BlocBuilder<QrViewCubit, QrViewMode>(
              builder: (context, mode) {
                  switch (mode) {
                   case QrViewMode.scan:
                    return QRScanScreen(chatController: chatController);
                   case QrViewMode.generate:
                    return QRCodeGenScreen(chatController: chatController);
                    case QrViewMode.tokenGot:
                    return Text(chatController.scannedCode.value.toString());
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
