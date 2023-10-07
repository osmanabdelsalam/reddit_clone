import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCreateCommunity(BuildContext context) {
    Routemaster.of(context).push('/create-community');
  }

  void navigateToCommunity(BuildContext context, Community community) {
    Routemaster.of(context).push("/r/${community.name.replaceAll(" ", "_")}");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            ListTile(
              title: Text(AppLocalizations.of(context)!.create_community),
              leading: const Icon(Icons.add),
              onTap: () => navigateToCreateCommunity(context),
            ),
            ref.watch(userCommunitiesProvider).when(
                data: (communityList) => Expanded(
                  child: ListView.builder(
                    itemCount: communityList.length,
                    itemBuilder: (context, index) {
                      final community = communityList[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            community.avatar,
                          ),
                        ),
                        title: Text("r/${community.name}"),
                        onTap: () => navigateToCommunity(context, community),
                      );
                    },
                  ),
                ),
                error: (error, stackTrace) => ErrorMessage(error: error.toString()),
                loading: () => const Loader()
            )
          ],
        ),
      ),
    );
  }
}