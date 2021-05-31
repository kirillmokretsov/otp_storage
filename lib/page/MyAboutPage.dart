import 'package:about/about.dart';
import 'package:flutter/material.dart';

class MyAboutPage {
  static void showAbout(BuildContext context) {
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
      applicationIcon: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(
          'assets/icon/app.png',
          fit: BoxFit.scaleDown,
        ),
      ),
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
  }
}
