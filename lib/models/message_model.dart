import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String? fromWho;
  final String? toWho;
  final bool? fromMe;
  final String? message;
  final DateTime? date;

  MessageModel(
      {this.fromWho, this.toWho, this.fromMe, this.message, this.date});

  Map<String, dynamic> toMap() {
    return {
      'fromWho': fromWho,
      'toWho': toWho,
      'fromMe': fromMe,
      'message': message,
      'date': date ?? FieldValue.serverTimestamp(),
    };
  }

  MessageModel.fromMap(Map<String, dynamic> map)
      : fromWho = map['fromWho'],
        toWho = map['toWho'],
        fromMe = map['fromMe'],
        message = map['message'],
        date = (map['date'] as Timestamp).toDate();
}
