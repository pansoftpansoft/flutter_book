import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'appointments/Appointments.dart';
import 'contacts/Contacts.dart';
import 'notes/Notes.dart';
import 'tasks/Tasks.dart';
import 'utils.dart' as utils;

void main() {
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;
    runApp(FlutterBook());
  }

  WidgetsFlutterBinding.ensureInitialized();
  startMeUp();
}

class FlutterBook extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text("FlutterBook"),
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.date_range),
                text: "Appointments"),
                Tab(icon: Icon(Icons.date_range),
                text: "Contacts"),
                Tab(icon: Icon(Icons.date_range),
                text: "Notes"),
                Tab(icon: Icon(Icons.date_range),
                text: "Tasks")
              ],
            ),
          ),
          body: TabBarView(
              children:[
                Appointments(),Contacts(), Notes(),Tasks()
              ]
          ),

        ),
      ),
    );
    // TODO: implement build
  }
}
