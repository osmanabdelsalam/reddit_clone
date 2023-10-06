
import 'package:flutter/material.dart';
import 'package:reddit_clone/features/auth/ui/login_screen.dart';
import 'package:routemaster/routemaster.dart';

final unAuthenticatedUserRoutes = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen())
});