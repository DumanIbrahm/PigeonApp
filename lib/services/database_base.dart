import 'package:pigeon_app/models/message_model.dart';
import 'package:pigeon_app/models/user_model.dart';

abstract class DBBase {
  Future<bool> saveUser(MyUser user);
  Future<MyUser> readUser(String userID);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updatePhoto(String userID, String profilUrl);
  Future<List<MyUser>?> getAllUsers();
  Stream<List<MessageModel>>? getMessages(
      String currentUserID, String chatUserID);
  Future<bool>? saveMessage(MessageModel messageModel);
}
