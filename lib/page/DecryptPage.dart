import 'package:flutter/material.dart';

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
              onPressed: () {
                // TODO: push to OTPsListPage
              },
              child: Text('Decrypt'),
            ),
          ],
        ),
      ),
    );
  }
}
