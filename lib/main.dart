import 'package:appfirst/note_list.dart';
import 'package:flutter/material.dart';
//import 'note_list.dart';
import 'note_details.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Practice",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple
      ),
      home: NoteList(),
    );
  }
}
