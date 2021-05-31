import 'package:about/about.dart';
import 'package:flutter/material.dart';

import '../database/Database.dart';
import '../widget/OTPListTile.dart';
import 'QRScanner.dart';
import '../datamodel/SecretDataModel.dart';
import '../utils/Utils.dart';

class OTPsListPage extends StatefulWidget {
  final List<Secret> _listOfSecrets;

  const OTPsListPage(this._listOfSecrets, {Key key}) : super(key: key);

  @override
  _OTPsListPageState createState() => _OTPsListPageState(_listOfSecrets);
}

class _OTPsListPageState extends State<OTPsListPage> {
  final List<Secret> _listOfSecrets;

  _OTPsListPageState(this._listOfSecrets);

  ListTile buildTile(BuildContext context, int index) =>
      OTPListTile(_listOfSecrets[index]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Storage"),
        actions: [
          IconButton(
            onPressed: _showAbout,
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

  void _showAbout() {
    showAboutPage(
      context: context,
      values: {
        'year': DateTime.now().year.toString(),
      },
      title: Text(
        'OTP Storage',
      ),
      applicationName: 'OTP Storage',
      applicationVersion: '1.0.0',
      applicationIcon: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(
          'assets/icon/app.png',
          fit: BoxFit.scaleDown,
        ),
      ),
      applicationLegalese: 'Copyright © Kirill Mokretsov, {{ year }}',
      applicationDescription: Text(
        'Storage for one-time passwords',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      children: <Widget>[
        MarkdownPageListTile(
          icon: Icon(Icons.menu_book_outlined),
          title: Text("View README"),
          filename: "README.md",
        ),
        // TODO: add changelog
        MarkdownPageListTile(
          icon: Icon(Icons.description),
          title: Text("View license"),
          filename: "LICENSE.md",
        ),
        // TODO: add contributing
        // TODO: add code of conduct
        LicensesPageListTile(
          icon: Icon(Icons.favorite),
          title: Text("Open source licenses"),
        ),
      ],
    );
  }
}
