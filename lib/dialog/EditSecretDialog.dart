import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
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

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  _EditSecretDialogState(this._secret);

  @override
  void initState() {
    super.initState();

    _secretController.text = _secret.secret;
    _typeController.text = _secret.type.toString();
    _labelController.text = _secret.label;
    _issuerController.text = _secret.issuer;
    if (_secret.type == OTPType.TOTP)
      _counterOrPeriodController.text = _secret.period.toString();
    else if (_secret.type == OTPType.HOTP)
      _counterOrPeriodController.text = _secret.counter.toString();
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
    var counterOrPeriodLabel =
        _secret.type == OTPType.HOTP ? 'Counter' : 'Period';
    var counterOrPeriodHint =
        _secret.type == OTPType.HOTP ? 'Enter counter' : 'Enter period';
    final node = FocusScope.of(context);
    return AlertDialog(
      title: Text("Enter new values"),
      content: Container(
        width: MediaQuery.of(context).size.width / 1.2,
        child: Form(
          key: _key,
          child: ListView(
            children: [
              _secretField(node),
              Divider(),
              // TODO: make radio button instead
              _typeField(node),
              Divider(),
              _labelField(node),
              Divider(),
              _issuerField(node),
              Divider(),
              _counterOrPeriodField(
                node,
                counterOrPeriodLabel,
                counterOrPeriodHint,
              ),
              Divider(),
              _digitsField(node),
              Divider(),
              // TODO: make radio button instead
              _algorithmField(node),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_key.currentState.validate()) {
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
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }

  TextFormField _secretField(FocusScopeNode node) => TextFormField(
        controller: _secretController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: 'Secret',
          hintText: 'Enter secret',
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.nextFocus(),
        validator: (string) {
          if (string == null || string.isEmpty) {
            return "Secret must not be empty";
          } else if (string.length % 2 != 0 ||
              !RegExp(r'^[A-Z2-7=]+$').hasMatch(string)) {
            // Check that it is base32
            return "Provide valid base32 string";
          } else {
            return null;
          }
        },
      );

  TextFormField _typeField(FocusScopeNode node) => TextFormField(
        controller: _typeController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: 'Type',
          hintText: 'Enter type',
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.nextFocus(),
        validator: (string) {
          if (string == null || string.isEmpty) {
            return 'Type must not be empty';
          } else if (string != OTPType.TOTP.toString() &&
              string != OTPType.HOTP.toString()) {
            return 'OTP type must be ${OTPType.TOTP} or ${OTPType.HOTP}';
          } else {
            return null;
          }
        },
      );

  TextFormField _labelField(FocusScopeNode node) => TextFormField(
        controller: _labelController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: 'Label',
          hintText: 'Enter label',
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.nextFocus(),
      );

  TextFormField _issuerField(FocusScopeNode node) => TextFormField(
        controller: _issuerController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: 'Issuer',
          hintText: 'Enter issuer',
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.nextFocus(),
      );

  TextFormField _counterOrPeriodField(
    FocusScopeNode node,
    String counterOrPeriodLabel,
    String counterOrPeriodHint,
  ) =>
      TextFormField(
        controller: _counterOrPeriodController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: counterOrPeriodLabel,
          hintText: counterOrPeriodHint,
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.nextFocus(),
        validator: (string) {
          if (string == null || string.isEmpty) {
            return "Period or counter must not be empty";
          }
          try {
            int.parse(string);
            return null;
          } catch (exception) {
            return 'Provide integer';
          }
        },
      );

  TextFormField _digitsField(FocusScopeNode node) => TextFormField(
        controller: _digitsController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: 'Digits',
          hintText: 'Enter digits',
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.nextFocus(),
        validator: (string) {
          if (string == null || string.isEmpty) {
            return "Digits must not be empty";
          }
          try {
            int.parse(string);
            return null;
          } catch (exception) {
            return 'Provide integer';
          }
        },
      );

  TextFormField _algorithmField(FocusScopeNode node) => TextFormField(
        controller: _algorithmController,
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(),
          ),
          labelText: 'Algorithm',
          hintText: 'Enter algorithm',
        ),
        onChanged: (string) => setState(() {}),
        onEditingComplete: () => node.unfocus(),
        validator: (string) {
          if (string == null || string.isEmpty) {
            return 'Algorithm must not be empty';
          } else if (string != Algorithm.SHA1.toString() &&
              string != Algorithm.SHA256.toString() &&
              string != Algorithm.SHA512.toString()) {
            return 'Algorithm must be ${Algorithm.SHA1} or ${Algorithm.SHA256} or ${Algorithm.SHA512}';
          } else {
            return null;
          }
        },
      );
}
