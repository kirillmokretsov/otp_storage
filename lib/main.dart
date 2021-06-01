import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_storage/database/Database.dart';

import 'page/OTPsListPage.dart';
import 'datamodel/SecretDataModel.dart';

// TODO: add time indicator (maybe https://api.flutter.dev/flutter/material/LinearProgressIndicator-class.html)
// TODO: add encryption

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Strangely, async method shouldn't be called in constructor
  // even if you await database in other methods
  await DB().initDB();
  List<Secret> _listOfSecrets = await DB().getSecrets();
  runApp(MyApp(_listOfSecrets));
}

class MyApp extends StatelessWidget {
  final List<Secret> _listOfSecrets;

  MyApp(this._listOfSecrets);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
      ),
      home: OTPsListPage(_listOfSecrets),
    );
  }
}
