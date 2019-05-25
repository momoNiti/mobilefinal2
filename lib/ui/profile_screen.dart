import 'package:flutter/material.dart';
import 'package:mobilefinal2/ui/home_screen.dart';
import 'package:mobilefinal2/util/account.dart';
import 'package:mobilefinal2/util/sharepref.dart';


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
  void initState() {
    super.initState();
    SharedPreferencesUtil.loadLastLogin().then((value) async {
      await db.open('account.db');
      db.getAccountByUserId(value).then((values) {
        ProfileScreenState.account = values;
        userNameController.text = values.userName;
        nameController.text = values.name;
        ageController.text = values.age.toString();
      });
    });
    SharedPreferencesUtil.loadQuote().then((value) {
      setState(() {
        quoteController.text = value;
      });
    });
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
                      decoration: InputDecoration(labelText: "Username"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Username is required";
                      },
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name"),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) return "Name is required";
                      },
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: "Age"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return "Age is required";
                      },
                    ),
                    TextFormField(
                      controller: quoteController,
                      decoration: InputDecoration(labelText: "Quotes"),
                      validator: (value) {
                        if (value.isEmpty) return "Quotes is required";
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text("Save"),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                db.update(
                                  Account(
                                    id: account.id,
                                    userName: userNameController.text,
                                    name: nameController.text,
                                    age: int.parse(ageController.text),
                                    password: account.password
                                  ),
                                );
                                SharedPreferencesUtil.saveQuote(
                                    quoteController.text);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(account)));
                              }
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text("BACK"),
                            onPressed: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          HomeScreen(account)));
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
