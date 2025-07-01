abstract class ChatState {}

/// Initial state before anything starts
class ChatInitial extends ChatState {}

/// Loading (e.g. starting listener)
class ChatLoading extends ChatState {}

/// Chat loaded and messages available
class ChatLoaded extends ChatState {
  final List<String> messages;
  ChatLoaded(this.messages);
}

/// Error state
class ChatError extends ChatState {
  final String error;
  ChatError(this.error);
}
class QRCodeGenerated extends ChatState {
  final String qrData;
  QRCodeGenerated(this.qrData);
}

// NEW: QR code scan result received
class QRCodeScanSuccess extends ChatState {
  final String scannedData;
  QRCodeScanSuccess(this.scannedData);
}

class FcmTokenState extends ChatState
{
  String? deviceToken;
  FcmTokenState({required this.deviceToken});
}