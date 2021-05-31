import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp/otp.dart';

import 'OTPsListPage.dart';
import 'SecretDataModel.dart';

class OTPText extends StatefulWidget {
  final Secret _secret;

  const OTPText(this._secret, {Key key}) : super(key: key);

  @override
  _OTPTextState createState() => _OTPTextState(_secret);
}

class _OTPTextState extends State<OTPText> {
  Secret _secret;
  Timer updateUI;

  _OTPTextState(this._secret);

  String getCode() {
    if (_secret.type == OTPType.TOTP) {
      return OTP.generateTOTPCodeString(
        _secret.secret,
        DateTime.now().millisecondsSinceEpoch,
        length: _secret.digits,
        interval: _secret.period,
        algorithm: _secret.algorithm,
      );
    } else if (_secret.type == OTPType.HOTP) {
      return OTP.generateHOTPCodeString(
        _secret.secret,
        _secret.counter,
        length: _secret.digits,
        algorithm: _secret.algorithm,
      );
    } else
      throw Exception("Unknown OTP type");
  }

  @override
  Widget build(BuildContext context) => Text(
        getCode(),
        style: Theme.of(context).textTheme.headline6,
      );

  @override
  void initState() {
    super.initState();
    updateUI = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        var second = DateTime.now().second;
        if (second == 0 || second == 30) {
          setState(() {});
        }
      },
    );
  }

  @override
  void dispose() {
    updateUI?.cancel();
    super.dispose();
  }
}
