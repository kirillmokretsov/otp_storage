import 'package:flutter/material.dart';

class OTPIcon extends StatefulWidget {
  final IconData _icon;

  static _OTPIconState of(BuildContext context) => context.findAncestorStateOfType<_OTPIconState>();

  OTPIcon(this._icon, {Key key}) : super(key: key);

  @override
  _OTPIconState createState() => _OTPIconState(_icon);

}

class _OTPIconState extends State<OTPIcon> {
  IconData _icon;

  _OTPIconState(this._icon);

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Icon(_icon);
  }
}
