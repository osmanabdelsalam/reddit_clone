import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reddit_clone/models/community.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModeratorTools(BuildContext context) {
    Routemaster.of(context).push("/moderator-tools/$name");
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
    ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community) => NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return [
                  SliverAppBar(
                    snap: true,
                    floating: true,
                    expandedHeight: 150,
                    flexibleSpace: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.network(
                            community.banner,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Align(
                          alignment: AppLocalizations.of(context)!.localeName == "en"? Alignment.topLeft : Alignment.topRight,
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                              community.avatar,
                            ),
                            radius: 35,
                          ),
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("r/${community.name}", style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19
                            ),),
                            community.mods.contains(user.uid) ?
                            OutlinedButton(
                                onPressed: () => navigateToModeratorTools(context),
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    )
                                ),
                                child: Text(AppLocalizations.of(context)?.tools ?? "Tools")
                            ) :
                            OutlinedButton(
                              onPressed: () => joinCommunity(ref, community, context),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                              ),
                              child: Text(community.members.contains(user.uid) ? 'Joined' : 'Join'),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text('${community.members.length} ${community.members.length > 2? AppLocalizations.of(context)!.members : AppLocalizations.of(context)!.member}'),
                        ),
                      ]),
                    ),
                  )
                ];
              },
              body: const Text("Displaying posts")
          ),
          error: (error,stackTrace) => ErrorMessage(error: error.toString()),
          loading: () => const Loader()
      )
    );
  }
}