import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:news/bloc/settings_cubit.dart';
import 'package:news/storage/storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../localizations/localizations.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  bool loading = true;
  late SettingsCubit settings;
  loadApp() async {
    try {
      final storage = AppStorage();
      var data = await storage.readAll();

      if (data["language"] == null) {
        if (kIsWeb) {
          data["language"] = "tr";
          await storage.writeAppSettings(
              language: data["language"], darkMode: data["darkMode"]);
        } else {
          final String defaultLocale = Platform.localeName;
          // en_US
          // tr_TR
          var liste = defaultLocale.split('_');
          // ["en","US"]
          // ["tr", "TR"]
          var isSupported =
              AppLocalizations.delegate.isSupported(Locale(liste[0], ""));
          if (isSupported) {
            data["language"] = liste[0];
            await storage.writeAppSettings(
                language: data["language"], darkMode: data["darkMode"]);
          } else {
            data["language"] = "en";
            await storage.writeAppSettings(
                language: data["language"], darkMode: data["darkMode"]);
          }
        }
      }
      if (data["darkMode"] == null) {
        if (ThemeMode.system == ThemeMode.dark) {
        } else {
          data["darkMode"] = false;
        }
      }
      if (data["loggedIn"] == null) {
        data["loggedIn"] = false;
        data["userInfo"] = [];
        storage.writeUserData(isLoggedIn: false, userInfo: []);
      }

      settings.changeDarkMode(data["darkMode"]);
      settings.changeLanguage(data["language"]);
      if (data["loggedIn"]) {
        settings.userLogin(data["userInfo"]);
      } else {
        settings.userLogout();
      }

      setState(() {
        loading = false;
      });
      if (data["loggedIn"]) {
        GoRouter.of(context).replace("/home");
      } else {
        GoRouter.of(context).replace("/welcome");
      }
    } catch (e) {}
  }

  @override
  void initState() {
    settings = context.read<SettingsCubit>();
    super.initState();
    loadApp();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: loading
              ? Center(child: const CircularProgressIndicator())
              : const Text('loaded')),
    );
  }
}
