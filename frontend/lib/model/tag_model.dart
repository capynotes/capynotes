class AddTagModel {
  String? name;
  TagNote? note;

  AddTagModel({this.name, this.note});

  AddTagModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    note = json['note'] != null ? TagNote.fromJson(json['note']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    if (note != null) {
      data['note'] = note!.toJson();
    }
    return data;
  }
}

class TagResponseModel {
  int? id;
  String? name;

  TagResponseModel({this.id, this.name});

  TagResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class TagNote {
  int? id;

  TagNote({this.id});

  TagNote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
