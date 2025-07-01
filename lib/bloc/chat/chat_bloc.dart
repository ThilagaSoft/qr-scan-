import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:map_pro/repository/firebe_repository.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseRepository firebaseRepository;

  String? userId;
  String? peerId;
  final List<String> messages = [];
  final _firestore = FirebaseFirestore.instance;

  ChatBloc({required this.firebaseRepository}) : super(ChatInitial()) {
    on<InitChat>(onInit);
    on<SendMessage>(onSend);
    on<MessageReceived>(onReceive);
    on<GenerateQRCode>(onGenerateQRCode);
    on<QRCodeScanned>(onQRCodeScanned);
    on<FcmTokenRequest>(onFcmToken);
  }

  void onInit(InitChat event, Emitter<ChatState> emit) {
    userId = event.userId;
    peerId = event.peerId;

    _firestore
        .collection('chats')
        .doc(chatId())
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      for (var doc in snapshot.docChanges) {
        final data = doc.doc.data();
        if (data != null) {
          add(MessageReceived(data['from'], data['text']));
        }
      }
    });

    emit(ChatLoaded(List.from(messages)));
  }

  void onSend(SendMessage event, Emitter<ChatState> emit) async {
    try {
      final ref = await _firestore
          .collection('chats')
          .doc(chatId())
          .collection('messages')
          .add({
        'from': userId,
        'to': peerId,
        'text': event.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print("✅ Message written at: ${ref.path}");
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  void onReceive(MessageReceived event, Emitter<ChatState> emit) {
    messages.add("${event.from}: ${event.text}");
    emit(ChatLoaded(List.from(messages)));
  }

  String chatId() {
    final ids = [userId!, peerId!]..sort();
    return ids.join('_');
  }
  void onGenerateQRCode(GenerateQRCode event, Emitter<ChatState> emit) {
    emit(QRCodeGenerated(event.dataToEncode));
  }

  void onQRCodeScanned(QRCodeScanned event, Emitter<ChatState> emit) {
    final scannedPeerId = event.scannedData;
    if (userId != null && scannedPeerId.isNotEmpty) {
      add(InitChat(userId!, scannedPeerId));
      emit(QRCodeScanSuccess(scannedPeerId));
    } else {
      emit(ChatError("Invalid scanned data or user not logged in"));
    }
  }
void  onFcmToken(FcmTokenRequest event, Emitter<ChatState> emit)
async{
  emit(ChatLoading());
  try
  {
          final token = await firebaseRepository.getToken();
          emit(FcmTokenState(deviceToken: token));

  }
     catch(e)
    {

      emit(ChatError(e.toString()));
    }
  }
}
