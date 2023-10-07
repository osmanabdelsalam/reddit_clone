import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class AddModeratorScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModeratorScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _AddModeratorScreenState();
}

class _AddModeratorScreenState extends ConsumerState<AddModeratorScreen> {
  Set<String> uids = {};
  int counter = 0;

  void addUid(String uid) {
    setState(() {
      uids.add(uid);
    });
  }

  void removeUid(String uid) {
    setState(() {
      uids.remove(uid);
    });
  }

  void saveModerators() {
    ref.read(communityControllerProvider.notifier).addModerators(
      widget.name,
      uids.toList(),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: saveModerators,
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community) => ListView.builder(
          itemCount: community.members.length,
          itemBuilder: (BuildContext context, int index) {
            final member = community.members[index];

            return ref.watch(getUserDataProvider(member)).when(
              data: (user) {
                if (community.mods.contains(member) && counter == 0) {
                  uids.add(member);
                }
                counter++;
                return CheckboxListTile(
                  value: uids.contains(user.uid),
                  onChanged: (val) {
                    if (val!) {
                      addUid(user.uid);
                    } else {
                      removeUid(user.uid);
                    }
                  },
                  title: Text(user.name),
                );
              },
              error: (error, stackTrace) => ErrorMessage(
                error: error.toString(),
              ),
              loading: () => const Loader(),
            );
          },
        ),
        error: (error, stackTrace) => ErrorMessage(
          error: error.toString(),
        ),
        loading: () => const Loader(),
      ),
    );
  }
}
