class VideoModel {
  String? url;
  String? noteName;
  int? userId;
  int? folderID;

  VideoModel({this.url, this.noteName, this.userId, this.folderID});

  VideoModel.fromJson(Map<String, dynamic> json) {
    url = json['videoUrl'];
    noteName = json['noteName'];
    userId = json['userId'];
    folderID = json['folderId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['videoUrl'] = url;
    data['noteName'] = noteName;
    data['userId'] = userId;
    data['folderId'] = folderID ?? 0;
    return data;
  }
}
