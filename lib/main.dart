import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = 'https://api.github.com/repositories';
  List data;
  List repoData;

  Future<String> makeRequest() async {
    var response = await http.get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    setState(() {
      data = jsonDecode(response.body);
    });
  }

  @override
  void initState() {
    this.makeRequest();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Contact List'),
        ),
        body: new ListView.builder(
            itemCount: data == null ? 0 : data.length,
            itemBuilder: (BuildContext context, i) {
              return new ListTile(
                title: new Text(data[i]["name"] == null ? '' : data[i]["name"]),
                subtitle: new Text(data[i]["description"] == null ? '' : data[i]["description"]),
                leading: new CircleAvatar(
                  backgroundImage:
                  new NetworkImage(data[i]["owner"]["avatar_url"] == null ? '' : data[i]["owner"]["avatar_url"]),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new SecondPage(data[i])
                      )
                  );
                },
              );
            }
        )
    );
  }
}

class SecondPage extends StatelessWidget {
  SecondPage(this.data);
  final data;
  String repoStars;
  String repoLanguage;

  Future<String> makeDetailRequest() async {
    var response = await http.get(Uri.encodeFull(data["url"]), headers: {"Accept": "application/json"});
    if (response.statusCode == 200) {
      var repoDetails = jsonDecode(response.body);
      repoStars = repoDetails['stargazers_count'];
      repoLanguage = repoDetails['language'];
    } else {
      repoStars = '100';
      repoLanguage = 'Ruby';
    }
  }

  @override
  void initState() {
    this.makeDetailRequest();
  }

  @override
  Widget build(BuildContext context) => new Scaffold(
      appBar: new AppBar(title: new Text('Detail Page')),
      body: new Card(
        child: new Column(
          children: [
            new Container(
              width: 100.0,
              height: 100.0,
              decoration: new BoxDecoration(
                color: const Color(0xff7c94b6),
                image: new DecorationImage(
                  image: new NetworkImage(data["owner"]["avatar_url"]),
                  fit: BoxFit.cover,
                ),
                borderRadius: new BorderRadius.all(new Radius.circular(75.0)),
              ),
            ),
            new Center(
              child: new Text(
                "Repository name: ${data["name"] == null ? '' : data["name"]}",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            new Text(data["description"] == null ? '' : data["description"]),
            new Text("Stars: ${repoStars == null ? '' : repoStars}"),
            new Text("Language: ${repoLanguage == null ? '' : repoLanguage}"),
          ],
        ),
      )
  );
}

class repoStars {
}
