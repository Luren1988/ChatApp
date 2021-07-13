// チャット画面用Widget
import 'package:chatapp/chat.dart';
import 'package:chatapp/login.dart';
import 'package:chatapp/profile.dart';
import 'package:chatapp/qr_show.dart';
import 'package:chatapp/talkroom.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  SearchPage(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              // ログイン画面に遷移＋チャット画面を破棄
              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Row(
                  children: [
                    Text('メニュー', style: TextStyle(fontSize: 20)),
                  ],
                )),
            ListTile(
              title: Text('Room'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return TalkRoomPage(user);
                }));
              },
            ),
            ListTile(
              title: Text('Search'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return SearchPage(user);
                }));
              },
            ),
            ListTile(
              title: Text('Info'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacement(MaterialPageRoute(builder: (context) {
                  return ProfilePage(user);
                }));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Search'),
                  ),
                ],
              )),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('user').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;

                    return ListView(
                      children: documents.map((document) {
                        return Card(
                          child: ListTile(
                              title: Text(document['name']),
                              subtitle: Text(document['userId']),
                              trailing: Icon(Icons.add),
                              onTap: () async {
                                final date =
                                    DateTime.now().toLocal().toIso8601String();
                                final id = FirebaseFirestore.instance
                                    .collection('rooms')
                                    .doc()
                                    .id;

                                await FirebaseFirestore.instance
                                    .collection('rooms')
                                    .doc(id)
                                    .set({
                                  'date': date,
                                  'roomId': id,
                                  'text': document['name'] + "ROOM",
                                  'inPerson': [document['userId'], user.uid]
                                });

                                await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return Chat(user, id);
                                  }),
                                );
                              }),
                        );
                      }).toList(),
                    );
                  }
                  return Center(
                    child: Text('読み込み中...'),
                  );
                }),
          ),
        ],
      ),
      persistentFooterButtons: [
        IconButton(
            icon: Icon(Icons.qr_code),
            onPressed: () {
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) {
                return QrCodePage(user);
              }));
            }),
        IconButton(icon: Icon(Icons.camera_alt), onPressed: () {}),
      ],
    );
  }
}
