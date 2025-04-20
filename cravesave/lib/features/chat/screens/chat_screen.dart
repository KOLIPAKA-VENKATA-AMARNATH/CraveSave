import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../models/message_model.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/chat_service.dart';
import '../../../theme/auth_theme.dart';

class ChatScreen extends StatefulWidget {
  final String donationId;
  final String volunteerId;

  const ChatScreen({
    super.key,
    required this.donationId,
    required this.volunteerId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatService = ChatService();
  final _authService = AuthService();
  final _firestore = FirebaseFirestore.instance;
  final _messageController = TextEditingController();
  UserModel? _volunteer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVolunteer();
    _markMessagesAsRead();
  }

  Future<void> _loadVolunteer() async {
    try {
      final doc = await _firestore.collection('users').doc(widget.volunteerId).get();
      if (doc.exists) {
        setState(() {
          _volunteer = UserModel.fromMap(doc.data()!, doc.id);
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading volunteer: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _markMessagesAsRead() async {
    final userId = _authService.currentUser?.uid;
    if (userId != null) {
      await _chatService.markMessagesAsRead(widget.donationId, userId);
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final userId = _authService.currentUser?.uid;
    if (userId == null) return;

    try {
      await _chatService.sendMessage(
        chatRoomId: widget.donationId,
        senderId: userId,
        content: _messageController.text.trim(),
        type: 'text',
      );
      _messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AuthTheme.theme,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(_volunteer?.name ?? 'Volunteer'),
              if (_volunteer != null)
                Text(
                  _volunteer!.phone,
                  style: const TextStyle(fontSize: 12),
                ),
            ],
          ),
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _chatService.getChatMessages(widget.donationId),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final messages = snapshot.data?.docs ?? [];
                        if (messages.isEmpty) {
                          return const Center(
                            child: Text('No messages yet'),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = MessageModel.fromMap(
                              messages[index].data() as Map<String, dynamic>,
                              messages[index].id,
                            );
                            final isMe = message.senderId == _authService.currentUser?.uid;

                            return Align(
                              alignment: isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isMe
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  message.content,
                                  style: TextStyle(
                                    color: isMe ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                          ),
                        ),
                        IconButton(
                          onPressed: _sendMessage,
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
} 