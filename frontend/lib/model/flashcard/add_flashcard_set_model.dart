class AddFlashcardSetModel {
  int? userId;
  String? title;
  NoteID? note;

  AddFlashcardSetModel({this.userId, this.title, this.note});

  AddFlashcardSetModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    title = json['title'];
    note = json['note'] != null ? NoteID.fromJson(json['note']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['title'] = title;
    if (note != null) {
      data['note'] = note!.toJson();
    }
    return data;
  }
}

class NoteID {
  int? id;

  NoteID({this.id});

  NoteID.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
