import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  final int id;
  final String name;

  FriendScreen({Key key, @required this.id, @required this.name})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FriendScreenState();
  }
}

class FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.name} Todo"),
      ),
      body: ListView(
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
          Text("${widget.id.toString()} : ${widget.name}",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          RaisedButton(
            child: Text("TODOS"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
