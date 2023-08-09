import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:pigeon_app/services/storage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  Reference? storageReference;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File fileToUpload) async {
    String? url;
    storageReference = firebaseStorage
        .ref()
        .child(userID)
        .child(fileType)
        .child("profil_photo.png");
    await storageReference!.putFile(fileToUpload);
    url = await storageReference!.getDownloadURL();

    // String fileUrl = "";

    // final ListResult result = await firebaseStorage.ref().listAll();
    // final List<Reference> allFiles = result.items;

    // await Future.forEach<Reference>(allFiles, (file) async {
    //   fileUrl = await file.getDownloadURL();
    // });

    return url;
  }
}
