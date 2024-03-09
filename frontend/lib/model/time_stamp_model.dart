class Timestamps {
  int? id;
  double? start;
  double? finish;
  String? phrase;

  Timestamps({this.id, this.start, this.finish, this.phrase});

  Timestamps.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'];
    finish = json['finish'];
    phrase = json['phrase'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start'] = start;
    data['finish'] = finish;
    data['phrase'] = phrase;
    return data;
  }
}
