import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/enums/user_actions.dart';
import 'package:reddit_clone/app_core/providers/storage_repository_provider.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_clone/models/user_model.dart';

final userProfileControllerProvider = StateNotifierProvider<UserProfileController, bool>((ref) {
  final userProfileRepository = ref.watch(userProfileRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(
    userProfileRepository: userProfileRepository,
    storageRepository: storageRepository,
    ref: ref,
  );
});

class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  })  : _userProfileRepository = userProfileRepository,
        _ref = ref,
        _storageRepository = storageRepository,
        super(false);


  void updateUserAction(UserAction action) async {
    UserModel user = _ref.read(userProvider)!;
    user = user.copyWith(action: user.action + action.action);

    final res = await _userProfileRepository.updateUserAction(user);
    res.fold((l) => null, (r) => _ref.read(userProvider.notifier).update((state) => user));
  }
}