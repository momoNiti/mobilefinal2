import 'package:flutter/material.dart';
import 'package:mobilefinal2/util/account.dart';
import 'package:mobilefinal2/util/sharepref.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginScreenState();
  }
}

class LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final AccountProvider db = AccountProvider();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void initState() {
    super.initState();
    // this.db.open('account.db');
    SharedPreferencesUtil.loadLastLogin().then((userId) async {
      await db.open('account.db');
      if (userId != null) {
        setState(() {
          db.getAccountByUserId(userId).then((account) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen(account)),
            );
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
      ),
      body: Padding(
          padding: EdgeInsets.all(18),
          child: ListView(
            children: <Widget>[
              Center(
                child: Image.asset(
                  'assets/dog.jpg',
                  width: 250,
                  height: 250,
                ),
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "User Id", icon: Icon(Icons.people)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill out this form";
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                          labelText: "Password", icon: Icon(Icons.lock)),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Please fill out this form";
                        }
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text("LOGIN"),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                db
                                    .getAccountByUserId(emailController.text)
                                    .then((account) {
                                  if (account == null ||
                                      passwordController.text !=
                                          account.password) {
                                    print("no account or wrong password");
                                  } else {
                                    SharedPreferencesUtil.saveLastLogin(
                                        emailController.text);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomeScreen(account)),
                                    );
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    FlatButton(
                      child: Text("Register New Account"),
                      padding: EdgeInsets.only(
                        left: 180,
                        right: 0,
                        top: 0,
                        bottom: 0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "register");
                      },
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
