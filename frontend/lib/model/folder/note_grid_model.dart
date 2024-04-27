class NoteGridModel {
  int? id;
  String? title;
  String? creationTime;
  String? status;
  List<String>? searchFilters;

  NoteGridModel(
      {this.id,
      this.title,
      this.creationTime,
      this.status,
      this.searchFilters});

  NoteGridModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    creationTime = json['creationTime'];
    status = json['status'];
    searchFilters = json['searchFilters'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['creationTime'] = creationTime;
    data['status'] = status;
    data['searchFilters'] = searchFilters;
    return data;
  }
}
