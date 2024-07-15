import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/provider/DoctorChat_Service.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class DChatScreen extends StatefulWidget {
  final String recieverId;
  final String recieverName;
  const DChatScreen({required this.recieverId, required this.recieverName});

  @override
  State<DChatScreen> createState() => _DChatScreenState();
}

class _DChatScreenState extends State<DChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final DChatService _chatService = DChatService();
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.recieverId, _messageController.text, context);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.recieverName),
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    return StreamBuilder(
        stream: _chatService.getMessages(widget.recieverId, ap.doctorModel.did),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error${snapshot.error}");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }
          return ListView(
            children: snapshot.data!.docs
                .map((document) => _buildMessageItem(document))
                .toList(),
          );
        });
  }

  Widget _buildMessageItem(DocumentSnapshot document) {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    var alignment = (data['senderId'] == ap.doctorModel.did)
        ? Alignment.centerRight
        : Alignment.centerLeft;
    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(data['senderName']),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromARGB(255, 58, 139, 148),
            ),
            child: Text(data['message'],
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ]),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              cursorColor: Color.fromARGB(255, 58, 139, 148),
              controller: _messageController,
              obscureText: false,
              decoration: InputDecoration(
                  filled: true,
                  fillColor: Color.fromARGB(255, 233, 233, 233),
                  hintText: "${AppLocalizations.of(context)?.translate('entermsg')}",
                  hintStyle: TextStyle(color: Colors.black),
                  alignLabelWithHint: true,
                  border: InputBorder.none),
            ),
          ),
          IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.arrow_forward,
                size: 40,
              )),
        ],
      ),
    );
  }
}
