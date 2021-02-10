import 'package:flutter/material.dart';
import 'package:flutter_book/notes/NotesModel.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Note.dart';

class NotesList extends StatelessWidget {
  Widget build(BuildContext inContent) {
    return ScopedModel<NotesModel>(
        model: notesModel,
        child: ScopedModelDescendant<NotesModel>(builder:
            (BuildContext inContext, Widget inChild, NotesModel inModel) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add, color: Colors.white),
              onPressed: () {
                notesModel.entityBeingEdited = Note();
                notesModel.setColor(null);
                notesModel.setStackIndex(1);
              }
            ),
            body: ListView.builder(
            itemCount: notesModel.entityList.length,
              itemBuilder: (BuildContext inBuildContext, int inIndex) {
                Note note = notesModel.entityList[inIndex];
                Color color = Colors.white;
                switch (note.color) {
                  case "red" : color = Colors.red; break;
                  case "green" : color = Colors.green; break;
                  case "blue" : color = Colors.blue; break;
                  case "yellow" : color = Colors.yellow; break;
                  case "grey" : color = Colors.grey; break;
                  case "purple" : color = Colors.purple; break;
                  }
                  return Container();
              }
          ));
        })

    );
  }
}
