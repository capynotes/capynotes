class FolderModel {
  int? id;
  String? title;
  int? userId;
  List<FolderModel>? items;

  FolderModel({this.id, this.title, this.userId, this.items});

  FolderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    userId = json['userId'];
    if (json['items'] != null) {
      items = <FolderModel>[];
      json['items'].forEach((v) {
        items!.add(FolderModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['userId'] = userId;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
