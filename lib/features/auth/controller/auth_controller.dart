import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/features/auth/repository/auth_repository.dart';
import 'package:reddit_clone/app_core/utils.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool> (
        (ref) => AuthController (
            authRepository: ref.watch(authRepositoryProvider),
          ref: ref
        )
);

class AuthController extends StateNotifier<bool> {
  final Ref _ref;
  final AuthRepository _authRepository;

  AuthController({
    required AuthRepository authRepository,
    required Ref ref,
  }): _authRepository = authRepository, _ref = ref, super(false);

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }
}