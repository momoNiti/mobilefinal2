import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FriendsScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return FriendsScreenState();
  }
}

Future<List<User>> fetchUsers() async {
  final response = await http.get('https://jsonplaceholder.typicode.com/users');

  List<User> userApi = [];

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    var body = json.decode(response.body);
    for(int i = 0; i< body.length;i++){
      var user = User.fromJson(body[i]);
      userApi.add(user);
    }
    return userApi;
  } else {
    // If that call was not successful, throw an error.
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

class FriendsScreenState extends State<FriendsScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FRIENDS"),),
      body: ListView(
        children: <Widget>[
        ],
      ),
    );
  }

}