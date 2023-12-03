class AudioModel {
  int? id;
  String? name;
  String? url;
  int? userId;
  DateTime? uploadTime;
  String? transcription;

  AudioModel(
      {this.id,
      this.name,
      this.url,
      this.userId,
      this.uploadTime,
      this.transcription});

  AudioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    userId = json['userId'];
    uploadTime = DateTime.parse(json['uploadTime']);
    transcription = json['transcription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['userId'] = userId;
    data['uploadTime'] = uploadTime.toString();
    data['transcription'] = transcription;
    return data;
  }
}
