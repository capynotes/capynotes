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
  String? pdfName;
  int? userId;
  String? audioKey;
  String? creationTime;
  List<FlashcardSetModel>? cardSets;
  NoteStatus? status;

  Note(
      {this.id,
      this.title,
      this.pdfName,
      this.userId,
      this.audioKey,
      this.creationTime,
      this.cardSets,
      this.status});

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    pdfName = json['pdfUrl'];
    userId = json['userId'];
    audioKey = json['audioName'];
    creationTime = json['audioUploadTime'];
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
    data['pdfUrl'] = pdfName;
    data['userId'] = userId;
    data['audioName'] = audioKey;
    data['audioUploadTime'] = creationTime;
    if (cardSets != null) {
      data['cardSets'] = cardSets!.map((v) => v.toJson()).toList();
    }
    data['status'] = status.toString();
    return data;
  }
}
