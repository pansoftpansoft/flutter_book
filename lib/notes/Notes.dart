import 'package:flutter/material.dart';
import 'package:flutter_book/notes/NotesEntry.dart';
import 'package:flutter_book/notes/NotesList.dart';
import 'package:scoped_model/scoped_model.dart';
import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NotesModel, notesModel;

class Notes extends StatelessWidget {
  Notes() {
    notesModel.loadData("notes", NotesDBWorker.db);
  }


  Widget build(BuildContext inContext) {

    print("## Notes.build()");

    return ScopedModel<NotesModel>(
        model : notesModel,
        child : ScopedModelDescendant<NotesModel>(
            builder : (BuildContext inContext, Widget inChild, NotesModel inModel) {
              return IndexedStack(
                  index : inModel.stackIndex,
                  children : [
                    NotesList(),
                    NotesEntry()
                  ] /* End IndexedStack children. */
              ); /* End IndexedStack. */
            } /* End ScopedModelDescendant builder(). */
        ) /* End ScopedModelDescendant. */
    ); /* End ScopedModel. */

  } /* End build(). */

}
