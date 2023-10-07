
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/app_core/constants/firebase_constants.dart';
import 'package:reddit_clone/app_core/failure.dart';
import 'package:reddit_clone/app_core/providers/firebase_providers.dart';
import 'package:reddit_clone/app_core/type_defs.dart';
import 'package:reddit_clone/models/community.dart';

final communityRepositoryProvider = Provider((ref) {
  return CommunityRepository(firestore: ref.watch(firestoreProvider));
});

class CommunityRepository {
  final FirebaseFirestore _firestore;

  CommunityRepository({
    required FirebaseFirestore firestore
  }): _firestore = firestore;

  FutureVoid createCommunity(Community community) async {
    try {
      var communityDoc = await _communities.doc(community.name).get();
      if(communityDoc.exists) {
        throw "community_with_same_name_already_exists";
      }
      
      return right(_communities.doc(community.name).set(community.toMap()));
    } on FirebaseException catch (firebaseException) {
      return left(Failure(firebaseException.message!));
    } catch (exception) {
      return left(Failure(exception.toString()));
    }
  }

  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);

}