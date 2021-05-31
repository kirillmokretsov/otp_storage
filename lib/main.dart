import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:otp_storage/Database.dart';

import 'OTPText.dart';
import 'QRScanner.dart';
import 'SecretDataModel.dart';
import 'TagsDialog.dart';
import 'Utils.dart';

// TODO: add usage for t allow user to edit secret
// TODO: allow user to manually set icons
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
        leading: Icon(
          Utils.findIconByName(_listOfSecrets[index].issuer),
        ),
        title: OTPText(_listOfSecrets[index]),
        subtitle: Text(
          _listOfSecrets[index].label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: PopupMenuButton(
          itemBuilder: (BuildContext context) {
            List<PopupMenuEntry<dynamic>> entries = [];

            entries.add(
              PopupMenuItem(
                value: 'edit',
                child: ListTile(
                  leading: Icon(Icons.edit),
                  title: Text('Edit'),
                ),
              ),
            );
            entries.add(PopupMenuDivider());
            entries.add(
              PopupMenuItem(
                value: 'icon',
                child: ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Set icon'),
                ),
              ),
            );
            entries.add(PopupMenuDivider());
            entries.add(
              PopupMenuItem(
                value: 'tags',
                child: ListTile(
                  leading: Icon(Icons.tag),
                  title: Text('View tags'),
                ),
              ),
            );

            return entries;
          },
          onSelected: (value) async {
            switch (value as String) {
              case 'edit':
                // TODO: show edit dialog
                break;
              case 'icon':
                // TODO: show set icon dialog
                break;
              case 'tags':
                final result = await showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      TagsDialog(_listOfSecrets[index].tags),
                );
                if (result != null && result is List<String>) {
                  _listOfSecrets[index].tags = result;
                  DB().insertSecret(_listOfSecrets[index]);
                }
                break;
              default:
                throw Exception("Unknown entry item $value");
            }
          },
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OTP Storage"),
        actions: [
          IconButton(
            onPressed: () {
              showAboutPage(
                context: context,
                values: {
                  'year': DateTime.now().year.toString(),
                },
                title: Text(
                  'OTP Storage',
                ),
                applicationName: 'OTP Storage',
                applicationVersion: '1.0.0',
                // TODO: add applicationIcon
                applicationLegalese: 'Copyright © Kirill Mokretsov, {{ year }}',
                applicationDescription: Text(
                  'Storage for one-time passwords',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                children: <Widget>[
                  MarkdownPageListTile(
                    icon: Icon(Icons.menu_book_outlined),
                    title: Text("View README"),
                    filename: "README.md",
                  ),
                  // TODO: add changelog
                  MarkdownPageListTile(
                    icon: Icon(Icons.description),
                    title: Text("View license"),
                    filename: "LICENSE.md",
                  ),
                  // TODO: add contributing
                  // TODO: add code of conduct
                  LicensesPageListTile(
                    icon: Icon(Icons.favorite),
                    title: Text("Open source licenses"),
                  ),
                ],
              );
            },
            icon: Icon(Icons.info_outline),
          ),
        ],
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

            Secret newSecret = Utils.parseUri(uri);
            id = newSecret.id;
            await DB().insertSecret(newSecret);
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
