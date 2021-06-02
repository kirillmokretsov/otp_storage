import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      body: Center(
        child: Column(
          children: [
            TextField(
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
            ElevatedButton(
              onPressed: () async {
                SharedPreferences _test = await SharedPreferences.getInstance();
                String encryptedTest = _test.getString('encrypted_test') ?? '';
                String decryptedTest = _test.getString('decrypted_test') ?? '';
                if (encryptedTest == '' || decryptedTest == '') {
                  throw Exception(
                      'No encrypted_test or decrypted_test shared preference');
                } else {
                  final key = encrypt.Key.fromUtf8(_key);
                  final encrypter = encrypt.Encrypter(encrypt.AES(key));
                  final encrypted = encrypt.Encrypted.fromBase64(encryptedTest);
                  final decrypted = encrypter.decrypt(encrypted);
                  if (decrypted == decryptedTest) {
                    // TODO: decrypt database and send to OTPsListPage
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Wrong key!'),
                      ),
                    );
                  }
                }
              },
              child: Text('Decrypt'),
            ),
          ],
        ),
      ),
    );
  }
}
