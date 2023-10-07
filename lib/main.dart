import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/app_core/commons/error_message.dart';
import 'package:reddit_clone/app_core/commons/loader.dart';
import 'package:reddit_clone/features/auth/controller/auth_controller.dart';
import 'package:reddit_clone/models/user_model.dart';
import 'package:reddit_clone/routers.dart';
import 'package:reddit_clone/theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
      const ProviderScope(

        child: MyApp(),
      )
  );
}


class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {

  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data) => MaterialApp.router(
          title: 'Reddit',
          locale: const Locale("en"), // todo: Add button in the opening screen to switch between supported locales.
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          debugShowCheckedModeBanner: false,
          theme: ref.watch(themeNotifierProvider),
          routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if(data != null) {
                  getData(ref, data);
                  if(userModel != null) {
                    return authenticatedUserRoutes;
                  }
                }

                return unAuthenticatedUserRoutes;
              }
          ),
          routeInformationParser: const RoutemasterParser(),
        ),
        error: (error, stackTrace) => ErrorMessage(error: error.toString()),
        loading: () => const Loader()
    );
  }
}