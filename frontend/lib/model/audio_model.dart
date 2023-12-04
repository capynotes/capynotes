import 'package:capynotes/enums/audio_status_enum.dart';

class AudioModel {
  int? id;
  String? name;
  String? url;
  int? userId;
  DateTime? uploadTime;
  String? transcription;
  AudioStatus? status;

  AudioModel(
      {this.id,
      this.name,
      this.url,
      this.userId,
      this.uploadTime,
      this.transcription,
      this.status});

  AudioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    url = json['url'];
    userId = json['userId'];
    uploadTime = DateTime.parse(json['uploadTime']);
    transcription = json['transcription'];
    status = getAudioStatusFromString(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['userId'] = userId;
    data['uploadTime'] = uploadTime.toString();
    data['transcription'] = transcription;
    data['status'] = status.toString();
    return data;
  }
}
