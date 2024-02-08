class AddFlashcardModel {
  String? front;
  String? back;
  SetID? set;

  AddFlashcardModel({this.front, this.back, this.set});

  AddFlashcardModel.fromJson(Map<String, dynamic> json) {
    front = json['front'];
    back = json['back'];
    set = json['set'] != null ? SetID.fromJson(json['set']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['front'] = front;
    data['back'] = back;
    if (set != null) {
      data['set'] = set!.toJson();
    }
    return data;
  }
}

class SetID {
  int? id;

  SetID({this.id});

  SetID.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    return data;
  }
}
