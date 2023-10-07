import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/app_core/commons/post_card.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/post/controller/post_controller.dart';
import 'package:reddit_clone/features/post/widgets/comment_card.dart';
import 'package:reddit_clone/models/post_model.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({
    super.key,
    required this.postId,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    commentController.dispose();
  }

  void addComment(Post post) {
    ref.read(postControllerProvider.notifier).addComment(
      context: context,
      text: commentController.text.trim(),
      post: post,
    );
    setState(() {
      commentController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;

    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
        data: (data) {
          return Column(
            children: [
              PostCard(post: data),
              if (!isGuest)
                Responsive(
                  child: TextField(
                    onSubmitted: (val) => addComment(data),
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.what_are_your_thoughts ?? 'What are your thoughts?',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ref.watch(getPostCommentsProvider(widget.postId)).when(
                data: (data) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (BuildContext context, int index) {
                        final comment = data[index];
                        return CommentCard(comment: comment);
                      },
                    ),
                  );
                },
                error: (error, stackTrace) {
                  return ErrorMessage(
                    error: error.toString(),
                  );
                },
                loading: () => const Loader(),
              ),
            ],
          );
        },
        error: (error, stackTrace) => ErrorMessage(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}
