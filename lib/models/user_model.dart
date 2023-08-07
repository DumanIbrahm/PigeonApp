import 'package:cloud_firestore/cloud_firestore.dart';

class MyUser {
  final String uid;
  String email;
  String? userName;
  String? profilUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? seviye;

  MyUser({required this.uid, required this.email});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'userName': userName ?? email.substring(0, email.indexOf('@')),
      'profilUrl': profilUrl ??
          "https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200",
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'updatedAt': updatedAt ?? FieldValue.serverTimestamp(),
      'seviye': seviye ?? 1,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : uid = map['uid'],
        email = map['email'],
        userName = map['userName'],
        profilUrl = map['profilUrl'],
        createdAt = (map['createdAt'] as Timestamp).toDate(),
        updatedAt = (map['updatedAt'] as Timestamp).toDate(),
        seviye = map['seviye'];
}
