class UserModel {
  String id, name, email, password, institute, status, updateDateTime;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.institute,
    this.status,
    this.updateDateTime,
  });

  UserModel.fromMap(Map<String, dynamic> map) {
    id = map['user_id'];
    name = map['user_name'];
    email = map['user_email'];
    password = map['user_password'];
    institute = map['institute'];
    updateDateTime = map['update_dtm'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['user_id'] = id;
    map['user_name'] = name;
    map['user_email'] = email;
    map['user_password'] = password;
    map['institute'] = institute;
    map['update_dtm'] = updateDateTime;

    return map;
  }
}
