import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ModeratorToolsScreen extends StatelessWidget {
  const ModeratorToolsScreen({super.key});

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
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)?.edit_community ?? "Edit community"),
            leading: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
