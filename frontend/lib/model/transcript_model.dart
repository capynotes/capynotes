import 'time_stamp_model.dart';

class Transcript {
  int? id;
  int? noteId;
  String? transcription;
  List<Timestamps>? timestamps;

  Transcript({this.id, this.noteId, this.transcription, this.timestamps});

  Transcript.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteId = json['note_id'];
    transcription = json['transcription'];
    if (json['timestamps'] != null) {
      timestamps = <Timestamps>[];
      json['timestamps'].forEach((v) {
        timestamps!.add(Timestamps.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['note_id'] = noteId;
    data['transcription'] = transcription;
    if (timestamps != null) {
      data['timestamps'] = timestamps!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
