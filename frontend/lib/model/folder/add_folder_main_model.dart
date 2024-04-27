class AddFolderMainModel {
  String? title;
  int? userId;

  AddFolderMainModel({this.title, this.userId});

  AddFolderMainModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['userId'] = userId;
    return data;
  }
}
