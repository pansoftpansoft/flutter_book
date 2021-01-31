import '../BaseModel.dart';

class NotesModel extends BaseModel {
  String color;

  void setColor(String inColor) {
    print("## NotesModel.setColor(): inColor = $inColor");
    color = inColor;
    notifyListeners();
  }
}

NotesModel notesModel = NotesModel();
