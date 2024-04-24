import 'package:capynotes/model/flashcard/flashcard_set_model.dart';
import 'package:capynotes/model/summary_model.dart';

import '../enums/note_status_enum.dart';
import 'transcript_model.dart';

class NoteModel {
  Note? note;
  Transcript? transcript;
  Summary? summary;
  String? audioUrl;

  NoteModel({this.note, this.transcript, this.summary, this.audioUrl});

  NoteModel.fromJson(Map<String, dynamic> json) {
    note = json['note'] != null ? Note.fromJson(json['note']) : null;
    transcript = json['transcript'] != null
        ? Transcript.fromJson(json['transcript'])
        : null;
    summary =
        json['summary'] != null ? Summary.fromJson(json['summary']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (note != null) {
      data['note'] = note!.toJson();
    }
    if (transcript != null) {
      data['transcript'] = transcript!.toJson();
    }
    if (summary != null) {
      data['summary'] = summary!.toJson();
    }
    return data;
  }
}

class Note {
  int? id;
  String? title;
  String? pdfUrl;
  int? userId;
  String? audioName;
  String? audioUploadTime;
  List<FlashcardSetModel>? cardSets;
  NoteStatus? status;

  Note(
      {this.id,
      this.title,
      this.pdfUrl,
      this.userId,
      this.audioName,
      this.audioUploadTime,
      this.cardSets,
      this.status});

  Note.fromJson(Map<String, dynamic> json) {
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
