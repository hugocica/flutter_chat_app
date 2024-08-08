import 'package:chat_app/app/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found'),
            );
          }

          final chatMessages = snapshot.data!.docs;

          return ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(
                bottom: 40,
                left: 12,
                right: 12,
              ),
              itemCount: chatMessages.length,
              itemBuilder: (ctx, index) {
                final currentChatMessage = chatMessages[index].data();
                final nextChatMessage = index + 1 < chatMessages.length
                    ? chatMessages[index + 1].data()
                    : null;

                final currentChatMessageUserId = currentChatMessage['userId'];
                final nextChatMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;
                final nextUserIsSame =
                    nextChatMessageUserId == currentChatMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                    message: currentChatMessage['text'],
                    isMe: authenticatedUser.uid == currentChatMessageUserId,
                  );
                }

                return MessageBubble.first(
                  userImage: currentChatMessage['userImage'],
                  username: currentChatMessage['username'],
                  message: currentChatMessage['text'],
                  isMe: authenticatedUser.uid == currentChatMessageUserId,
                );
              });
        });
  }
}
