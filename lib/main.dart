import 'package:flutter/material.dart';
import 'package:otp_storage/Database.dart';

import 'QRScanner.dart';

void main() {
  DB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OTPsListPage(),
    );
  }
}

class OTPsListPage extends StatelessWidget {
  const OTPsListPage({Key key}) : super(key: key);

  ListTile buildTile() => ListTile(); // TODO: create ListTile

  List<ListTile> buildTiles() => []; // TODO: generate list of ListTiles

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Storage"),
      ),
      body: ListView(
        children: buildTiles(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
