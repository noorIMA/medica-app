import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/model/message.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Future<void> sendMessage(
      String recieverId, String message, BuildContext context) async {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final String userId = ap.userModel.uid;
    final String userName =
        "${ap.userModel.firstName} ${ap.userModel.lastName}";
    final Timestamp timestamp = Timestamp.now();
    Message newMessage = Message(
        senderId: userId,
        senderName: userName,
        recieverId: recieverId,
        message: message,
        timestamp: timestamp);
    List<String> ids = [userId, recieverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .add(newMessage.toMap());
    await _fireStore.collection("chat_rooms").doc(chatRoomId).set({
      'users': ids,
      'lastMessage': message,
      'timestamp': timestamp
    }, SetOptions(merge: true));
  }

  Stream<QuerySnapshot> getMessages(String userid, String otheruserid) {
    List<String> ids = [userid, otheruserid];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _fireStore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
   Stream<QuerySnapshot> getChatRooms(String userId) {
    return _fireStore
        .collection("chat_rooms")
        .where('users', arrayContains: userId)
        .snapshots();
  }
}
