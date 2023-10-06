import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/constants/constants.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GoogleSignInButton extends ConsumerWidget {
  const GoogleSignInButton({super.key});

  void signInWithGoogle(BuildContext context,WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ElevatedButton.icon(
          onPressed: () => signInWithGoogle(context, ref),
          icon: Image.asset(
            Constants.googleLogoPath,
            width: 35,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.greyColor,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15)
            )
          ),
          label: Text(
            AppLocalizations.of(context)!.continue_with_google,
            style: const TextStyle(
              fontSize: 18
            ),
          )
      ),
    );
  }
}
