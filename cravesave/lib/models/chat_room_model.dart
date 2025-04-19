import 'package:cloud_firestore/cloud_firestore.dart';
import 'base_model.dart';

class ChatRoomModel extends BaseModel {
  final List<String> participants;
  final String lastMessage;
  final DateTime lastUpdated;

  ChatRoomModel({
    required String id,
    required DateTime createdAt,
    required this.participants,
    required this.lastMessage,
    required this.lastUpdated,
  }) : super(id: id, createdAt: createdAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory ChatRoomModel.fromMap(Map<String, dynamic> map, String id) {
    return ChatRoomModel(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      lastMessage: map['lastMessage'] ?? '',
      lastUpdated: (map['lastUpdated'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}