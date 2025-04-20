import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send a new message
  Future<void> sendMessage({
    required String chatRoomId,
    required String senderId,
    required String content,
    required String type,
  }) async {
    final message = MessageModel(
      id: '', // Will be set by Firestore
      chatRoomId: chatRoomId,
      senderId: senderId,
      content: content,
      type: type,
      createdAt: DateTime.now(),
    );

    await _firestore.collection('messages').add(message.toMap());
  }

  // Get chat messages for a chat room
  Stream<QuerySnapshot> getChatMessages(String chatRoomId) {
    return _firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .orderBy('createdAt', descending: false)
        .snapshots();
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    final messages = await _firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in messages.docs) {
      await doc.reference.update({'isRead': true});
    }
  }

  // Get unread message count for a chat room
  Stream<int> getUnreadMessageCount(String chatRoomId, String userId) {
    return _firestore
        .collection('messages')
        .where('chatRoomId', isEqualTo: chatRoomId)
        .where('senderId', isNotEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}