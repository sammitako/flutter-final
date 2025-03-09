class UserModel {
  final String uid;
  final String email;

  UserModel({
    required this.uid,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
    };
  }

  UserModel copyWith({
    String? uid,
    String? email,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
    );
  }
}
