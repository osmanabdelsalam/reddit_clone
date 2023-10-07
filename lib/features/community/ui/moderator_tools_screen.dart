import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:routemaster/routemaster.dart';

class ModeratorToolsScreen extends StatelessWidget {
  final String name;
  const ModeratorToolsScreen({super.key, required this.name});

  void navigateToEditCommunityScreen(BuildContext context) {
    Routemaster.of(context).push("/edit-community/$name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.moderator_tools ?? "Moderator tools"),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)?.add_moderator ?? "Add moderator"),
            leading: const Icon(Icons.add_moderator),
            onTap: () {},
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)?.edit_community ?? "Edit community"),
            leading: const Icon(Icons.edit),
            onTap: () => navigateToEditCommunityScreen(context),
          ),
        ],
      ),
    );
  }
}
