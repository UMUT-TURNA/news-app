import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../bloc/settings_cubit.dart';
import '../../localizations/localizations.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late final SettingsCubit settings;
  bool previousDarkMode = false;
  String previousLanguage = '';

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    loadSettings();
    super.initState();
  }

  void loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? darkMode = prefs.getBool('darkMode');
    String? language = prefs.getString('language');

    if (darkMode != null && language != null) {
      setState(() {
        previousDarkMode = darkMode;
        previousLanguage = language;
        settings.changeDarkMode(darkMode);
        settings.changeLanguage(language);
      });
    }
  }

  void saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', previousDarkMode);
    prefs.setString('language', previousLanguage);
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(
          AppLocalizations.of(context).getTranslate('language_selection'),
        ),
        message: Text(
          AppLocalizations.of(context).getTranslate('language_selection2'),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              setState(() {
                previousLanguage = "tr";
                settings.changeLanguage("tr");
              });
              Navigator.pop(context);
            },
            child: const Text('Türkçe'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                previousLanguage = "en";
                settings.changeLanguage("en");
              });
              Navigator.pop(context);
            },
            child: const Text('English'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              AppLocalizations.of(context).getTranslate('cancel'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(AppLocalizations.of(context).getTranslate('settings')),
      ),
      body: Column(
        children: [
          InkWell(
            onTap: () {
              _showActionSheet(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.grey.withOpacity(0.3),
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.2),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(Icons.language),
                        ),
                        onTap: () {
                          _showActionSheet(context);
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context).getTranslate('language')} : ${settings.state.language}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_right),
                ],
              ),
            ),
          ),
          Divider(),
          InkWell(
            onTap: () {
              setState(() {
                previousDarkMode = !previousDarkMode;
                settings.changeDarkMode(previousDarkMode);
              });
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  ClipOval(
                    child: Material(
                      color: Colors.grey.withOpacity(0.3),
                      child: InkWell(
                        splashColor: Colors.grey.withOpacity(0.7),
                        child: SizedBox(
                          width: 48,
                          height: 48,
                          child: Icon(Icons.dark_mode_outlined),
                        ),
                        onTap: () {
                          setState(() {
                            previousDarkMode = !previousDarkMode;
                            settings.changeDarkMode(previousDarkMode);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${AppLocalizations.of(context).getTranslate('darkMode')}: ',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Switch(
                    value: previousDarkMode,
                    onChanged: (value) {
                      setState(() {
                        previousDarkMode = value;
                        settings.changeDarkMode(value);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                GoRouter.of(context).go('/welcome');
              },
              child: Text(
                'Çıkış Yap',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: () {
                GoRouter.of(context).go('/ticketlist');
              },
              child: Text(
                'Destek Talebi',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    saveSettings();
    super.dispose();
  }
}
