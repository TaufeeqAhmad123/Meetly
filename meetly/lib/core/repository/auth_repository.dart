import 'package:firebase_auth/firebase_auth.dart';
import 'package:meetly/core/sevices/auth_services.dart';
import 'package:meetly/model/user_model.dart';

class AuthRepository {
  final AuthServices _authServices;

  final FirebaseAuth _auth;
  AuthRepository(this._authServices, this._auth);

  Future<UserModel?> SiginWithGoogle() async {
    UserCredential? user = await _authServices.SiginWithGoogle();
    return user != null ? UserModel.fromFirebaseUser(user.user!) : null;
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Future<UserModel?> getUserData(String uid) async {
    return await _authServices.getUserData(uid);
  }

  Future<void> signOut() async {
    await _authServices.signOut();
  }
}
