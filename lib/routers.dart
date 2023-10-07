
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/ui/login_screen.dart';
import 'package:reddit_clone/features/community/ui/community_screen.dart';
import 'package:reddit_clone/features/community/ui/create_community_screen.dart';
import 'package:reddit_clone/features/community/ui/moderator_tools_screen.dart';
import 'package:reddit_clone/features/home/ui/home_screen.dart';
import 'package:routemaster/routemaster.dart';

final unAuthenticatedUserRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});

final authenticatedUserRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/moderator-tools': (_) =>  const MaterialPage(child: ModeratorToolsScreen()),
  '/r/:name': (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  ))
});