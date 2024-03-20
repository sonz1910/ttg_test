import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Master Data',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Master Data'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<dynamic> _data;
  late TextEditingController _controller;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();
    _data = [];
    _controller = TextEditingController();
    _editController = TextEditingController();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.20:3000/api/data'));
    if (response.statusCode == 200) {
      setState(() {
        _data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _addData(String name) async {
    int r = Random().nextInt(1000);
    await http.post(
      Uri.parse('http://192.168.1.20:3000/api/data'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': r,
        'name': name,
      }),
    );
    _fetchData();
  }

  Future<void> _deleteData(int id) async {
    await http.delete(Uri.parse('http://192.168.1.20:3000/api/data/$id'));
    _fetchData();
  }

  Future<void> _updateData(int id, String newName) async {
    await http.put(
      Uri.parse('http://192.168.1.20:3000/api/data/$id'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'name': newName,
      }),
    );
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_data[index]['name']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Edit Data'),
                          content: TextField(
                            controller: _editController,
                            decoration:
                                InputDecoration(hintText: 'Enter new name'),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                _editController.clear();
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateData(
                                    _data[index]['id'], _editController.text);
                                _editController.clear();
                                Navigator.of(context).pop();
                              },
                              child: Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteData(_data[index]['id']);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add Data'),
                content: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Enter data name'),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      _controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addData(_controller.text);
                      _controller.clear();
                      Navigator.of(context).pop();
                    },
                    child: Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add Data',
        child: Icon(Icons.add),
      ),
    );
  }
}
