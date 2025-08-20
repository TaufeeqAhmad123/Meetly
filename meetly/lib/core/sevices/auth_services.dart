import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meetly/model/user_model.dart';

class AuthServices {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static bool isInitializ = false;

  Future<void> initSigIn() async {
    if (!isInitializ) {
      await _googleSignIn.initialize(
        serverClientId:
            "504501695129-d6kqmvp6hif9ob28cu2m58tf1hnn2jp4.apps.googleusercontent.com",
      );
    }
    isInitializ = true;
  }

  Future<UserCredential?> SiginWithGoogle() async {
    try {
      await initSigIn();
      final GoogleSignInAccount _googleUser = await _googleSignIn
          .authenticate();

      final idToken = _googleUser.authentication.idToken;
      final authorizationClient = _googleUser.authorizationClient;

      GoogleSignInClientAuthorization? authorization = await authorizationClient
          .authorizationForScopes(['email', 'profile']);

      final accesToken = authorization?.accessToken;

      if (accesToken == null) {
        final authorization2 = await authorizationClient.authorizationForScopes(
          ['email', 'profile'],
        );
        if (authorization2?.accessToken == null) {
          throw FirebaseAuthException(
            code: 'Error',
            message: 'Google Sign In failed',
          );
        }
        authorization = authorization2;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
        accessToken: accesToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? user = userCredential.user;
      if (user != null) {
        await _saveUserToFirestore(user);
      }
      return userCredential;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> _saveUserToFirestore(User user) async {
    try {
      final userData = _firestore.collection('user').doc(user.uid);
      //check if user data already store so do not store it again just login e 
      final snapshotData = await userData.get();

      if (!snapshotData.exists) {
        final data = UserModel(
          name: user.displayName ?? '',
          uid: user.uid,
          email: user.email ?? '',
          userName: user.email?.split('@')[0] ?? '',
          bio: 'Hey there! I am using Meetly',
          image: user.photoURL ?? '',
          date: DateTime.now(),
          FCMToken: null,
        ).toMap();
        await userData.set(data);
        
      }
      return ;
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel?> getUserData(String uid) async {
    try {
      DocumentSnapshot snapshot = await _firestore
          .collection('user')
          .doc(uid)
          .get();
      return UserModel.fromDocument(snapshot);
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  static User? getCurrentUser() {
    return _auth.currentUser;
  }
}
