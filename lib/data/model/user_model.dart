class UserModel {
  String id, name, email, password, institute, updateDateTime;
  int status;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.institute,
    this.status,
    this.updateDateTime,
  });

  UserModel.fromJson(Map<String, dynamic> map) {
    id = map['user_id'];
    name = map['user_name'];
    email = map['user_email'];
    password = map['user_password'];
    institute = map['institute'];
    status = map['status'];
    updateDateTime = map['update_dtm'];
  }

  Map<String, dynamic> toJson() => {
        'user_id': id,
        'user_name': name,
        'user_email': email,
        'user_password': password,
        'institute': institute,
        'status': status,
        'update_dtm': updateDateTime.toString() ?? DateTime.now().toString(),
      };
}
