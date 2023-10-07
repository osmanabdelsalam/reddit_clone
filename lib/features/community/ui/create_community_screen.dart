import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/features/community/controller/community_controller.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {

  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  void createCommunity() {
    ref.read(communityControllerProvider.notifier).createCommunity(communityNameController.text.trim(), context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.create_community),
      ),
      body: isLoading? const Loader() : Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Align(
                alignment: AppLocalizations.of(context)?.localeName == "en"? Alignment.topLeft: Alignment.topRight,
                child: Text(AppLocalizations.of(context)!.community_name)
            ),
            const SizedBox(height: 10,),
            TextField(
              controller: communityNameController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)?.community_name_hint ?? "r/Community_name",
                filled: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
              ),
              maxLength: 21,
            ),
            const SizedBox(height: 30,),
            ElevatedButton(
              onPressed: () => createCommunity(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
              ),
              child: Text(
                AppLocalizations.of(context)?.create_community ?? "Create community",
                style: const TextStyle(
                  fontSize: 17
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
