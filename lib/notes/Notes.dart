import 'package:flutter/material.dart';
//import 'NotesModel.dart' as notesModel;
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;
//import 'NotesModel.dart';

class Notes extends StatelessWidget{

  Notes(){
    notesModel.loadData("notes", NotesDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
    throw UnimplementedError();
  }

}

