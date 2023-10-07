import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/app_core/commons/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    if (!isGuest) {
      return ref.watch(userCommunitiesProvider).when(
        data: (communities) => ref.watch(userPostsProvider(communities)).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final post = data[index];
                return PostCard(post: post);
              },
            );
          },
          error: (error, stackTrace) {
            return ErrorMessage(
              error: error.toString(),
            );
          },
          loading: () => const Loader(),
        ),
        error: (error, stackTrace) => ErrorMessage(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      );
    }
    return ref.watch(userCommunitiesProvider).when(
      data: (communities) => ref.watch(guestPostsProvider).when(
        data: (data) {
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final post = data[index];
              return PostCard(post: post);
            },
          );
        },
        error: (error, stackTrace) {
          return ErrorMessage(
            error: error.toString(),
          );
        },
        loading: () => const Loader(),
      ),
      error: (error, stackTrace) => ErrorMessage(
        error: error.toString(),
      ),
      loading: () => const Loader(),
    );
  }
}
