import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/bloc/chat/chat_bloc.dart';
import 'package:map_pro/bloc/chat/chat_event.dart';
import 'package:map_pro/bloc/chat/chat_state.dart';
import 'package:map_pro/controller/chat_controller.dart';
import 'package:map_pro/repository/firebe_repository.dart';
import 'package:map_pro/utility/theme/app_color.dart';
import 'package:qr_flutter_new/qr_flutter.dart';
import 'package:shimmer/shimmer.dart';

class QRCodeGenScreen extends StatelessWidget {
  final ChatController chatController;

  const QRCodeGenScreen({super.key, required this.chatController});

  @override
  Widget build(BuildContext context) {
    chatController.getToken();

    return BlocProvider<ChatBloc>(
      create: (_) =>
      ChatBloc(firebaseRepository: FirebaseRepository())
        ..add(FcmTokenRequest()),
      child: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state)
        {
        },
        builder: (context, state)
        {
          if(state is ChatLoading)
            {
              return SizedBox(
                height: 250,
                child: Center(
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      height: 250,
                      width: 250,
                      color: Colors.white,
                    ),
                  )
                ),
              );
            }
          else if(state is FcmTokenState)
            {
              return Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(top: 20),
                color: AppColors.primary.withOpacity(0.1),
                child: QrImageView(
                  data: state.deviceToken!,
                  size: 250,
                ),
              );
            }
          else
            {
              return Container();
            }

        },
      ),
    );
  }
}
