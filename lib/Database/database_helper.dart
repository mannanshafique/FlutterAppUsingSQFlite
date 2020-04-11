
// first import the library

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';                        // to deal with file and folder
import 'package:path_provider/path_provider.dart';
import 'package:appfirst/models/note.dart';             // Model Class Import


class DatabaseHelper{

  // declare singleton databasehelper......Singleton means intialize one time and use the whole application


  static DatabaseHelper _databaseHelper;   // Singleton DatabaseHelper
  static Database _database;               //singleton Database

  String noteTable = 'note_table';      // Table
  String colId = "id";
  String colTitle = "title";
  String colDescription = "desciption";
  String colPriority = "priority";
  String colDate = 'date';



  // Constructor 1
  DatabaseHelper._createInstance();       // Named Constuctor

// Constructor 2
  factory DatabaseHelper(){      // factory constructor so factory constructor will retun the value

    if(_databaseHelper == null){              // Condition
    _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{       // getter of singleton database
    if(_database == null){            // agar jo database get kiaya hay wo null hay tou new database (initileed wala method call)
      _database = await initialzedDatabase();
    }
    return _database;
  }


  Future<Database> initialzedDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();     //ye path lay kay ata hay jahan database banta hay
    String path = directory.path + 'notes.db';    // notes.db kay name ka database ban jaye

    var notesDatabase = openDatabase(path,version: 1,onCreate: _createDb); // use the createDb function
    return notesDatabase;
  }


  // ham oncreate may be lick saktay thay par alag method bana kay lika
void _createDb(Database db , int newVersion) async {    // only create Database
    await db.execute('CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT,'
        '$colDescription TEXT, $colPriority INTEGER,  $colDate TEXT)');

  }

  //Fetch Operation  : Get all note objects from database

Future<List<Map<String , dynamic>>> getNoteMapList() async{
    Database db = await this.database;

    var result = await db.query(noteTable,orderBy: '$colPriority ASC'); // this query get data in asc  order

    return result;
}


// Insert Operation : Insert a note object to database
Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
}

// Update Operation : Update a note object to database

Future<int> updateNote(Note note) async {

    Database db = await this. database;
    var result = await db.update(noteTable,note.toMap(),where: '$colId = ?', whereArgs: [note.id],conflictAlgorithm: ConflictAlgorithm.replace);
    return result;

}

// Delete Operation : delete a note object to database

Future<int> deleteNote(int id) async{
    var db = await this. database;
    int result= await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
}
  // Count Operation : Count all note  to database

  Future<int> getNote() async {
    Database db = await this. database;
    List<Map<String,dynamic>> x =await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;

  }

// Get the Map List From database and convert to note list

Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();     // call the fetch operation in that which get map from database
  int count = noteMapList.length;                    //count the no of map entries in db table

    List<Note> notelist = List<Note>();
    //For loop to create a Note List from a Map list
  for(int i = 0; i<count; i++){
    notelist.add(Note.fromMapObject(noteMapList[i]));
  }
    return notelist;
}


}