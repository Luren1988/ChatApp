// 投稿画面用Widget
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chat extends StatefulWidget {
  Chat(this.user, this.roomId);

  final User user;
  final String roomId;

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String messageText = '';

  @override
  Widget build(BuildContext context) {
    print(widget.roomId);
    var formmeter = DateFormat('HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: Text("チャット投稿"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chats')
                        .where('roomId', isEqualTo: widget.roomId)
                        .orderBy('dates')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> documents =
                            snapshot.data!.docs;
                        return ListView(
                          children: documents.map((document) {
                            return Card(
                              child: ListTile(
                                  title: Row(
                                mainAxisAlignment:
                                    (widget.user.uid == document["user"])
                                        ? MainAxisAlignment.end
                                        : MainAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Text(document["text"]),
                                      Text(
                                        formmeter.format(
                                            DateTime.parse(document['dates'])),
                                        style: TextStyle(
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                            );
                          }).toList(),
                        );
                      }
                      return Center(
                        child: Text('読み込み中'),
                      );
                    }),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: '投稿メッセージ'),
                keyboardType: TextInputType.multiline,
                maxLines: 3,
                onChanged: (String value) {
                  setState(() {
                    messageText = value;
                  });
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Text('投稿'),
                  onPressed: () async {
                    final date = DateTime.now().toLocal().toIso8601String();
                    //final email = widget.user.email;
                    await FirebaseFirestore.instance
                        .collection('chats')
                        .doc()
                        .set({
                      'roomId': widget.roomId,
                      'text': messageText,
                      'user': widget.user.uid,
                      'dates': date
                    });

                    setState(() {
                      messageText = "";
                    });

                    ///Navigator.of(context).pop();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
