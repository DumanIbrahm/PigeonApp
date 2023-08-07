import 'dart:math';

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
      'userName':
          userName ?? email.substring(0, email.indexOf('@')) + randomNumber(),
      'profilUrl': profilUrl ??
          "https://t3.ftcdn.net/jpg/03/64/62/36/360_F_364623623_ERzQYfO4HHHyawYkJ16tREsizLyvcaeg.jpg",
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

String randomNumber() {
  int randomSayi = Random().nextInt(999999);
  return randomSayi.toString();
}
