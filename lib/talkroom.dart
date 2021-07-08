// チャット画面用Widget
import 'package:chatapp/chat.dart';
import 'package:chatapp/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TalkRoomPage extends StatelessWidget {
  TalkRoomPage(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('チャット'),
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
              title: Text('Search'),
              onTap: () {},
            ),
            ListTile(
              title: Text('Info'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            child: Text('ログイン情報:${user.email}'),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rooms')
                    .orderBy('date')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents =
                        snapshot.data!.docs;

                    return ListView(
                      children: documents.map((document) {
                        return Card(
                          child: ListTile(
                              title: Text(document['text']),
                              subtitle: Text(document['email']),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) {
                                    return Chat(user, document.id);
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
    );
  }
}
