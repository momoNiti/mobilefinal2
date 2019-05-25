import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TodoesScreen extends StatefulWidget {
  final int id;
  final String name;

  TodoesScreen({Key key, @required this.id, @required this.name})
      : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return TodoesScreenState();
  }
}

Future<List<Todoes>> loadUsers(int userId) async {
  final response = await http
      .get('https://jsonplaceholder.typicode.com/todos?userId=${userId}');

  List<Todoes> userApi = [];

  if (response.statusCode == 200) {
    var body = json.decode(response.body);
    for (int i = 0; i < body.length; i++) {
      var user = Todoes.fromJson(body[i]);
      userApi.add(user);
    }
    return userApi;
  } else {
    throw Exception('Failed to load post');
  }
}

class Todoes {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  Todoes({this.userId, this.id, this.title, this.completed});

  factory Todoes.fromJson(Map<String, dynamic> json) {
    return Todoes(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}

class TodoesScreenState extends State<TodoesScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name} Todo"),
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
            future: loadUsers(widget.id),
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
    List<Todoes> values = snapshot.data;
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
                    "${(values[index].id).toString()}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  Padding(padding: EdgeInsets.fromLTRB(0, 15, 0, 10)),
                  Text(
                    values[index].title.toString(),
                    style: TextStyle(fontSize: 16),
                  ),
                  values[index].completed == true?
                    Text(
                    "Completed",
                    style: TextStyle(fontSize: 16),
                  ):Text("")

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
