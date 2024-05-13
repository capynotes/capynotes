class RegisterModel {
  int? id;
  String? name;
  String? surname;
  String? email;
  String? password;
  String? role;

  RegisterModel(
      {this.id, this.name, this.surname, this.email, this.password, this.role});

  RegisterModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    surname = json['surname'];
    email = json['email'];
    password = json['password'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (id != null) data['id'] = id;
    data['name'] = name;
    data['surname'] = surname;
    data['email'] = email;
    data['password'] = password;
    data['role'] = role;
    return data;
  }
}
