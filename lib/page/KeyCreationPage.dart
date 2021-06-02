import 'package:flutter/material.dart';
import 'package:otp_storage/database/Database.dart';
import 'package:otp_storage/datamodel/SecretDataModel.dart';
import 'package:otp_storage/utils/Utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'OTPsListPage.dart';

// TODO: allow user to change key

class KeyCreationPage extends StatefulWidget {
  const KeyCreationPage({Key key}) : super(key: key);

  @override
  _KeyCreationPageState createState() => _KeyCreationPageState();
}

class _KeyCreationPageState extends State<KeyCreationPage> {
  String _key;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Welcome to OTP Storage!'),
          // TODO: add help
        ),
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(64, 0, 64, 0),
                child: TextFormField(
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(),
                    ),
                    labelText: 'New encryption key',
                    hintText: 'Enter key',
                  ),
                  onChanged: (value) => _key = value,
                  onEditingComplete: () => FocusScope.of(context).unfocus(),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  // TODO: add check that key is valid
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final map = Utils.getEncryptedDecryptedTest(_key);
                  prefs.setBool('key_exist', true);
                  prefs.setString('decrypted_test', map['decrypted_test']);
                  prefs.setString('encrypted_test', map['encrypted_test']);
                  List<Secret> _listOfSecrets = await DB().getSecrets(_key);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          OTPsListPage(_listOfSecrets, _key),
                    ),
                  );
                },
                child: Text('Save key'),
              ),
            ],
          ),
        ),
      );
}
