import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobilefinal2/ui/friend_screen.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FriendsScreenState();
  }
}

Future<List<User>> loadUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var user = User.fromJson(body[i]);
      userApi.add(user);
    }
    return userApi;
  } else {
    throw Exception('Failed to load post');
  }
}

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String website;

  User({this.id, this.name, this.email, this.phone, this.website});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      website: json['website'],
    );
  }
}

class FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
      ),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: RaisedButton(
                  child: Text("BACK"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(5),
          ),
          FutureBuilder(
            future: loadUsers(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasError) print("load data error");
              return snapshot.hasData
                  ? FriendList(context, snapshot)
                  : Center(
                      child: CircularProgressIndicator(),
                    );
            },
          )
        ],
      ),
    );
  }

  Widget FriendList(BuildContext context, AsyncSnapshot snapshot) {
    List<User> values = snapshot.data;
    return new Expanded(
      child: new ListView.builder(
        itemCount: values.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: new InkWell(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${(values[index].id).toString()} : ${values[index].name}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                  Text(
                    values[index].email,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    values[index].phone,
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    values[index].website,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriendScreen(
                        id: values[index].id, name: values[index].name),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
