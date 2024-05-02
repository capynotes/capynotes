class FolderWithCountModel {
  int? id;
  String? title;
  int? folderCount;
  int? noteCount;

  FolderWithCountModel({this.id, this.title, this.folderCount, this.noteCount});

  FolderWithCountModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    folderCount = json['folderCount'];
    noteCount = json['noteCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['folderCount'] = folderCount;
    data['noteCount'] = noteCount;
    return data;
  }
}
