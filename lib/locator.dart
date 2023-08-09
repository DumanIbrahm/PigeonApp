import 'package:get_it/get_it.dart';
import 'package:pigeon_app/repository/user_repository.dart';
import 'package:pigeon_app/services/fake_firebase_service.dart';
import 'package:pigeon_app/services/firebase_auth_service.dart';
import 'package:pigeon_app/services/firebase_storage_service.dart';
import 'package:pigeon_app/services/firestore_db_service.dart';

GetIt locator = GetIt.instance;

void setUpLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthenticationService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FirestoreDbService());
  locator.registerLazySingleton(() => FirebaseStorageService());
}
