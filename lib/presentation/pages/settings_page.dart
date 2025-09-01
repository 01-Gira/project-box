import 'package:flutter/material.dart';
import 'package:core/l10n/app_localizations.dart';
import 'package:core/preferences_helper.dart';
import 'package:project_box/theme_mode_notifier.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode _themeMode = themeModeNotifier.value;
  final _preferencesHelper = PreferencesHelper();

  void _onThemeChanged(ThemeMode? mode) {
    if (mode == null) return;
    setState(() {
      _themeMode = mode;
    });
    themeModeNotifier.value = mode;
    _preferencesHelper.setThemeMode(mode);
  }

    @override
    Widget build(BuildContext context) {
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.settings)),
        body: ListView(
          children: [
            RadioListTile<ThemeMode>(
              title: Text(l10n.system),
              value: ThemeMode.system,
              groupValue: _themeMode,
              onChanged: _onThemeChanged,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.light),
              value: ThemeMode.light,
              groupValue: _themeMode,
              onChanged: _onThemeChanged,
            ),
            RadioListTile<ThemeMode>(
              title: Text(l10n.dark),
              value: ThemeMode.dark,
              groupValue: _themeMode,
              onChanged: _onThemeChanged,
            ),
        ],
      ),
    );
  }
}
