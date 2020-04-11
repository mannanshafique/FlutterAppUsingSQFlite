import 'dart:async';
import 'package:appfirst/models/note.dart';
import 'Database/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


// In which we edit or delete ....
class NoteDetail extends StatefulWidget {

  final Note note;
  NoteDetail(this.note);

  @override
  _NoteDetailState createState() {
    return _NoteDetailState(this.note);
  }
}

class _NoteDetailState extends State<NoteDetail> {

  Note note;

  DatabaseHelper helper = DatabaseHelper();

  static var _priorites = ['High', 'Low'];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  _NoteDetailState(this.note);

  @override
  Widget build(BuildContext context) {

    titleController.text = note.title;
    descriptionController.text = note.description;

    TextStyle tts = Theme.of(context).textTheme.title;
    return WillPopScope(
        onWillPop:() {   moveToLastScreen();
       },
     child: Scaffold(
      appBar: AppBar(
        title: Text("Add Note"),
      ),

      body: Padding(
        padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              title: DropdownButton(
                  items: _priorites.map((String dropDownStringItem) {
                    return DropdownMenuItem<String>(
                      value: dropDownStringItem,
                      child: Text(dropDownStringItem),
                    );
                  }).toList(),
                  style: tts,
                  value: getPriorityAsString(note.priority), // default value
                  onChanged: (valueSelectedByUser) {
                    setState(() {
                      debugPrint('User selected $valueSelectedByUser');
                      updatePriority(valueSelectedByUser);
                    });
                  }
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child:TextField(
                style: tts,
                controller: titleController,
                onChanged: (value){
                  debugPrint('Something change in title');
                  updateTitle();
                },
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: tts,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  )
                ),
              ),


            ),

            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child:TextField(
                style: tts,
                controller: descriptionController,
                onChanged: (value){
                  debugPrint('Something change in Description');
                  updateDescription();
                },
                decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: tts,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    )
                ),
              ),

            ),
            Padding(padding: EdgeInsets.only(top: 15.0,bottom: 15.0),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: RaisedButton(
                        onPressed: (){
                          setState(() {
                            debugPrint("Save Button Clicked");
                            _save();
                          });
                        },
                        color: Theme.of(context).primaryColor,
                        textColor:  Theme.of(context).primaryColorLight,
                        child: Text("Save",textScaleFactor: 1.5,),
                         ),
                ),
                SizedBox(height: 20.0,width: 20.0,),
                Expanded(
                  child: RaisedButton(
                    onPressed: (){
                      setState(() {
                        debugPrint("Delete Button Clicked");
                        _delete();
                      });
                    },
                    color: Theme.of(context).primaryColor,
                    textColor:  Theme.of(context).primaryColorLight,
                    child: Text("Delete",textScaleFactor: 1.5,),
                  ),
                ),
              ],
            ),
            ),


          ],
        ),
      ),

    ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }



  // Convert the String priority and save in database
  void updatePriority(String value){
    switch(value){
      case 'High':
        note.priority = 1;
        break;
      case 'Low' :
        note.priority = 2;
        break;
    }
  }

// Convert the int priority from database into string
  String getPriorityAsString(int value){
    String priority;
    switch(value){
      case 1:
        priority = _priorites[0];  //high
        break;
      case 2 :
        priority = _priorites[1];
        break;
    }
    return priority;
  }

  // update the title of  note object
  void updateTitle(){
    note.title = titleController.text;
  }

  // update the description of  note object
  void updateDescription(){
    note.description = descriptionController.text;
  }

  void _save() async{

    note.date =DateFormat.yMMMd().format(DateTime.now());
    int result;
    if(note.id != null){      // Case 1 Update opreation if alreday have
    result = await helper.updateNote(note);
    }
    else {     // Case 2 Insert Operation
      result =  await helper.insertNote(note);
    }

    if(result != 0){
      _showAlert('Status', 'Save Successfuly');
    }else{
      _showAlert('Status', 'Saving Problem');
    }

  }

  void _delete() async {


    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlert('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlert('Status', 'Note Deleted Successfully');
    } else {
      _showAlert('Status', 'Error Occured while Deleting Note');
    }
  }


  void _showAlert(String title, String message){

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context,
        builder: (_) => alertDialog
    );

  }

}

