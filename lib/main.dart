import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp/otp.dart';
import 'package:otp_storage/Database.dart';
import 'package:uuid/uuid.dart';

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

class OTPsListPage extends StatefulWidget {
  final List<Secret> _listOfSecrets;

  const OTPsListPage(this._listOfSecrets, {Key key}) : super(key: key);

  @override
  _OTPsListPageState createState() => _OTPsListPageState(_listOfSecrets);
}

class _OTPsListPageState extends State<OTPsListPage> {
  final List<Secret> _listOfSecrets;

  _OTPsListPageState(this._listOfSecrets);

  ListTile buildTile(BuildContext context, int index) => ListTile(
        leading: Text(_listOfSecrets[index].id.toString()),
        title: Text(OTP.generateTOTPCodeString(_listOfSecrets[index].secret,
            DateTime.now().millisecondsSinceEpoch)),
        subtitle: Text(_listOfSecrets[index].name),
      ); // TODO: create ListTile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Storage"),
      ),
      body: ListView.separated(
        itemCount: _listOfSecrets.length,
        itemBuilder: buildTile,
        separatorBuilder: (BuildContext context, int index) => Divider(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
          String id;
          if (result is String) {
            final code = result;
            var list = code.split("&issuer=");
            var secretIndex = list[0].indexOf("?secret=");
            var secret = list[0].substring(secretIndex + 8);
            var name = list[1];

            id = Uuid().v4();
            DB().insertSecret(Secret(id, secret, name));
          }

          Secret secret = await DB().getSecretById(id);

          setState(() {
            _listOfSecrets.add(secret);
          });
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}
