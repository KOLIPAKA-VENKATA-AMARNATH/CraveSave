import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class MessageModel extends BaseModel {
  final String chatRoomId;
  final String senderId;
  final String content;
  final String type;
  final bool isRead;

  MessageModel({
    required String id,
    required DateTime createdAt,
    required this.chatRoomId,
    required this.senderId,
    required this.content,
    required this.type,
    this.isRead = false,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'chatRoomId': chatRoomId,
      'senderId': senderId,
      'content': content,
      'type': type,
      'isRead': isRead,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map, String id) {
    return MessageModel(
      id: id,
      chatRoomId: map['chatRoomId'] ?? '',
      senderId: map['senderId'] ?? '',
      content: map['content'] ?? '',
      type: map['type'] ?? 'text',
      isRead: map['isRead'] ?? false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}