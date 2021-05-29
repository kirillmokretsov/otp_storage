import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_storage/Database.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import 'QRScanner.dart';
import 'SecretDataModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Strangely, async method shouldn't be called in constructor
  // even if you await database in other methods
  await DB().initDB();
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

  ListTile buildTile(int id, String secret, String name) => ListTile(
        leading: Text(id.toString()),
        title: Text(secret),
        subtitle: Text(name),
      ); // TODO: create ListTile

  // TODO: add dividers
  List<ListTile> buildTiles() => List.generate(
        _listOfSecrets.length,
        (index) => buildTile(_listOfSecrets[index].id,
            _listOfSecrets[index].secret, _listOfSecrets[index].name),
      );

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
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
          if (result is String) {
            final code = result;
            var list = code.split("&issuer=");
            var secretIndex = list[0].indexOf("?secret=");
            var secret = list[0].substring(secretIndex + 8);
            var name = list[1];
            DB().insertSecret(Secret(Random.secure().nextInt(1000), secret, name));
          }
          // TODO: update list
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
