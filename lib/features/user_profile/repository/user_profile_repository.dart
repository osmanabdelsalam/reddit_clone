import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/app_core/constants/firebase_constants.dart';
import 'package:reddit_clone/app_core/failure.dart';
import 'package:reddit_clone/app_core/providers/firebase_providers.dart';
import 'package:reddit_clone/app_core/type_defs.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProfileRepositoryProvider = Provider((ref) {
  return UserProfileRepository(firestore: ref.watch(firestoreProvider));
});

class UserProfileRepository {
  final FirebaseFirestore _firestore;
  UserProfileRepository({required FirebaseFirestore firestore}) : _firestore = firestore;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid updateUserAction(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update({
        'action': user.action,
      }));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}