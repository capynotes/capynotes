class VideoModel {
  String? url;
  String? noteName;

  VideoModel({this.url, this.noteName});

  VideoModel.fromJson(Map<String, dynamic> json) {
    url = json['videoUrl'];
    noteName = json['noteName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoUrl'] = url;
    data['noteName'] = noteName;
    return data;
  }
}
