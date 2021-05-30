import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_storage/Database.dart';
import 'package:uuid/uuid.dart';

import 'OTPText.dart';
import 'QRScanner.dart';
import 'SecretDataModel.dart';

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
      ),
      home: OTPsListPage(_listOfSecrets),
    );
  }
}

class OTPsListPage extends StatefulWidget {
  final List<Secret> _listOfSecrets;

  const OTPsListPage(this._listOfSecrets, {Key key}) : super(key: key);

  @override
  _OTPsListPageState createState() => _OTPsListPageState(_listOfSecrets);
}

class _OTPsListPageState extends State<OTPsListPage> {
  final List<Secret> _listOfSecrets;

  _OTPsListPageState(this._listOfSecrets);

  ListTile buildTile(BuildContext context, int index) => ListTile(
        title: OTPText(_listOfSecrets[index].secret),
        subtitle: Text(
          _listOfSecrets[index].label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
      ); // TODO: create ListTile

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Storage"),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: _listOfSecrets.length,
          itemBuilder: buildTile,
          separatorBuilder: (BuildContext context, int index) => Divider(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanner()),
          );
          String id;
          if (result is String) {
            final code = result;
            Uri uri = Uri.parse(code);

            if (uri.scheme.toLowerCase() != "otpauth")
              throw Exception("Invalid protocol");

            OTPType type;
            switch (uri.host.toLowerCase()) {
              case "totp":
                type = OTPType.TOTP;
                break;
              default:
                throw Exception("Unknown OTP type");
            }

            String label = uri.path.toLowerCase().replaceAll('/', '') ?? "";

            var parameters = uri.queryParametersAll;

            dynamic secret = parameters["secret"];
            dynamic issuer = parameters["issuer"];
            dynamic counter = parameters["counter"];
            dynamic period = parameters["period"];
            dynamic digits = parameters["digits"];
            dynamic algorithm = parameters["algorithm"];
            List<String> tags = parameters["tags"];

            if (secret == null)
              throw Exception("Empty secret");
            else
              secret = (secret as List<String>).first;

            if (issuer != null) issuer = (issuer as List<String>).first;

            if (counter != null) {
              counter = int.parse((counter as List<String>).first);
            } else if (type == OTPType.HOTP) {
              throw Exception("Empty counter for HOTP");
            }

            if (period != null) {
              period = int.parse((period as List<String>).first);
            } else if (type == OTPType.TOTP || type == OTPType.STEAM) {
              period = 30;
            }

            if (digits != null)
              digits = int.parse((digits as List<String>).first);
            else
              digits = type == OTPType.STEAM ? 5 : 6;

            if (algorithm != null) {
              switch ((algorithm as List<String>).first) {
                case 'sha1':
                  algorithm = OTPAlgorithm.SHA1;
                  break;
                case 'sha256':
                  algorithm = OTPAlgorithm.SHA256;
                  break;
                case 'sha512':
                  algorithm = OTPAlgorithm.SHA512;
                  break;
                default:
                  algorithm = OTPAlgorithm.SHA1;
                  break;
              }
            } else {
              algorithm = OTPAlgorithm.SHA1;
            }

            if (tags == null) {
              tags = List.empty();
            }

            id = Uuid().v4();
            DB().insertSecret(Secret(
              id: id,
              type: type,
              label: label,
              secret: (secret as String),
              issuer: (issuer as String),
              counter: (counter as int),
              period: (period as int),
              digits: (digits as int),
              algorithm: (algorithm as OTPAlgorithm),
              tags: tags,
            ));
          }

          Secret secret = await DB().getSecretById(id);

          setState(() {
            _listOfSecrets.add(secret);
          });
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }
}

enum OTPType {
  TOTP,
  HOTP,
  MOTP,
  STEAM,
}

enum OTPAlgorithm {
  SHA1,
  SHA256,
  SHA512,
}
