import 'package:flutter/material.dart';
import 'package:mobilefinal2/ui/home_screen.dart';
import 'package:mobilefinal2/util/account.dart';
import 'package:mobilefinal2/util/sharepref.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ProfileScreenState();
  }
}

class ProfileScreenState extends State<ProfileScreen> {
  final _formkey = GlobalKey<FormState>();
  final AccountProvider db = AccountProvider();
  static Account account;
  TextEditingController userNameController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController quoteController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
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
      return contents;
    } catch (e) {
      return "";
    }
  }

  //
  void initState() {
    super.initState();
    readQuote().then((value) {
      setState(() {
        quoteController.text = value;
      });
    });
    SharedPreferencesUtil.loadLastLogin().then((value) async {
      await db.open('account.db');
      db.getAccountByUserId(value).then((values) {
        ProfileScreenState.account = values;
        userNameController.text = values.userName;
        nameController.text = values.name;
        ageController.text = values.age.toString();
        passwordController.text = values.password;
      });
    });
  }

  int countSpace(String s) {
    int result = 0;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ' ') {
        result += 1;
      }
    }
    return result;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PROFILE"),
      ),
      body: Padding(
          padding: EdgeInsets.all(18),
          child: ListView(
            children: <Widget>[
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: userNameController,
                      decoration: InputDecoration(labelText: "User Id"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "User Id is required";
                        }
                        if (value.length < 6 || value.length > 12) {
                          return "ต้องมีความยาวอยู่ในช่วง 6-12 ตัวอักษร";
                        }
                      },
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Name is required";
                        }
                        if (countSpace(value) != 1) {
                          return "ชื่อและนามสกุลต้องคั่นด้วย 1 space";
                        }
                      },
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Age is required";
                        }
                        if (!isNumeric(value) ||
                            int.parse(value) < 10 ||
                            int.parse(value) > 80) {
                          return "ต้องเป็นตัวเลขและอยู่ในช่วง 10-80";
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: "Password"),
                      // obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length <= 6) {
                          return "Password ต้องมีความยาวมากกว่า 6";
                        }
                      },
                    ),

                    TextFormField(
                      controller: quoteController,
                      decoration: InputDecoration(labelText: "Quote"),maxLines: 4,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text("Save"),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                writeQuote(quoteController.text);
                                db.update(
                                  Account(
                                      id: account.id,
                                      userName: userNameController.text,
                                      name: nameController.text,
                                      age: int.parse(ageController.text),
                                      password: passwordController.text),
                                );

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen(account)));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
