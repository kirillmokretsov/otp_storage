import 'package:flutter/material.dart';
import 'package:otp_storage/datamodel/SecretDataModel.dart';

class EditSecretDialog extends StatefulWidget {

  final Secret _secret;

  const EditSecretDialog(this._secret, {Key key}) : super(key: key);

  @override
  _EditSecretDialogState createState() => _EditSecretDialogState(_secret);
}

class _EditSecretDialogState extends State<EditSecretDialog> {

  Secret _secret;

  _EditSecretDialogState(this._secret);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter new values"),
      content: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: ListView(
          children: [
            // Secret
            Divider(),
            // Type
            Divider(),
            // Label
            Divider(),
            // Issuer
            Divider(),
            // Counter or period (depends on type)
            Divider(),
            // Digits
            Divider(),
            // Algorithm
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, _secret);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
