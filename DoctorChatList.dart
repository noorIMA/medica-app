import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medica_app/Screens/DoctorChat_Screen.dart';
import 'package:medica_app/provider/DoctorChat_Service.dart';
import 'package:medica_app/provider/app_localizations.dart';
import 'package:medica_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class DoctorChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AuthProvider>(context, listen: false);
    final chatService = Provider.of<DChatService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${AppLocalizations.of(context)?.translate('chatlist')}",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
          leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            CupertinoIcons.back,
            color: Colors.white,
            size: 40,
          ),
        ),
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 58, 139, 148),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatService.getChatRooms(ap.doctorModel.did),
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
              String otherUserId =
                  users.firstWhere((id) => id != ap.doctorModel.did);
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(otherUserId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: Text('Loading...'));
                  }
                  if (userSnapshot.hasError) {
                    return ListTile(
                        title: Text('Error: ${userSnapshot.error}'));
                  }
                  if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                    return ListTile(title: Text('User not found'));
                  }
                  Map<String, dynamic> userData =
                      userSnapshot.data!.data() as Map<String, dynamic>;

                  // Fetch the user data from Firestore or handle as needed
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
                          '${userData['firstName']} ${userData['lastName']}',
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
                              builder: (context) => DChatScreen(
                                recieverId: otherUserId,
                                recieverName:
                                    '${userData['firstName']} ${userData['lastName']}',
                              ),
                            ),
                          );
                        }),
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
