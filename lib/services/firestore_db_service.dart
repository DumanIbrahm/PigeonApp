import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pigeon_app/models/message_model.dart';
import 'package:pigeon_app/models/user_model.dart';
import 'package:pigeon_app/services/database_base.dart';

class FirestoreDbService implements DBBase {
  final FirebaseFirestore firebaseAuth = FirebaseFirestore.instance;

  @override
  Future<bool> saveUser(MyUser user) async {
    //USER MODELİN İÇİNE TAŞIDIM
    // Map<String, dynamic> addedUserMap = user.toMap();
    // addedUserMap['createdAt'] = FieldValue.serverTimestamp();
    // addedUserMap['updatedAt'] = FieldValue.serverTimestamp();
    // YENİ BİR ALAN EKLEMEK İSTERSEK BUNU KULLANABİLİRİZ
    // addedUserMap.addAll(<String, dynamic>{
    //   "userName": user.email!.substring(0, user.email!.indexOf('@')),
    //   "profilUrl": "",
    //   "seviye": 1,
    // });

    await firebaseAuth.collection("users").doc(user.uid).set(user.toMap());

    DocumentSnapshot readUser =
        await FirebaseFirestore.instance.doc("users/${user.uid}").get();
    Map<String, dynamic> readUserMap = readUser.data() as Map<String, dynamic>;
    MyUser readUserModel = MyUser.fromMap(readUserMap);
    return true;
  }

  @override
  Future<MyUser> readUser(String userID) async {
    DocumentSnapshot readUser =
        await firebaseAuth.collection("users").doc(userID).get();
    Map<String, dynamic> readUserMap = readUser.data() as Map<String, dynamic>;
    MyUser readUserModel = MyUser.fromMap(readUserMap);
    return readUserModel;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    var users = await firebaseAuth
        .collection("users")
        .where("userName", isEqualTo: newUserName)
        .get();
    if (users.docs.isNotEmpty) {
      return false;
    } else {
      await firebaseAuth
          .collection("users")
          .doc(userID)
          .update({"userName": newUserName});
      return true;
    }
  }

  Future<bool> updatePhoto(String userID, String profilUrl) async {
    await firebaseAuth
        .collection("users")
        .doc(userID)
        .update({"profilUrl": profilUrl});
    return true;
  }

  @override
  Future<List<MyUser>?> getAllUsers() async {
    QuerySnapshot? snapshot = await firebaseAuth.collection("users").get();
    List<MyUser>? allUsers = [];
    // for (DocumentSnapshot oneUser in snapshot.docs) {
    //   MyUser? oneUserModel = MyUser.fromMap(oneUser.data() as Map<String, dynamic>);
    //   allUsers.add(oneUserModel);
    // }
    allUsers = snapshot.docs
        .map((e) => MyUser.fromMap(e.data() as Map<String, dynamic>))
        .toList();
    return allUsers;
  }

  @override
  Stream<List<MessageModel>>? getMessages(
      String currentUserID, String chatUserID) {
    return firebaseAuth
        .collection("chats")
        .doc(currentUserID + "--" + chatUserID)
        .collection("message")
        .orderBy("date")
        .snapshots()
        .map((event) =>
            event.docs.map((e) => MessageModel.fromMap(e.data())).toList());
  }

  Future<bool> saveMessage(MessageModel messageModel) async {
    var mesajID = firebaseAuth.collection("chats").doc().id;
    var myDocId = "${messageModel.fromWho}--${messageModel.toWho}";
    var receiverUserId = "${messageModel.toWho}--${messageModel.fromWho}";

    var saveMessage = messageModel.toMap();

    await firebaseAuth
        .collection("chats")
        .doc(myDocId)
        .collection("message")
        .doc(mesajID)
        .set(messageModel.toMap());

    saveMessage.update('fromMe', (value) => false);

    await firebaseAuth
        .collection("chats")
        .doc(receiverUserId)
        .collection("message")
        .doc(mesajID)
        .set(saveMessage);

    return true;
  }
}
