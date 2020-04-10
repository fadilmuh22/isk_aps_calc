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

  UserModel.fromMap(Map map) {
    id = map['user_id'];
    name = map['user_name'];
    email = map['user_email'];
    password = map['user_password'];
    institute = map['institute'];
    updateDateTime = map['update_dtm'];
  }

  Map<String, dynamic> toMap() => {
        'user_id': id,
        'user_name': name,
        'user_email': email,
        'user_password': password,
        'institute': institute,
        'update_dtm': updateDateTime,
      };
}
