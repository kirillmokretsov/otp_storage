import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:otp_storage/datamodel/SecretDataModel.dart';
import 'package:otp_storage/enum/OTPType.dart';
import 'package:otp_storage/utils/Utils.dart';

class EditSecretDialog extends StatefulWidget {
  final Secret _secret;
  final String _encryptionKey;

  const EditSecretDialog(this._secret, this._encryptionKey, {Key key})
      : super(key: key);

  @override
  _EditSecretDialogState createState() =>
      _EditSecretDialogState(_secret, _encryptionKey);
}

class _EditSecretDialogState extends State<EditSecretDialog> {
  Secret _secret;
  String _encryptionKey;
  OTPType _type = OTPType.TOTP;
  Algorithm _algorithm = Algorithm.SHA1;

  final _secretController = TextEditingController();
  final _labelController = TextEditingController();
  final _issuerController = TextEditingController();
  final _counterOrPeriodController = TextEditingController();
  final _digitsController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  _EditSecretDialogState(this._secret, this._encryptionKey);

  @override
  void initState() {
    super.initState();

    _type = _secret.type;
    _algorithm = _secret.algorithm;
    _secretController.text = _secret.secret;
    _labelController.text = _secret.label;
    _issuerController.text = _secret.issuer;
    if (_secret.type == OTPType.TOTP)
      _counterOrPeriodController.text = _secret.period.toString();
    else if (_secret.type == OTPType.HOTP)
      _counterOrPeriodController.text = _secret.counter.toString();
    else
      throw Exception("Unknown OTP type");
    _digitsController.text = _secret.digits.toString();
  }

  @override
  void dispose() {
    _secretController.dispose();
    _labelController.dispose();
    _issuerController.dispose();
    _counterOrPeriodController.dispose();
    _digitsController.dispose();
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
              _algorithmField(node),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_key.currentState.validate()) {
              var map = _secret.toMap(_encryptionKey);
              map['secret'] = Utils.encryptSecret(_secretController.text, _encryptionKey);
              map['type'] = _type.toString();
              map['label'] = _labelController.text;
              map['issuer'] = _issuerController.text;
              map['counter'] = int.parse(_counterOrPeriodController.text);
              map['period'] = int.parse(_counterOrPeriodController.text);
              map['digits'] = int.parse(_digitsController.text);
              map['algorithm'] = _algorithm.toString();
              _secret = Secret.fromMap(map, _encryptionKey);
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

  Column _typeField(FocusScopeNode node) => Column(
        children: [
          RadioListTile(
            title: Text('TOTP'),
            value: OTPType.TOTP,
            groupValue: _type,
            onChanged: (newValue) {
              setState(
                () {
                  _type = newValue;
                },
              );
            },
          ),
          RadioListTile(
            title: Text('HOTP'),
            value: OTPType.HOTP,
            groupValue: _type,
            onChanged: (newValue) {
              setState(
                () {
                  _type = newValue;
                },
              );
            },
          ),
        ],
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

  Column _algorithmField(FocusScopeNode node) => Column(
        children: [
          RadioListTile(
            title: Text('SHA1'),
            value: Algorithm.SHA1,
            groupValue: _algorithm,
            onChanged: (newValue) {
              setState(
                () {
                  _algorithm = newValue;
                },
              );
            },
          ),
          RadioListTile(
            title: Text('SHA256'),
            value: Algorithm.SHA256,
            groupValue: _algorithm,
            onChanged: (newValue) {
              setState(
                () {
                  _algorithm = newValue;
                },
              );
            },
          ),
          RadioListTile(
            title: Text('SHA512'),
            value: Algorithm.SHA512,
            groupValue: _algorithm,
            onChanged: (newValue) {
              setState(
                () {
                  _algorithm = newValue;
                },
              );
            },
          ),
        ],
      );
}
