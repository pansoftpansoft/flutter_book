import 'package:flutter/material.dart';
import 'package:flutter_book/notes/NotesModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Note.dart';
import 'NotesDBWorker.dart';

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
                  return Container(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: .25,
                      secondaryActions: [
                        IconSlideAction(
                          caption: "Delete",
                          color: Colors.red,
                          icon:  Icons.delete,
                          onTap: ()=> _deleteNote(inContext,note)
                        )
                      ],
                    )
                  );
              }
          ));
        })
    );
  }
  Future _deleteNote(BuildContext inContext, Note inNote) async {

    print("## NotestList._deleteNote(): inNote = $inNote");

    return showDialog(
        context : inContext,
        barrierDismissible : false,
        builder : (BuildContext inAlertContext) {
          return AlertDialog(
              title : Text("Delete Note"),
              content : Text("Are you sure you want to delete ${inNote.title}?"),
              actions : [
                FlatButton(child : Text("Cancel"),
                    onPressed: () {
                      // Just hide dialog.
                      Navigator.of(inAlertContext).pop();
                    }
                ),
                FlatButton(child : Text("Delete"),
                    onPressed : () async {
                      // Delete from database, then hide dialog, show SnackBar, then re-load data for the list.
                      await NotesDBWorker.db.delete(inNote.id);
                      Navigator.of(inAlertContext).pop();
                      Scaffold.of(inContext).showSnackBar(
                          SnackBar(
                              backgroundColor : Colors.red,
                              duration : Duration(seconds : 2),
                              content : Text("Note deleted")
                          )
                      );
                      // Reload data from database to update list.
                      notesModel.loadData("notes", NotesDBWorker.db);
                    }
                )
              ]
          );
        }
    );

  } /* End _deleteNote(). */

}
