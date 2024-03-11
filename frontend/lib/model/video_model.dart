class VideoModel {
  String? url;
  String? noteName;
  int? userId;

  VideoModel({this.url, this.noteName, this.userId});

  VideoModel.fromJson(Map<String, dynamic> json) {
    url = json['videoUrl'];
    noteName = json['noteName'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoUrl'] = url;
    data['noteName'] = noteName;
    data['userId'] = userId;
    return data;
  }
}
