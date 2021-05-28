import 'package:flutter/material.dart';
import 'package:otp_storage/Database.dart';

import 'QRScanner.dart';
import 'SecretDataModel.dart';

void main() async {
  List<Secret> _listOfSecrets = await DB().getSecrets();
  runApp(MyApp(_listOfSecrets));
}

class MyApp extends StatelessWidget {
  
  final List<Secret> _listOfSecrets;
  
  MyApp(this._listOfSecrets);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: OTPsListPage(_listOfSecrets),
    );
  }
}

class OTPsListPage extends StatelessWidget {

  final List<Secret> _listOfSecrets;

  const OTPsListPage(this._listOfSecrets, {Key key}) : super(key: key);

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
