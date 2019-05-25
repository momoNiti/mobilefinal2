import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobilefinal2/util/account.dart';
import 'package:mobilefinal2/util/sharepref.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  String quotes = "";
  //io
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/counter.txt');
  }

  Future<File> writeQuote(String quote) async {
    final file = await _localFile;
    return file.writeAsString('$quote');
  }

  Future<String> readQuote() async {
    try {
      final file = await _localFile;
      String contents = await file.readAsString();
      // print(contents);
      return contents;
    } catch (e) {
      return "";
    }
  }

  //
  static Account account;
  final AccountProvider db = AccountProvider();
  void initState() {
    super.initState();
    readQuote().then((value) {
      setState(() {
        quotes = value;
      });
    });
    setState(() {
      SharedPreferencesUtil.loadLastLogin().then((value) async {
        await db.open('account.db');
        db.getAccountByUserId(value).then((values) {
          HomeScreenState.account = values;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: <Widget>[
            Text(
              "Hello ${account.name}",
              style: TextStyle(fontSize: 20),
            ),
            Text("This is my quote \"${quotes}\""),
            Padding(
              padding: EdgeInsets.all(10),
            ),
            RaisedButton(
              child: Text("PROFILE SETUP"),
              onPressed: () {
                Navigator.of(context).pushNamed('profile');
              },
            ),
            RaisedButton(
              child: Text("MY FRIENDS"),
              onPressed: () {
                Navigator.of(context).pushNamed('friends');
              },
            ),
            RaisedButton(
              child: Text("SIGN OUT"),
              onPressed: () {
                writeQuote("");
                SharedPreferencesUtil.saveLastLogin(null);
                Navigator.pushReplacementNamed(context, 'login');
                // Navigator.of(context).pushNamed('login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
