import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/app_core/constants/constants.dart';
import 'package:reddit_clone/app_core/constants/firebase_constants.dart';
import 'package:reddit_clone/app_core/failure.dart';
import 'package:reddit_clone/app_core/providers/firebase_providers.dart';
import 'package:reddit_clone/app_core/type_defs.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

final authRepositoryProvider = Provider(
        (ref) => AuthRepository(
            firestore: ref.read(firestoreProvider),
            auth: ref.read(authProvider),
            googleSignIn: ref.read(googleSignInProvider)
        )
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn
  }): _firestore = firestore, _auth = auth, _googleSignIn = googleSignIn;

  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final googleAuthenticate = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuthenticate?.accessToken,
        idToken: googleAuthenticate?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      UserModel userModel; // todo: refactor later.

      if(userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
            name: userCredential.user?.displayName ?? "No Name",
            profilePicture: userCredential?.user?.photoURL ?? Constants.defaultRedditAvatar,
            banner: Constants.defaultUserBanner,
            uid: userCredential!.user!.uid,
            isAuthenticated: true,
            action: 0,
            awards: []
        ); // todo: work with else section later.
        await _users.doc(userCredential!.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch(firebaseException) {
      throw firebaseException.message!;
    } catch(exception) { return left(Failure(exception.toString())); }
  }

  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

}