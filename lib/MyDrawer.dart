//import 'package:appfirst/note_list.dart';
//import 'package:flutter/material.dart';
//
//class MyDrawer extends StatefulWidget {
//  @override
//  _MyDrawerState createState() => _MyDrawerState();
//}
//
//class _MyDrawerState extends State<MyDrawer> {
//  @override
//  Widget build(BuildContext context) {
//    return Drawer(
//      child:
//      Column(
//        children: <Widget>[
//
//          UserAccountsDrawerHeader(
//            accountName: Text("New "),
//            accountEmail: Text("me@gmail.com"),
//            currentAccountPicture: CircleAvatar(
//              child: Text("N"),
//            ),
//            arrowColor: Colors.red,
//          ),
//          ListTile(
//            leading: Icon(Icons.account_circle),  // icon on left side
//            title:new Text("Homepage"),          // title
//
//            subtitle: Text("subtitle"),          // 2 line
//            dense: true,                         // smaller and denser
//            trailing: Icon(Icons.account_circle), //icon on right side
//
//            onTap: (){
//              Navigator.of(context).push(MaterialPageRoute(
//                builder : (context) => firstscreen(),   ),
//              );
//
//            },                           // on single click which method
//            onLongPress: (){},                    // on long press which method
//          ),
//
//        ],
//      ),
//    );
//  }
//}
