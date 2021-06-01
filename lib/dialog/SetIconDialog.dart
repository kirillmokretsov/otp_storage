import 'package:flutter/material.dart';
import 'package:otp_storage/utils/SimpleIconsGetter.dart';

class SetIconDialog extends StatelessWidget {
  final icons = SimpleIconsGetter.getMap().values.toList();

  SetIconDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Choose new icon"),
      content: Container(
        // TODO: add support of landscape mode
        width: MediaQuery.of(context).size.width / 1.2,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(
            icons.length,
            (index) => IconButton(
              icon: Icon(icons[index]),
              onPressed: () {
                Navigator.pop(context, icons[index]);
              },
            ),
          ),
        ),
      ),
    );
  }
}
