class CrossReferenceModel {
  int userId;
  int currentNoteId;
  String tag;

  CrossReferenceModel(
      {required this.userId, required this.currentNoteId, required this.tag});

  CrossReferenceModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        currentNoteId = json['currentNoteId'],
        tag = json['tag'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'currentNoteId': currentNoteId,
        'tag': tag,
      };
}
