import 'package:flutter/material.dart';

import '../database/Database.dart';
import '../datamodel/SecretDataModel.dart';
import '../utils/Utils.dart';
import '../widget/OTPListTile.dart';
import 'MyAboutPage.dart';
import 'QRScanner.dart';

class OTPsListPage extends StatefulWidget {
  final List<Secret> _listOfSecrets;
  final String _key;

  const OTPsListPage(this._listOfSecrets, this._key, {Key key}) : super(key: key);

  @override
  _OTPsListPageState createState() => _OTPsListPageState(_listOfSecrets, _key);
}

class _OTPsListPageState extends State<OTPsListPage> {
  final List<Secret> _listOfSecrets;
  final String _key;

  _OTPsListPageState(this._listOfSecrets, this._key);

  Widget buildTile(BuildContext context, int index) =>
      OTPListTile(_listOfSecrets[index]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Storage"),
        actions: [
          IconButton(
            onPressed: () => MyAboutPage.showAbout(context),
            icon: Icon(Icons.info_outline),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _listOfSecrets.length,
        itemBuilder: buildTile,
        separatorBuilder: (BuildContext context, int index) => Divider(),
        padding: EdgeInsets.all(16.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scan,
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  void _scan() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QRScanner()),
    );
    String id;
    if (result is String) {
      final code = result;
      Uri uri = Uri.parse(code);

      Secret newSecret = Utils.parseUri(uri);
      id = newSecret.id;
      await DB().insertSecret(newSecret);
    }

    Secret secret = await DB().getSecretById(id);

    setState(() {
      _listOfSecrets.add(secret);
    });
  }
}
