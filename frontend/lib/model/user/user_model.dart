class UserModel {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? role;
  String? token;

  UserModel(
      {this.id, this.name, this.surname, this.email, this.role, this.token});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    role = json['role'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['role'] = role;
    data['token'] = token;
    return data;
  }
}
