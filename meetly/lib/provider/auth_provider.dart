import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meetly/core/repository/auth_repository.dart';
import 'package:meetly/core/sevices/auth_services.dart';
import 'package:meetly/model/user_model.dart';

final authServiceProvider = Provider<AuthServices>((ref) {
  return AuthServices();
});
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(authServiceProvider,), FirebaseAuth.instance);
});

final authStateChaneProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChange;
});


final userDataProvider = FutureProvider<UserModel?>((ref) async {
  final authRepo = ref.watch(authRepositoryProvider);
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid != null) {
    return await authRepo.getUserData(uid);
  }
  return null;
});
