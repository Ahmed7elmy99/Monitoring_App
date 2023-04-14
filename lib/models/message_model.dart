class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String dateTime;

  MessageModel(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.dateTime});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
        senderId: json['senderId'],
        receiverId: json['receiverId'],
        message: json['message'],
        dateTime: json['dateTime']);
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'dateTime': dateTime
    };
  }
}
