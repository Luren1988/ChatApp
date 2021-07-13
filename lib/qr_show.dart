import 'package:chatapp/profile.dart';
import 'package:chatapp/search_friend.dart';
import 'package:chatapp/talkroom.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodePage extends StatelessWidget {
  //const QrCodeLayout({Key key}) : super(key: key);
  QrCodePage(this.user);
  final User user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Demo'),
      ),
      body: Center(
        child: QrImage(
          data: user.uid,
          size: 200,
        ),
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
    );
  }
}
