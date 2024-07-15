import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/chat_Screen.dart';
import 'package:medica_app/provider/Chat_Service.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:medica_app/provider/local_provider.dart';
import 'package:provider/provider.dart';

class UserChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final locale = localeProvider.localeString;
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final chatService = Provider.of<ChatService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)?.translate('chatlist')}",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatService.getChatRooms(ap.userModel.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.data!.docs.isEmpty) {
            return Text('No messages');
          }

          return ListView(
            children: snapshot.data!.docs.map((document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              List<dynamic> users = data['users'];
              String doctorId =
                  users.firstWhere((id) => id != ap.userModel.uid);

              return FutureBuilder<QuerySnapshot>(
                future:
                    FirebaseFirestore.instance.collectionGroup('Doctors').get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text('Loading...'));
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                        title: Text('Error: ${userSnapshot.error}'));
                  }
                  if (!userSnapshot.hasData ||
                      userSnapshot.data!.docs.isEmpty) {
                    return ListTile(title: Text('Doctor not found'));
                  }

                  var doctorDoc;
                  try {
                    doctorDoc = userSnapshot.data!.docs
                        .firstWhere((doc) => doc.id == doctorId);
                  } catch (e) {
                    doctorDoc = null;
                  }

                  if (doctorDoc == null) {
                    return ListTile(title: Text('Doctor not found'));
                  }

                  Map<String, dynamic> doctorData =
                      doctorDoc.data() as Map<String, dynamic>;

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Text(
                        '${doctorData['Name_$locale']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 58, 139, 148),
                        ),
                      ),
                      subtitle: Text(
                        data['lastMessage'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              recieverId: doctorId,
                              recieverName: '${doctorData['Name_$locale']}',
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
