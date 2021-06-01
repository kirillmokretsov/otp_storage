import 'package:flutter/material.dart';
import 'package:otp_storage/datamodel/SecretDataModel.dart';
import 'package:otp_storage/enum/OTPType.dart';

class EditSecretDialog extends StatefulWidget {
  final Secret _secret;

  const EditSecretDialog(this._secret, {Key key}) : super(key: key);

  @override
  _EditSecretDialogState createState() => _EditSecretDialogState(_secret);
}

class _EditSecretDialogState extends State<EditSecretDialog> {
  Secret _secret;

  final _secretController = TextEditingController();
  final _typeController = TextEditingController();
  final _labelController = TextEditingController();
  final _issuerController = TextEditingController();
  final _counterOrPeriodController = TextEditingController();
  final _digitsController = TextEditingController();
  final _algorithmController = TextEditingController();

  _EditSecretDialogState(this._secret);

  @override
  void initState() {
    super.initState();

    _secretController.text = _secret.secret;
    _typeController.text = _secret.type.toString();
    _labelController.text = _secret.label;
    _issuerController.text = _secret.issuer;
    if (_secret.type == OTPType.TOTP)
      _counterOrPeriodController.text =
          _secret.period.toString();
    else if (_secret.type == OTPType.HOTP)
      _counterOrPeriodController.text =
          _secret.counter.toString();
    else
      throw Exception("Unknown OTP type");
    _digitsController.text = _secret.digits.toString();
    _algorithmController.text = _secret.algorithm.toString();
  }

  @override
  void dispose() {
    _secretController.dispose();
    _typeController.dispose();
    _labelController.dispose();
    _issuerController.dispose();
    _counterOrPeriodController.dispose();
    _digitsController.dispose();
    _algorithmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Enter new values"),
      content: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: ListView(
          children: [
            // TODO: check what user types
            // Secret
            TextField(
              controller: _secretController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Secret',
                hintText: 'Enter secret',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: continue to next field,
            ),
            Divider(),
            // Type
            // TODO: make radio button instead
            TextField(
              controller: _typeController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Type',
                hintText: 'Enter type',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: continue to next field,
            ),
            Divider(),
            // Label
            TextField(
              controller: _labelController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Label',
                hintText: 'Enter label',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: continue to next field,
            ),
            Divider(),
            // Issuer
            TextField(
              controller: _issuerController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Issuer',
                hintText: 'Enter issuer',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: continue to next field,
            ),
            Divider(),
            // Counter or period (depends on type)
            // TODO: change hint text by type
            TextField(
              controller: _counterOrPeriodController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Counter or period',
                hintText: 'Enter counter or period',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: continue to next field,
            ),
            Divider(),
            // Digits
            TextField(
              controller: _digitsController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Digits',
                hintText: 'Enter digits',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: continue to next field,
            ),
            Divider(),
            // Algorithm
            TextField(
              controller: _algorithmController,
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                labelText: 'Algorithm',
                hintText: 'Enter algorithm',
              ),
              onChanged: (string) => setState(() {}),
              // onSubmitted: // TODO: close keyboard,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            var map = _secret.toMap();
            map['secret'] = _secretController.text;
            map['type'] = _typeController.text;
            map['label'] = _labelController.text;
            map['issuer'] = _issuerController.text;
            map['counter'] = int.parse(_counterOrPeriodController.text);
            map['period'] = int.parse(_counterOrPeriodController.text);
            map['digits'] = int.parse(_digitsController.text);
            map['algorithm'] = _algorithmController.text;
            _secret = Secret.fromMap(map);
            Navigator.pop(context, _secret);
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}
