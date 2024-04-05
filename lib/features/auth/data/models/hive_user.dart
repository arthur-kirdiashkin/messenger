import 'package:hive_flutter/adapters.dart';

part 'hive_user.g.dart';

@HiveType(typeId: 0)
class HiveUser extends HiveObject {
  @HiveField(0)
  String? uid;

  @HiveField(1)
  String? password;

  @HiveField(2)
  String? email;

  @HiveField(3)
  String? displayName;

  @HiveField(4)
  bool? isVerified;

  HiveUser({
    required this.displayName,
    required this.email,
    required this.password,
    required this.uid,
    this.isVerified,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'display_name': displayName,
      'password': password,
    };
  }

  factory HiveUser.fromJson(Map<String, dynamic> json) {
    return HiveUser(
      uid: json['id'],
      email: json['email'],
      displayName: json['display_name'],
      password: json['password'],
    );
  }

  HiveUser copyWith({
    bool? isVerified,
    String? uid,
    String? email,
    String? password,
    String? displayName,
    int? age,
  }) {
    return HiveUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      password: password ?? this.password,
      displayName: displayName ?? this.displayName,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
