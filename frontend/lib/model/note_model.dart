class NoteModel {
  int? id;
  String? title;
  DateTime? uploadTime;
  NoteModel({this.id, this.title, this.uploadTime});
  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    uploadTime = DateTime.parse(json['uploadTime']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    return data;
  }
}
