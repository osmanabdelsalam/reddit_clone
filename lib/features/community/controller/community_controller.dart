import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/repository/community_repository.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:reddit_clone/app_core/utils.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:routemaster/routemaster.dart';

final communityControllerProvider = StateNotifierProvider<CommunityController, bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref);
});


class CommunityController extends StateNotifier<bool> {
  final CommunityRepository _communityRepository;
  final Ref _ref;

  CommunityController({required CommunityRepository communityRepository, required Ref ref}): _communityRepository = communityRepository, _ref = ref, super(false);

  void createCommunity(String name, BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.uid??'';

    Community community = Community(
        id: name,
        name: name,
        banner: Constants.defaultUserBanner,
        avatar: Constants.defaultRedditAvatar,
        members: [uid],
        mods: [uid]
    );

    final result = await _communityRepository.createCommunity(community);
    state = false;

    result.fold((l) => showSnackBar(context, AppLocalizations.of(context)?.error(l.message) ?? "Community with same name already exists."), (r) {
      showSnackBar(context, AppLocalizations.of(context)?.community_created_successfully ?? "Community created successfully");
      Routemaster.of(context).pop();
    });
  }
}