class Note{
  int _id;
  String _title;
  String _description;
  String _date;
  int _priority;

  //Note(this._id, this._title, this._description, this._date, this._priority);  // All fields are required
  Note(this._title, this._date, this._priority,[this._description]);  // Description is optional
  Note.withId(this._id, this._title, this._date, this._priority,[this._description]); // Named Constructor in which id also include

  int get priority => _priority;

  set priority(int value) {
    if(value >= 1 && value <=2){    //Condition which tell that if value graeter than 2 and less then one no effect
    _priority = value; }
  }

  String get date => _date;

  set date(String value) {
    _date = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get title => _title;

  set title(String value) {
    if(value.length <=255 ){    //Add condition in constructor
    _title = value;}
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

 // Method to convert Note (Real  Values) object to map In order to store in database

Map<String , dynamic> toMap(){

    var map=Map<String , dynamic>();

    if(id != null){              //Function depend on what to insert or udate
    map['id'] = _id;           //Condition to check the id value from SQFlite Database
    }
    map['title'] = _title;
    map['desciption'] = _description;
    map['date'] = _date;
    map['priority'] = _priority;

 return map;
}

// Reverse of above
// Method to convert Map object to note (Real values)

Note.fromMapObject(Map<String , dynamic> map){

    this._id=map['id'];
    this._priority=map['priority'];
    this._date=map['date'];
    this._description=map['desciption'];
    this._title= map['title'];
}
}