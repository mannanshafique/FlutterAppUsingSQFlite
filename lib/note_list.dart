import 'package:flutter/material.dart';
import 'note_details.dart';
import 'dart:async';
import 'package:appfirst/models/note.dart';
import 'Database/database_helper.dart';
import 'package:sqflite/sqflite.dart';


//Homepage Like Which the notes
class NoteList extends StatefulWidget {

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

  DatabaseHelper databaseHelper = DatabaseHelper();        //  database helper class use ke
  List<Note> notelist;                                    //Note.dart Class use ke
  int count = 0;


  @override
  Widget build(BuildContext context) {

    if(notelist == null){
      notelist = List<Note>();              //Agar null ho tou Note.dart Class sAy data laye
      updateList();
    }

    return Scaffold(
      appBar: AppBar(
        title: new Text(
          "Notes",
          style: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: getNotListView(),
      floatingActionButton: FloatingActionButton(onPressed:(){
        debugPrint('Fab Clicked');
        NavigatetoEditDetail(Note('','',2));

      },
      child: Icon(Icons.add),
        tooltip: 'Add Note',
      ),
    );
  }
  ListView getNotListView(){
    TextStyle titleStyle=Theme.of(context).textTheme.subhead;
    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context , int position){
          return Card(
            color: Colors.white,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                child: getPriorityIcon(this.notelist[position].priority),
                backgroundColor: getPriorityColor(this.notelist[position].priority),
              ),
              title: Text(this.notelist[position].title, style: titleStyle,),
              subtitle: Text(this.notelist[position].date),
              trailing: GestureDetector(
                child: Icon(Icons.delete,color: Colors.grey,),
                onTap: (){    // onn tap of trailling
                _delete(context, notelist[position]);
                },
              ),

              onTap: (){          // on tap of list title
                print("List Tapped");
                NavigatetoEditDetail(this.notelist[position]);
              },
            ),
            
          );
        },
    
    
    );
  }


  //Return the Priority Color

  Color getPriorityColor(int priority){
    switch(priority){
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.yellow;
        break;
      default:
        return Colors.yellow;
    }

  }


  //Return the Priority Icon

  Icon getPriorityIcon(int priority){
    switch(priority){
      case 1:
        return Icon(Icons.play_arrow);
        break;
      case 2:
        return Icon(Icons.keyboard_arrow_right);
        break;
      default:
        return Icon(Icons.keyboard_arrow_right);
    }

  }

void _delete(BuildContext context , Note note) async{
    int result = await databaseHelper.deleteNote(note.id);
    if(result != 0){
      _showSnack(context , 'Note Deleted Successfuly');
      updateList();
    }
}

void _showSnack(BuildContext context , String message) {

    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);

}

  void NavigatetoEditDetail(Note note) async{
    bool result = await Navigator.push(context,MaterialPageRoute(builder: (context) {
      return NoteDetail(note);

    }));

    if (result == true) {
      updateList();
    }

//    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteDetail(),));
  }


void updateList(){

    final Future<Database> dbFutur = databaseHelper.initialzedDatabase();
    dbFutur.then((database){

      Future<List<Note>> noteListFuture = databaseHelper.getNoteList();
      noteListFuture.then((noteList){

        setState(() {
          this.notelist = noteList;
          this.count = noteList.length;
        });
      });
    });
}



}
