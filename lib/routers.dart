
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/ui/login_screen.dart';
import 'package:reddit_clone/features/community/ui/add_moderator_screen.dart';
import 'package:reddit_clone/features/community/ui/community_screen.dart';
import 'package:reddit_clone/features/community/ui/create_community_screen.dart';
import 'package:reddit_clone/features/community/ui/edit_community_screen.dart';
import 'package:reddit_clone/features/community/ui/moderator_tools_screen.dart';
import 'package:reddit_clone/features/home/ui/home_screen.dart';
import 'package:reddit_clone/features/post/ui/add_post_screen.dart';
import 'package:reddit_clone/features/post/ui/add_post_type_screen.dart';
import 'package:reddit_clone/features/user_profile/ui/edit_profile_screen.dart';
import 'package:reddit_clone/features/user_profile/ui/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final unAuthenticatedUserRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});

final authenticatedUserRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CreateCommunityScreen()),
  '/moderator-tools/:name': (route) =>  MaterialPage(child: ModeratorToolsScreen(
    name: route.pathParameters['name']!,
  )),
  '/edit-community/:name': (route) =>  MaterialPage(child: EditCommunityScreen(
    name: route.pathParameters['name']!,
  )),
  '/add-moderators/:name': (routeData) => MaterialPage(
    child: AddModeratorScreen(
      name: routeData.pathParameters['name']!,
    ),
  ),
  '/r/:name': (route) => MaterialPage(child: CommunityScreen(
    name: route.pathParameters['name']!,
  )),
  '/add-post': (routeData) => const MaterialPage(
    child: AddPostScreen(),
  ),
  '/add-post/:type': (routeData) => MaterialPage(
    child: AddPostTypeScreen(
      type: routeData.pathParameters['type']!,
    ),
  ),

  '/u/:uid': (routeData) => MaterialPage(
    child: UserProfileScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),

  '/edit-profile/:uid': (routeData) => MaterialPage(
    child: EditProfileScreen(
      uid: routeData.pathParameters['uid']!,
    ),
  ),
});