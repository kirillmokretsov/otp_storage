import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_storage/database/Database.dart';
import 'package:otp_storage/page/DecryptPage.dart';
import 'package:otp_storage/page/KeyCreationPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// TODO: add time indicator (maybe https://api.flutter.dev/flutter/material/LinearProgressIndicator-class.html)
// TODO: add encryption
// TODO: use tips from this article https://medium.com/flutter-community/how-to-make-a-flutter-app-with-high-security-880ef0aa54da

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Strangely, async method shouldn't be called in constructor
  // even if you await database in other methods
  await DB().initDB();

  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  Widget home;
  if (sharedPreferences.getBool('key_exist') ?? false) {
    home = DecryptPage();
  } else {
    home = KeyCreationPage();
  }
  runApp(MyApp(home));
}

class MyApp extends StatelessWidget {
  final Widget home;

  MyApp(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OTP Storage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.amberAccent,
      ),
      home: home,
    );
  }
}
