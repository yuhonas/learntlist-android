import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(LearntListApp());
}

/*
------------------------
  MODEL
------------------------
 */
class LearntItem {
  final int id;
  final String title;
  final String description;

  LearntItem({this.id, this.title, this.description});

  factory LearntItem.fromJson(Map<String, dynamic> json) {
    return new LearntItem(
      id: json['id'],
      title: json['title'],
      description: json['description']
    );
  }
}

class LearntListApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearntList',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark
      ),
      home: LearntListItemsPage(title: 'Learnt List'),
    );
  }
}

class LearntListItemsPage extends StatefulWidget {
  LearntListItemsPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LearntListItemsPageState createState() => _LearntListItemsPageState();
}

class _LearntListItemsPageState extends State<LearntListItemsPage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //final wordPair = WordPair.random();
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: BodyLayout(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
/*
------------------------
  VIEW
------------------------
 */
class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LearntItem>>(
      future: _fetchLearntItems(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<LearntItem> data = snapshot.data;
          return _learntItemView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  ListView _learntItemView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].title, data[index].description);
        });
  }

  ListTile _tile(String title, String description) => ListTile(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
      subtitle: Text(description)
  );

/*
------------------------
  API
------------------------
 */
  Future<List<LearntItem>> _fetchLearntItems() async {
    final jobsListAPIUrl = 'https://www.learntlist.com/api/learnt_items';
    final response = await http.get(jobsListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((job) => new LearntItem.fromJson(job)).toList();
    } else {
      throw Exception('Failed to load jobs from API');
    }
  }
}
