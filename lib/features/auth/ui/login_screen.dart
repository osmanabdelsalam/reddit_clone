import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/commons/google_sign_in_button.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/app_core/constants/constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/responsive/responsive.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(
          Constants.appLogoPath,
          height: 40,
        ),
        actions: [
          TextButton(
              onPressed: () {

              },
              child: Text( AppLocalizations.of(context)!.skip,
                style: const TextStyle(
                  fontWeight: FontWeight.bold
                ),
              )
          )
        ],
      ),
      body: isLoading? const Loader() : Column (
        children: [
          const SizedBox(height: 30,),
          Text(
            AppLocalizations.of(context)!.dive_into_any_thing,
            style: const TextStyle(
            fontSize: 24,
            letterSpacing: 0.5,
            fontWeight: FontWeight.bold
          ),),
          const SizedBox(height: 30,),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              Constants.loginEmotePath,
              height: 400,
            ),
          ),
          const SizedBox(height: 20,),
          const Responsive(child: GoogleSignInButton()),
        ],
      ),
    );
  }
}
