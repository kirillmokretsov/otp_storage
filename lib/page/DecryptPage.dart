import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:otp_storage/database/Database.dart';
import 'package:otp_storage/datamodel/SecretDataModel.dart';
import 'package:otp_storage/page/OTPsListPage.dart';
import 'package:otp_storage/utils/Utils.dart';

class DecryptPage extends StatefulWidget {
  const DecryptPage({Key key}) : super(key: key);

  @override
  _DecryptPageState createState() => _DecryptPageState();
}

class _DecryptPageState extends State<DecryptPage> {
  String _key;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decrypt database'),
        // TODO: add help
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(64, 0, 64, 0),
            child: TextField(
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Key',
                hintText: 'Enter key',
              ),
              onChanged: (value) {
                _key = value;
                setState(() {});
              },
              onSubmitted: (value) {
                _key = value;
                FocusScope.of(context).unfocus();
                setState(() {});
              },
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (await Utils.isKeyIsRight(_key)) {
                List<Secret> _listOfSecrets = await DB().getSecrets(_key);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        OTPsListPage(_listOfSecrets, _key),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Wrong key!'),
                  ),
                );
              }
            },
            child: Text('Decrypt'),
          ),
        ],
      ),
    );
  }
}
