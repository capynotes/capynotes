import 'package:capynotes/enums/note_status_enum.dart';
import 'package:capynotes/model/flashcard/flashcard_set_model.dart';

class NoteModel {
  int? id;
  String? title;
  String? pdfUrl;
  int? userId;
  String? audioName;
  String? audioUploadTime;
  List<FlashcardSetModel>? cardSets;
  NoteStatus? status;

  NoteModel(
      {this.id,
      this.title,
      this.pdfUrl,
      this.userId,
      this.audioName,
      this.audioUploadTime,
      this.cardSets,
      this.status});

  NoteModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    pdfUrl = json['pdfUrl'];
    userId = json['userId'];
    audioName = json['audioName'];
    audioUploadTime = json['audioUploadTime'];
    if (json['cardSets'] != null) {
      cardSets = <FlashcardSetModel>[];
      json['cardSets'].forEach((v) {
        cardSets!.add(FlashcardSetModel.fromJson(v));
      });
    }
    status = getNoteStatusFromString(json['status']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['pdfUrl'] = pdfUrl;
    data['userId'] = userId;
    data['audioName'] = audioName;
    data['audioUploadTime'] = audioUploadTime;
    if (cardSets != null) {
      data['cardSets'] = cardSets!.map((v) => v.toJson()).toList();
    }
    data['status'] = status.toString();
    return data;
  }
}
