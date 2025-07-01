abstract class ChatEvent {}

/// Initialize chat session
class InitChat extends ChatEvent {
  final String userId;  // sender ID
  final String peerId;  // recipient ID
  InitChat(this.userId, this.peerId);
}

/// Send a message
class SendMessage extends ChatEvent {
  final String text;
  SendMessage(this.text);
}

/// Receive a message (internal use by BLoC when Firestore triggers a listener)
class MessageReceived extends ChatEvent {
  final String from;
  final String text;
  MessageReceived(this.from, this.text);
}
// NEW: Request to generate QR code data (e.g. userId or chatId)
class GenerateQRCode extends ChatEvent {
  final String dataToEncode; // e.g., userId or chatId
  GenerateQRCode(this.dataToEncode);
}

// NEW: Scanned QR code data received
class QRCodeScanned extends ChatEvent
{
  final String scannedData; // e.g., scanned peerId
  QRCodeScanned(this.scannedData);
}
class FcmTokenRequest extends ChatEvent
{
  FcmTokenRequest();
}