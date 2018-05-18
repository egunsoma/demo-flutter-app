import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Apod> fetchApod() async {
  final response =
      await http.get('https://api.nasa.gov/planetary/apod?api_key=hhC6Wfz0AxJX2AlnngU76lfIiwehn6haFGGi9KQa');
  final responseJson = json.decode(response.body);

  return new Apod.fromJson(responseJson);
}

class Apod {
  final String title;
  final String url;

  Apod({this.title, this.url});

  factory Apod.fromJson(Map<String, dynamic> json) {
    return new Apod(
      title: json['title'],
      url: json['url'],
    );
  }
}

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Astronomy Picture of the Day'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new FutureBuilder<Apod>(
          future: fetchApod(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Image.network(snapshot.data.url),
                  new Text(snapshot.data.title)
                ]
              ); 
            } else if (snapshot.hasError) {
              return new Text("${snapshot.error}");
            }
            return new CircularProgressIndicator();
          },
        )
      ),
    );
  }
}
