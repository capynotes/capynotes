import 'package:capynotes/model/flashcard/flashcard_set_model.dart';
import 'package:capynotes/model/summary_model.dart';

import '../enums/note_status_enum.dart';
import 'tag_model.dart';
import 'transcript_model.dart';

class NoteModel {
  Note? note;
  Transcript? transcript;
  Summary? summary;
  String? audioUrl;
  String? pdfUrl;

  NoteModel(
      {this.note, this.transcript, this.summary, this.audioUrl, this.pdfUrl});

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
  String? pdfKey;
  int? userId;
  String? audioKey;
  String? creationTime;
  List<FlashcardSetModel>? cardSets;
  NoteStatus? status;
  List<TagResponseModel>? tags;

  Note(
      {this.id,
      this.title,
      this.pdfKey,
      this.userId,
      this.audioKey,
      this.creationTime,
      this.cardSets,
      this.status,
      this.tags});

  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    pdfKey = json['pdfKey'];
    userId = json['userId'];
    audioKey = json['audioKey'];
    creationTime = json['creationTime'];
    if (json['cardSets'] != null) {
      cardSets = <FlashcardSetModel>[];
      json['cardSets'].forEach((v) {
        cardSets!.add(FlashcardSetModel.fromJson(v));
      });
    }
    status = getNoteStatusFromString(json['status']);
    if (json['tags'] != null) {
      tags = <TagResponseModel>[];
      json['tags'].forEach((v) {
        tags!.add(TagResponseModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['pdfKey'] = pdfKey;
    data['userId'] = userId;
    data['audioKey'] = audioKey;
    data['creationTime'] = creationTime;
    if (cardSets != null) {
      data['cardSets'] = cardSets!.map((v) => v.toJson()).toList();
    }
    data['status'] = status.toString();
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GenerateNoteFromFileModel {
  String? title;
  int? userId;
  String? audioKey;

  GenerateNoteFromFileModel({this.title, this.userId, this.audioKey});

  GenerateNoteFromFileModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    userId = json['userId'];
    audioKey = json['audioKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['userId'] = userId;
    data['audioKey'] = audioKey;
    return data;
  }
}
