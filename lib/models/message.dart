class Message {
  final String sender;
  final String content;
  final dynamic timestamp;
  final String userId;
  Message({
    required this.sender,
    required this.content,
    required this.timestamp,
    required this.userId
  });

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      sender: map['sender'],
      content: map['content'],
      timestamp: map['timestamp'],
      userId: map['userId']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
      'userId':userId
    };
  }
}