import 'dart:async';

import 'package:flutter/material.dart';
import 'package:otp/otp.dart';

class OTPText extends StatefulWidget {
  final String _secret;

  const OTPText(this._secret, {Key key}) : super(key: key);

  @override
  _OTPTextState createState() => _OTPTextState(_secret);
}

class _OTPTextState extends State<OTPText> {
  String _secret;
  Timer updateUI;

  _OTPTextState(this._secret);

  @override
  Widget build(BuildContext context) {
    return Text(
      OTP.generateTOTPCodeString(
          _secret, DateTime.now().millisecondsSinceEpoch),
    );
  }

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
