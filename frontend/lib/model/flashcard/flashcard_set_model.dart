import 'package:capynotes/model/flashcard/flashcard_model.dart';

class FlashcardSetModel {
  int? id;
  int? userId;
  String? title;
  String? creationTime;
  List<FlashcardModel>? cards;

  FlashcardSetModel(
      {this.id, this.userId, this.title, this.creationTime, this.cards});

  FlashcardSetModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    title = json['title'];
    creationTime = json['creationTime'];
    if (json['cards'] != null) {
      cards = <FlashcardModel>[];
      json['cards'].forEach((v) {
        cards!.add(FlashcardModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['userId'] = userId;
    data['title'] = title;
    data['creationTime'] = creationTime;
    if (cards != null) {
      data['cards'] = cards!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
