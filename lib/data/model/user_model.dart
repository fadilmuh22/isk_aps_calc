class UserModel {
  String userId, name, email, institute, status, updateDateTime;

  UserModel(
    this.userId,
    this.name,
    this.email,
    this.institute,
    this.status,
    this.updateDateTime,
  );

  UserModel.fromMap(Map<String, dynamic> map) {
    userId = map['user_id'];
    name = map['user_name'];
    email = map['user_email'];
    institute = map['institute'];
    updateDateTime = map['update_dtm'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();

    map['user_id'] = userId;
    map['user_name'] = name;
    map['user_email'] = email;
    map['institute'] = institute;
    map['update_dtm'] = updateDateTime;

    return map;
  }
}
