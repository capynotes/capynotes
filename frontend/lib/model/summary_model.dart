class Summary {
  int? id;
  int? noteId;
  String? summary;

  Summary({this.id, this.noteId, this.summary});

  Summary.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteId = json['note_id'];
    summary = json['summary'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note_id'] = noteId;
    data['summary'] = summary;
    return data;
  }
}
