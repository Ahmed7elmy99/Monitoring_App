class MessageModel {
  final String senderId;
  final String receiverId;
  final String message;
  final String dateTime;
  final String? time;

  MessageModel({
    required this.senderId,
    required this.receiverId,
    required this.message,
    required this.dateTime,
    this.time,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      message: json['message'],
      dateTime: json['dateTime'],
      time: json['time'] == null ? '3:00 AM' : json['time'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'dateTime': dateTime,
      'time': time == null ? '3:00 AM' : time,
    };
  }
}
