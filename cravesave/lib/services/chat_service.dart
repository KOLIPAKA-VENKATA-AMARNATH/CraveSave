import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createChatRoom(String donationId, List<String> participants) async {
    DocumentReference ref = await _firestore.collection('chat_rooms').add({
      'donationId': donationId,
      'participants': participants,
      'createdAt': FieldValue.serverTimestamp(),
      'lastMessage': null,
      'lastMessageTime': null,
    });
    return ref.id;
  }

  Future<void> sendMessage(String roomId, String senderId, String content, String type) async {
    await _firestore.collection('chat_rooms').doc(roomId).collection('messages').add({
      'senderId': senderId,
      'content': content,
      'type': type,
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _firestore.collection('chat_rooms').doc(roomId).update({
      'lastMessage': content,
      'lastMessageTime': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getChatMessages(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt')
        .snapshots();
  }
}