import 'folder_with_count_model.dart';
import 'note_grid_model.dart';

class FolderContentsModel {
  int? id;
  String? title;
  List<dynamic>? items;

  FolderContentsModel({this.id, this.title, this.items});

  FolderContentsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['processedItems'] != null) {
      items = [];
      for (var item in json['processedItems']) {
        if (item["type"] == "F") {
          FolderWithCountModel folderWithCountModel =
              FolderWithCountModel.fromJson(item);
          items!.add(folderWithCountModel);
        } else if (item["type"] == "N") {
          NoteGridModel noteGridModel = NoteGridModel.fromJson(item);
          items!.add(noteGridModel);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    if (items != null) {
      data['processedItems'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
