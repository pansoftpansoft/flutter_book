import 'package:flutter/material.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;

class Notes extends StatelessWidget{

  Notes(){
    notesModel.loadData("notes", NotesDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}

