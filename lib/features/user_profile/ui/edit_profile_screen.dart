import 'dart:io';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/app_core/constants/constants.dart';
import 'package:reddit_clone/app_core/utils.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_clone/responsive/responsive.dart';
import 'package:reddit_clone/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({
    super.key,
    required this.uid,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;

  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;
  late TextEditingController nameController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          bannerWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      if (kIsWeb) {
        setState(() {
          profileWebFile = res.files.first.bytes;
        });
      } else {
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }
    }
  }

  void save() {
    ref.read(userProfileControllerProvider.notifier).editCommunity(
      profileFile: profileFile,
      bannerFile: bannerFile,
      context: context,
      name: nameController.text.trim(),
      bannerWebFile: bannerWebFile,
      profileWebFile: profileWebFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getUserDataProvider(widget.uid)).when(
      data: (user) => Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.edit_profile ?? "Edit Profile"),
          centerTitle: false,
          actions: [
            TextButton(
              onPressed: save,
              child: Text(AppLocalizations.of(context)?.save ?? "Save"),
            ),
          ],
        ),
        body: isLoading
            ? const Loader()
            : Responsive(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      GestureDetector(
                        onTap: selectBannerImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: const Radius.circular(10),
                          dashPattern: const [10, 4],
                          strokeCap: StrokeCap.round,
                          color: currentTheme.textTheme.bodyText2!.color!,
                          child: Container(
                            width: double.infinity,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: bannerWebFile != null
                                ? Image.memory(bannerWebFile!)
                                : bannerFile != null
                                ? Image.file(bannerFile!)
                                : user.banner.isEmpty || user.banner == Constants.defaultUserBanner
                                ? const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                              ),
                            )
                                : Image.network(user.banner),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 20,
                        child: GestureDetector(
                          onTap: selectProfileImage,
                          child: profileWebFile != null
                              ? CircleAvatar(
                            backgroundImage: MemoryImage(profileWebFile!),
                            radius: 32,
                          )
                              : profileFile != null
                              ? CircleAvatar(
                            backgroundImage: FileImage(profileFile!),
                            radius: 32,
                          )
                              : CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicture),
                            radius: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    hintText: AppLocalizations.of(context)?.name ?? "Name",
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      loading: () => const Loader(),
      error: (error, stackTrace) => ErrorMessage(
        error: error.toString(),
      ),
    );
  }
}
