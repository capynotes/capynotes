import 'package:flutter_flip_card/flutter_flip_card.dart';

class FlashcardModel {
  int? id;
  String? front;
  String? back;
  FlipCardController controller = FlipCardController();
  FlashcardModel({this.id, this.front, this.back});

  FlashcardModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    front = json['front'];
    back = json['back'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['front'] = front;
    data['back'] = back;
    return data;
  }
}
