import 'package:flutter/material.dart';
import 'package:mobilefinal2/util/account.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterScreenState();
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  final AccountProvider db = AccountProvider();
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void open() async {
    await db.open('account.db');
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
    open();
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
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
                      controller: userIdController,
                      decoration: InputDecoration(labelText: "User Id", icon: Icon(Icons.person)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "User Id is required";
                        }                        
                        if (value.length < 6 || value.length > 12){
                          return "ต้องมีความยาวอยู่ในช่วง 6-12 ตัวอักษร";
                        }
                      },
                    ),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(labelText: "Name", icon: Icon(Icons.person_outline)),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value.isEmpty){
                          return "Name is required";
                        }
                        if (countSpace(value) != 1) {
                          return "ชื่อและนามสกุลต้องคั่นด้วย 1 space";
                        }
                      },
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration: InputDecoration(labelText: "Age", icon: Icon(Icons.calendar_today)),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty){
                          return "Age is required";
                        }
                        if (!isNumeric(value) ||
                            int.parse(value) < 10 ||
                            int.parse(value) > 80){
                              return "ต้องเป็นตัวเลขและอยู่ในช่วง 10-80";
                            }
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(labelText: "Password", icon: Icon(Icons.lock)),
                      obscureText: true,
                      validator: (value) {
                        if (value.isEmpty){
                          return "Password is required";
                        }
                        if (value.length < 6){
                          return "Password ต้องมีความยาวมากกว่า 6";
                        }
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: RaisedButton(
                            child: Text("Register"),
                            onPressed: () {
                              if (_formkey.currentState.validate()) {
                                db
                                    .insert(
                                  Account(
                                    userName: userIdController.text,
                                    name: nameController.text,
                                    age: int.parse(ageController.text),
                                    password: passwordController.text,
                                  ),
                                )
                                    .then((_) {
                                  Navigator.pop(context);
                                });
                              } else {
                                print("error");
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
