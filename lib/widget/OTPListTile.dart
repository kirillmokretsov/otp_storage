import 'package:flutter/material.dart';
import 'package:otp_storage/datamodel/SecretDataModel.dart';
import 'package:otp_storage/dialog/EditSecretDialog.dart';
import 'package:otp_storage/dialog/SetIconDialog.dart';

import '../database/Database.dart';
import '../dialog/TagsDialog.dart';
import 'OTPText.dart';

class OTPListTile extends StatefulWidget {
  final Secret _secret;

  const OTPListTile(this._secret, {Key key}) : super(key: key);

  @override
  _OTPListTileState createState() => _OTPListTileState(_secret);
}

class _OTPListTileState extends State<OTPListTile> {
  Secret _secret;

  _OTPListTileState(this._secret);

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(_secret.icon),
        title: OTPText(_secret),
        subtitle: Text(
          _secret.label,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        trailing: _buildMenu(context),
      );

  PopupMenuButton _buildMenu(BuildContext context) => PopupMenuButton(
        itemBuilder: _buildMenuItems,
        onSelected: (value) {
          _onMenuItemSelected(value, context);
        },
      );

  List<PopupMenuEntry<dynamic>> _buildMenuItems(BuildContext context) {
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
  }

  void _onMenuItemSelected(value, BuildContext context) async {
    switch (value as String) {
      case 'edit':
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) => EditSecretDialog(_secret),
        );
        if (result != null && result is Secret) _secret = result;
        DB().updateSecret(_secret);
        setState(() {});
        break;
      case 'icon':
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) => SetIconDialog(),
        );
        if (result != null && result is IconData) {
          _secret.icon = result;
          DB().updateSecret(_secret);
          setState(() {});
        }
        break;
      case 'tags':
        final result = await showDialog(
          context: context,
          builder: (BuildContext context) => TagsDialog(_secret.tags),
        );
        if (result != null && result is List<String>) {
          _secret.tags = result;
          DB().updateSecret(_secret);
        }
        break;
      default:
        throw Exception("Unknown entry item $value");
    }
  }
}
