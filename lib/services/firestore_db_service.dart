import 'package:cloud_firestore/cloud_firestore.dart';
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
    print("Okunan user nesnesi : " + readUserModel.toString());
    return true;
  }
}
