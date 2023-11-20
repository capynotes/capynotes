class ChangePasswordModel {
  int? id;
  String? oldPassword;
  String? newPassword;

  ChangePasswordModel({this.id, this.oldPassword, this.newPassword});

  ChangePasswordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    oldPassword = json['oldPassword'];
    newPassword = json['newPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['oldPassword'] = oldPassword;
    data['newPassword'] = newPassword;
    return data;
  }
}
